import 'package:dio/dio.dart';
import 'package:syndory_etudiant/config/app_config.dart';

// client HTTP centralise base sur Dio
// toutes les requetes vers l'API Supabase passent par ici
class DioClient {
  // le token JWT de l'utilisateur connecte
  // c'est la personne qui gere l'auth qui doit remplir cette valeur apres connexion
  // exemple depuis le service auth : DioClient.accessToken = response.data['access_token'];
  static String? accessToken;

  // l'id de l'utilisateur connecte (utile pour markAllAsRead)
  // a remplir en meme temps que accessToken apres la connexion
  static String? userId;

  // instance unique du client Dio — on ne le cree qu'une seule fois
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _buildDio();
    return _instance!;
  }

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        // toutes les requetes commencent par cette adresse
        baseUrl: '${AppConfig.supabaseUrl}/rest/v1',

        responseType: ResponseType.json,

        // si le serveur ne repond pas dans ces delais, on annule la requete
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),

        headers: {
          // cle publique Supabase — obligatoire pour toutes les requetes
          'apikey': AppConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    // intercepteur : s'execute automatiquement avant chaque requete
    // il ajoute le token JWT si l'utilisateur est connecte
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // on ajoute le token seulement s'il a ete fourni par le service auth
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}
