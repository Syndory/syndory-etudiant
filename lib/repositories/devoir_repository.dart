import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/matiere_model.dart';

/// ============================================================
///  DevoirRepository
///
///  Responsabilité unique : fetcher les matières depuis Supabase
///  (table `matieres`) et les retourner sous forme de List<Matiere>.
///
///  Les RLS de Supabase garantissent que seules les matières
///  accessibles à l'étudiant connecté sont renvoyées.
/// ============================================================
class DevoirRepository {
  DevoirRepository._();

  static final DevoirRepository instance = DevoirRepository._();

  final Dio _dio = DioClient.instance;

  // ── Fetch principal ────────────────────────────────────────────

  /// Récupère toutes les matières accessibles à l'étudiant connecté.
  ///
  /// Retourne une liste vide en cas d'erreur réseau (l'état est
  /// communiqué via l'exception pour que le Provider le gère).
  Future<List<Matiere>> fetchMatieres() async {
    try {
      final response = await _dio.get(
        '/matieres',
        queryParameters: {
          'select': 'id,nom:name,code,created_at',
          'order': 'name.asc',
        },
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Matiere.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Gestion d'erreurs centralisée ──────────────────────────────

  /// Convertit une DioException en message lisible.
  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de connexion dépassé. Vérifiez votre réseau.');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de joindre le serveur. Vérifiez votre connexion.');
    }

    switch (statusCode) {
      case 401:
        return Exception('Session expirée. Veuillez vous reconnecter.');
      case 403:
        return Exception('Accès refusé. Droits insuffisants.');
      case 404:
        return Exception('Ressource introuvable.');
      case 500:
        return Exception('Erreur serveur. Réessayez dans quelques instants.');
      default:
        final serverMessage = e.response?.data is Map 
            ? e.response?.data['message'] 
            : null;
        return Exception(
          'Erreur inattendue (${statusCode ?? "inconnue"}) : ${serverMessage ?? e.message}',
        );
    }
  }
}
