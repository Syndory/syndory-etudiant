import 'package:dio/dio.dart';
import 'package:syndory_etudiant/core/dio_client.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';

class AnnouncementService {
  AnnouncementService._();
  static final AnnouncementService instance = AnnouncementService._();

  final Dio _dio = DioClient.instance;

  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      // On récupère les annonces avec les infos de l'auteur (jointure sur users)
      // On filtre par is_published = true et on trie par date de publication
      final response = await _dio.get(
        '/annonces',
        queryParameters: {
          'select': '*,users!published_by(first_name,last_name,role)',
          'is_published': 'eq.true',
          'order': 'created_at.desc',
        },
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AnnouncementModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Une erreur inattendue est survenue lors de la récupération des annonces.');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de connexion dépassé. Vérifiez votre réseau.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de joindre le serveur. Vérifiez votre connexion.');
    }
    final message = e.response?.data?['message'] ?? 'Erreur lors de la récupération des annonces.';
    return Exception(message);
  }
}
