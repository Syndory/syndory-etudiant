import 'package:dio/dio.dart';
import 'package:syndory_etudiant/services/dio_client.dart';

// service qui gere les notifications personnelles de l'etudiant
// utilise Dio pour faire les requetes HTTP vers l'API REST de Supabase
// l'API suit le standard PostgREST : les filtres s'ecrivent dans les query params
class NotificationService {
  // on recupere le client Dio qui contient deja les headers Supabase
  final Dio _dio = DioClient.instance;

  // recupere toutes les notifications de l'utilisateur connecte
  // GET /rest/v1/notifications?order=created_at.desc
  // les RLS cote serveur filtrent automatiquement par utilisateur grace au token JWT
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final response = await _dio.get(
      '/notifications',
      queryParameters: {
        // on trie du plus recent au plus ancien
        'order': 'created_at.desc',
      },
    );

    // response.data contient la liste JSON retournee par Supabase
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  // compte uniquement les notifications non lues (pour le badge sur la cloche)
  // GET /rest/v1/notifications?is_read=eq.false&select=id
  // on ne prend que l'id pour ne pas charger le texte inutilement
  Future<int> fetchUnreadCount() async {
    final response = await _dio.get(
      '/notifications',
      queryParameters: {
        // syntaxe PostgREST : "is_read est egal a false"
        'is_read': 'eq.false',
        'select': 'id',
      },
    );

    return (response.data as List).length;
  }

  // marque une notification precise comme lue
  // PATCH /rest/v1/notifications?id=eq.{id}  avec body : { "is_read": true }
  Future<void> markAsRead(String id) async {
    await _dio.patch(
      '/notifications',
      queryParameters: {
        // syntaxe PostgREST : "id est egal a cette valeur"
        'id': 'eq.$id',
      },
      data: {'is_read': true},
    );
  }

  // marque toutes les notifications non lues de l'utilisateur comme lues
  // PATCH /rest/v1/notifications?user_id=eq.{userId}&is_read=eq.false
  Future<void> markAllAsRead() async {
    // l'id de l'utilisateur est fourni par le service auth via DioClient
    final userId = DioClient.userId;

    // si personne n'est connecte on ne fait rien
    if (userId == null) return;

    await _dio.patch(
      '/notifications',
      queryParameters: {
        'user_id': 'eq.$userId',
        // on ne modifie que celles pas encore lues
        'is_read': 'eq.false',
      },
      data: {'is_read': true},
    );
  }
}
