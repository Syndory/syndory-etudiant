import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

typedef UploadProgressCallback = void Function(double progress);

enum JustificatifApiMode { mock, live }

class JustificatifApiService {
  final Dio _dio;
  final JustificatifApiMode _mode;
  final String? _accessToken;

  JustificatifApiService._(this._dio, this._mode, {String? accessToken})
    : _accessToken = accessToken;

  factory JustificatifApiService.fromEnvironment() {
    const modeValue = String.fromEnvironment(
      'JUSTIFICATIF_API_MODE',
      defaultValue: 'mock',
    );
    final mode = modeValue.toLowerCase().trim();

    if (mode != 'live') {
      return JustificatifApiService.mock();
    }

    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const accessToken = String.fromEnvironment('SUPABASE_ACCESS_TOKEN');

    if (supabaseUrl.isEmpty || anonKey.isEmpty || accessToken.isEmpty) {
      throw StateError(
        'Mode live actif mais SUPABASE_URL, SUPABASE_ANON_KEY ou SUPABASE_ACCESS_TOKEN manquant.',
      );
    }

    return JustificatifApiService.live(
      supabaseUrl: supabaseUrl,
      anonKey: anonKey,
      accessToken: accessToken,
    );
  }

  factory JustificatifApiService.mock({
    Duration networkDelay = const Duration(milliseconds: 500),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://mock.syndory.local',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
      ),
    );
    dio.interceptors.add(
      _MockJustificatifsInterceptor(networkDelay: networkDelay),
    );
    return JustificatifApiService._(dio, JustificatifApiMode.mock);
  }

  factory JustificatifApiService.live({
    required String supabaseUrl,
    required String anonKey,
    required String accessToken,
  }) {
    final normalizedBaseUrl = supabaseUrl.endsWith('/')
        ? supabaseUrl.substring(0, supabaseUrl.length - 1)
        : supabaseUrl;

    final dio = Dio(
      BaseOptions(
        baseUrl: normalizedBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: <String, dynamic>{
          'apikey': anonKey,
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ),
    );
    return JustificatifApiService._(
      dio,
      JustificatifApiMode.live,
      accessToken: accessToken,
    );
  }

  Future<JustificatifsDashboardData> fetchDashboard() async {
    if (_mode == JustificatifApiMode.live) {
      return _fetchDashboardFromRest();
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/justificatifs/dashboard',
    );
    final data = response.data;
    if (data != null) {
      return JustificatifsDashboardData.fromJson(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      type: DioExceptionType.unknown,
      error: 'Réponse dashboard vide',
    );
  }

  Future<String> uploadJustificatifFile({
    required String fileName,
    String? filePath,
    List<int>? fileBytes,
    UploadProgressCallback? onProgress,
  }) async {
    if (_mode == JustificatifApiMode.mock) {
      final sanitizedFileName = fileName.replaceAll(' ', '_');
      return 'justificatifs/mock/$sanitizedFileName';
    }

    final token = _accessToken;
    if (token == null || token.isEmpty) {
      throw StateError('Token d’accès manquant pour upload live.');
    }

    final userId = _extractUserIdFromJwt(token);
    if (userId == null || userId.isEmpty) {
      throw StateError('Impossible de lire le user id depuis le token.');
    }

    final bytes = await _resolveFileBytes(
      fileName: fileName,
      filePath: filePath,
      fileBytes: fileBytes,
    );
    final sanitizedFileName = _sanitizeFileName(fileName);
    final objectPath =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$sanitizedFileName';

    await _dio.post<Map<String, dynamic>>(
      '/storage/v1/object/justificatifs/$objectPath',
      data: bytes,
      options: Options(
        headers: {
          'x-upsert': 'false',
          Headers.contentTypeHeader: _contentTypeForFileName(fileName),
        },
      ),
      onSendProgress: (sent, total) {
        if (onProgress == null || total <= 0) return;
        onProgress(sent / total);
      },
    );

    return 'justificatifs/$objectPath';
  }

  Future<void> submitJustification({
    required String presenceId,
    required String fileUrl,
    String? reason,
  }) async {
    final path = _mode == JustificatifApiMode.live
        ? '/functions/v1/submit-justification'
        : '/submit-justification';

    await _dio.post<Map<String, dynamic>>(
      path,
      data: {
        'presence_id': presenceId,
        'file_url': fileUrl,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      },
    );
  }

  Future<JustificatifsDashboardData> _fetchDashboardFromRest() async {
    final absenceRows = await _fetchRows(
      '/rest/v1/presences',
      queryParameters: {
        'select': 'id,session_id,created_at,status',
        'status': 'eq.absent',
        'order': 'created_at.desc',
      },
    );

    final historiqueRows = await _fetchRows(
      '/rest/v1/justificatifs',
      queryParameters: {
        'select':
            'id,presence_id,file_url,reason,status,submitted_at,rejection_reason',
        'order': 'submitted_at.desc',
      },
    );

    final blockingStatusByPresence = <String, bool>{};
    for (final row in historiqueRows) {
      final presenceId = _readString(row, 'presence_id');
      if (presenceId == null || presenceId.isEmpty) continue;
      final status = justificatifStatusFromApi(_readString(row, 'status'));
      if (status == JustificatifStatus.enAttente ||
          status == JustificatifStatus.valide) {
        blockingStatusByPresence[presenceId] = true;
      }
    }

    final presenceById = <String, Map<String, dynamic>>{};
    for (final row in absenceRows) {
      final id = _readString(row, 'id');
      if (id == null || id.isEmpty) continue;
      presenceById[id] = row;
    }

    final historyPresenceIds = historiqueRows
        .map((entry) => _readString(entry, 'presence_id'))
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    final missingPresenceIds = historyPresenceIds
        .where((id) => !presenceById.containsKey(id))
        .toList();

    if (missingPresenceIds.isNotEmpty) {
      final missingPresenceRows = await _fetchRows(
        '/rest/v1/presences',
        queryParameters: {
          'select': 'id,session_id,created_at,status',
          'id': _toInFilter(missingPresenceIds),
        },
      );
      for (final row in missingPresenceRows) {
        final id = _readString(row, 'id');
        if (id == null || id.isEmpty) continue;
        presenceById[id] = row;
      }
    }

    final sessionIds = presenceById.values
        .map((entry) => _readString(entry, 'session_id'))
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final sessionById = <String, Map<String, dynamic>>{};
    if (sessionIds.isNotEmpty) {
      final sessionRows = await _fetchRows(
        '/rest/v1/sessions',
        queryParameters: {
          'select': 'id,seance_id',
          'id': _toInFilter(sessionIds),
        },
      );
      for (final row in sessionRows) {
        final id = _readString(row, 'id');
        if (id == null || id.isEmpty) continue;
        sessionById[id] = row;
      }
    }

    final seanceIds = sessionById.values
        .map((entry) => _readString(entry, 'seance_id'))
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final seanceById = <String, Map<String, dynamic>>{};
    if (seanceIds.isNotEmpty) {
      final seanceRows = await _fetchRows(
        '/rest/v1/seances',
        queryParameters: {
          'select': 'id,matiere_id,date,start_time,end_time',
          'id': _toInFilter(seanceIds),
        },
      );
      for (final row in seanceRows) {
        final id = _readString(row, 'id');
        if (id == null || id.isEmpty) continue;
        seanceById[id] = row;
      }
    }

    final matiereIds = seanceById.values
        .map((entry) => _readString(entry, 'matiere_id'))
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final matiereNameById = <String, String>{};
    if (matiereIds.isNotEmpty) {
      final matiereRows = await _fetchRows(
        '/rest/v1/matieres',
        queryParameters: {'select': 'id,name', 'id': _toInFilter(matiereIds)},
      );
      for (final row in matiereRows) {
        final id = _readString(row, 'id');
        final name = _readString(row, 'name');
        if (id == null || id.isEmpty || name == null || name.isEmpty) continue;
        matiereNameById[id] = name;
      }
    }

    _SeanceContext? contextForPresence(String presenceId) {
      final presence = presenceById[presenceId];
      if (presence == null) return null;
      final sessionId = _readString(presence, 'session_id');
      if (sessionId == null || sessionId.isEmpty) return null;
      final session = sessionById[sessionId];
      if (session == null) return null;
      final seanceId = _readString(session, 'seance_id');
      if (seanceId == null || seanceId.isEmpty) return null;
      final seance = seanceById[seanceId];
      if (seance == null) return null;

      final matiereId = _readString(seance, 'matiere_id');
      final matiereName = matiereId == null ? null : matiereNameById[matiereId];

      return _SeanceContext(
        courseName: matiereName ?? 'Cours',
        date: _parseDate(_readString(seance, 'date')),
        startTime: _parseTime(_readString(seance, 'start_time')),
        endTime: _parseTime(_readString(seance, 'end_time')),
      );
    }

    final pendingAbsences = <AbsenceEnAttente>[];
    for (final row in absenceRows) {
      final presenceId = _readString(row, 'id');
      if (presenceId == null || presenceId.isEmpty) continue;
      if (blockingStatusByPresence[presenceId] == true) continue;

      final context = contextForPresence(presenceId);
      final fallbackDate = _parseDateTime(_readString(row, 'created_at'));
      final date = context?.date ?? fallbackDate;

      pendingAbsences.add(
        AbsenceEnAttente(
          id: presenceId,
          courseName: context?.courseName ?? 'Cours',
          date: _formatDateLabel(date),
          timeRange: _formatTimeRange(context?.startTime, context?.endTime),
        ),
      );
    }

    final historiqueCompact = <JustificatifHistorique>[];
    final historiqueDetaille = <JustificatifHistoriqueDetaille>[];

    for (final row in historiqueRows) {
      final justificationId = _readString(row, 'id');
      final presenceId = _readString(row, 'presence_id');
      if (justificationId == null ||
          justificationId.isEmpty ||
          presenceId == null ||
          presenceId.isEmpty) {
        continue;
      }

      final context = contextForPresence(presenceId);
      final submittedAt = _parseDateTime(_readString(row, 'submitted_at'));
      final reason = _readString(row, 'reason');
      final fileUrl = _readString(row, 'file_url') ?? '';
      final fileName = _extractFileName(fileUrl);
      final status = justificatifStatusFromApi(_readString(row, 'status'));
      final rejectionReason = _readString(row, 'rejection_reason');

      historiqueCompact.add(
        JustificatifHistorique(
          id: justificationId,
          title: (reason != null && reason.isNotEmpty) ? reason : fileName,
          submittedDate: 'Soumis le ${_formatDateLabel(submittedAt)}',
          status: status,
        ),
      );

      historiqueDetaille.add(
        JustificatifHistoriqueDetaille(
          id: justificationId,
          courseName: context?.courseName ?? 'Cours',
          date: _formatDateLabel(context?.date ?? submittedAt),
          period: _periodFromRange(context?.startTime, context?.endTime),
          fileName: fileName,
          status: status,
          rejectionReason: (rejectionReason == null || rejectionReason.isEmpty)
              ? null
              : rejectionReason,
        ),
      );
    }

    return JustificatifsDashboardData(
      pendingAbsences: pendingAbsences,
      historiqueCompact: historiqueCompact,
      historiqueDetaille: historiqueDetaille,
    );
  }

  Future<List<int>> _resolveFileBytes({
    required String fileName,
    String? filePath,
    List<int>? fileBytes,
  }) async {
    if (filePath != null && filePath.isNotEmpty) {
      return File(filePath).readAsBytes();
    }
    if (fileBytes != null && fileBytes.isNotEmpty) {
      return fileBytes;
    }

    throw DioException(
      requestOptions: RequestOptions(path: '/storage/v1/object/justificatifs'),
      type: DioExceptionType.unknown,
      error: 'Aucun contenu de fichier fourni pour $fileName',
    );
  }

  Future<List<Map<String, dynamic>>> _fetchRows(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    final rows = response.data ?? const <dynamic>[];
    return rows
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();
  }

  String _toInFilter(List<String> values) {
    final joined = values.map((value) => '"$value"').join(',');
    return 'in.($joined)';
  }

  String? _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    return value.toString();
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  DateTime? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final normalized = value.length == 5 ? '$value:00' : value;
    return DateTime.tryParse('1970-01-01T$normalized');
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  String _formatDateLabel(DateTime? date) {
    if (date == null) return '-';
    const months = <String>[
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '--:-- — --:--';
    String hhmm(DateTime value) =>
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    return '${hhmm(start)} — ${hhmm(end)}';
  }

  String _periodFromRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Journée';
    if (end.hour <= 12) return 'Matin';
    if (start.hour >= 13) return 'Après-midi';
    return 'Journée';
  }

  String _extractFileName(String fileUrl) {
    if (fileUrl.isEmpty) return 'justificatif';
    final sanitized = fileUrl.split('?').first;
    final segments = sanitized.split('/');
    return segments.isEmpty ? 'justificatif' : segments.last;
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  String? _extractUserIdFromJwt(String jwt) {
    final parts = jwt.split('.');
    if (parts.length < 2) return null;
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final sub = json['sub'];
    return sub is String ? sub : null;
  }

  String _contentTypeForFileName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }
}

class _SeanceContext {
  final String courseName;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;

  const _SeanceContext({
    required this.courseName,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class _MockJustificatifsInterceptor extends Interceptor {
  final Duration networkDelay;

  _MockJustificatifsInterceptor({required this.networkDelay});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(networkDelay);

    if (options.path == '/justificatifs/dashboard' &&
        options.method.toUpperCase() == 'GET') {
      handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 200,
          data: mockJustificatifsDashboardData.toJson(),
        ),
      );
      return;
    }

    if (options.path == '/submit-justification' &&
        options.method.toUpperCase() == 'POST') {
      final payload = options.data;
      final data = payload is Map
          ? Map<String, dynamic>.from(payload)
          : const <String, dynamic>{};
      final presenceId = data['presence_id'] as String?;
      final fileUrl = data['file_url'] as String?;

      if (presenceId == null || presenceId.isEmpty) {
        handler.reject(_badRequest(options, 'presence_id est requis'));
        return;
      }
      if (fileUrl == null || fileUrl.isEmpty) {
        handler.reject(_badRequest(options, 'file_url est requis'));
        return;
      }

      handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 200,
          data: const {'success': true},
        ),
      );
      return;
    }

    if (options.path.startsWith('/storage/v1/object/justificatifs/') &&
        options.method.toUpperCase() == 'POST') {
      handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 200,
          data: const {'Key': 'mock'},
        ),
      );
      return;
    }

    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 404,
          data: const {'message': 'Endpoint mock non configuré'},
        ),
      ),
    );
  }

  DioException _badRequest(RequestOptions options, String message) {
    return DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<Map<String, dynamic>>(
        requestOptions: options,
        statusCode: 400,
        data: {'message': message},
      ),
    );
  }
}
