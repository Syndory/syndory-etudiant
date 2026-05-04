import 'dart:async';

import 'package:dio/dio.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

class JustificatifApiService {
  final Dio _dio;

  JustificatifApiService._(this._dio);

  factory JustificatifApiService.mock({
    Duration networkDelay = const Duration(milliseconds: 800),
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
    return JustificatifApiService._(dio);
  }

  factory JustificatifApiService.live({
    required String baseUrl,
    String? bearerToken,
  }) {
    final headers = <String, dynamic>{};
    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: headers,
      ),
    );
    return JustificatifApiService._(dio);
  }

  Future<JustificatifsDashboardData> fetchDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/justificatifs/dashboard',
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.unknown,
        error: 'Réponse dashboard vide',
      );
    }
    return JustificatifsDashboardData.fromJson(data);
  }

  Future<String> uploadJustificatifFile({
    required String fileName,
    String? filePath,
    List<int>? fileBytes,
  }) async {
    MultipartFile multipartFile;
    if (filePath != null && filePath.isNotEmpty) {
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      );
    } else if (fileBytes != null && fileBytes.isNotEmpty) {
      multipartFile = MultipartFile.fromBytes(fileBytes, filename: fileName);
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: '/storage/justificatifs/upload'),
        type: DioExceptionType.unknown,
        error: 'Aucun contenu de fichier fourni',
      );
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/storage/justificatifs/upload',
      data: FormData.fromMap({'file': multipartFile}),
      options: Options(contentType: 'multipart/form-data'),
    );
    final data = response.data;
    final fileUrl = data?['file_url'] as String?;
    if (fileUrl == null || fileUrl.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.unknown,
        error: 'Réponse upload invalide',
      );
    }
    return fileUrl;
  }

  Future<void> submitJustification({
    required String presenceId,
    required String fileUrl,
    String? reason,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/submit-justification',
      data: {'presence_id': presenceId, 'file_url': fileUrl, 'reason': reason},
    );
  }
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
          statusCode: 201,
          data: const {'message': 'Justificatif soumis'},
        ),
      );
      return;
    }

    if (options.path == '/storage/justificatifs/upload' &&
        options.method.toUpperCase() == 'POST') {
      final payload = options.data;
      String? fileName;

      if (payload is FormData && payload.files.isNotEmpty) {
        fileName = payload.files.first.value.filename;
      }

      if (fileName == null || fileName.isEmpty) {
        handler.reject(_badRequest(options, 'file est requis'));
        return;
      }

      const allowedExtensions = {'pdf', 'jpg', 'jpeg', 'png'};
      final extension = fileName.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        handler.reject(_badRequest(options, 'Format de fichier non supporté'));
        return;
      }

      final sanitizedFileName = fileName.replaceAll(' ', '_');
      handler.resolve(
        Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 201,
          data: {
            'file_url':
                'https://mock.syndory.local/storage/justificatifs/$sanitizedFileName',
          },
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
