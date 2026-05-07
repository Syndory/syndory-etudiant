import 'package:dio/dio.dart';
import 'package:syndory_etudiant/services/dio_client.dart';
import 'package:syndory_etudiant/services/auth_service.dart';
import 'package:syndory_etudiant/models/attendance_model.dart';

class AttendanceService {
  AttendanceService._();
  static final AttendanceService instance = AttendanceService._();

  final Dio _dio = DioClient.instance;

  // ─── Point d'entrée principal ─────────────────────────────────────────────
  Future<AttendanceData> fetchAttendanceData() async {
    try {
      final userId = AuthService.instance.user?['id'] as String?;
      if (userId == null) throw Exception('Utilisateur non connecté');

      // Requête unique avec toutes les jointures nécessaires
      // presences → sessions → seances → matieres / salles / users (prof)
      // presences → justificatifs
      final response = await _dio.get(
        '/presences',
        queryParameters: {
          'student_id': 'eq.$userId',
          'order': 'created_at.desc',
          'select':
              '''
            id,
            session_id,
            status,
            marked_at,
            sessions(
              id,
              seances(
                id,
                date,
                start_time,
                end_time,
                matieres(id,name),
                salles(name),
                users(first_name,last_name)
              )
            ),
            justificatifs(
              id,
              status,
              file_url
            )
          '''
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim(),
        },
      );

      final data = (response.data as List<dynamic>)
          .map((e) => AttendanceEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      final stats = _computeStatsByMatiere(data);
      final rate = _computeGlobalRate(data);

      return AttendanceData(
        entries: data,
        statsByMatiere: stats,
        globalRate: rate,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Récupère le détail d'une présence (pour DetailSeanceScreen) ──────────
  Future<AttendanceEntry?> fetchPresenceDetail(String presenceId) async {
    try {
      final response = await _dio.get(
        '/presences',
        queryParameters: {
          'id': 'eq.$presenceId',
          'select':
              '''
            id,
            session_id,
            status,
            marked_at,
            sessions(
              id,
              seances(
                id,
                date,
                start_time,
                end_time,
                matieres(id,name),
                salles(name),
                users(first_name,last_name)
              )
            ),
            justificatifs(
              id,
              status,
              file_url
            )
          '''
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim(),
          'limit': 1,
        },
      );

      final data = response.data as List<dynamic>;
      if (data.isEmpty) return null;
      return AttendanceEntry.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ─── Calcul stats par matière ─────────────────────────────────────────────
  List<MatiereStats> _computeStatsByMatiere(List<AttendanceEntry> entries) {
    final Map<String, List<AttendanceEntry>> grouped = {};

    for (final e in entries) {
      grouped.putIfAbsent(e.matiereId, () => []).add(e);
    }

    return grouped.entries.map((kv) {
      final list = kv.value;
      return MatiereStats(
        matiereId: kv.key,
        matiereName: list.first.matiereName,
        total: list.length,
        presents: list.where((e) => e.status == PresenceStatus.present).length,
        absents: list.where((e) => e.status == PresenceStatus.absent).length,
        lates: list.where((e) => e.status == PresenceStatus.late).length,
        justified: list
            .where((e) => e.status == PresenceStatus.justified)
            .length,
      );
    }).toList()..sort((a, b) => a.matiereName.compareTo(b.matiereName));
  }

  // ─── Calcul taux global ───────────────────────────────────────────────────
  double _computeGlobalRate(List<AttendanceEntry> entries) {
    if (entries.isEmpty) return 1.0;
    final presentsEtJustifies = entries
        .where(
          (e) =>
              e.status == PresenceStatus.present ||
              e.status == PresenceStatus.justified,
        )
        .length;
    return presentsEtJustifies / entries.length;
  }

  // ─── Gestion erreurs Dio ──────────────────────────────────────────────────
  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de connexion dépassé. Vérifiez votre réseau.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        'Impossible de joindre le serveur. Vérifiez votre connexion.',
      );
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return Exception('Accès non autorisé.');
    }
    return Exception('Erreur de chargement de l\'assiduité.');
  }
}
