import 'package:dio/dio.dart';
import 'supabase_config.dart';

/// ============================================================
///  DioClient — Singleton HTTP configuré pour Supabase PostgREST
///
///  Usage :
///    final dio = DioClient.instance;
///    final res = await dio.get('/matieres');
///
///  Pour les requêtes authentifiées, injecter le token JWT via :
///    DioClient.setAuthToken('eyJ...');
///
///  Pour effacer le token (logout) :
///    DioClient.clearAuthToken();
/// ============================================================
class DioClient {
  DioClient._();

  static final Dio _dio = _buildDio();

  /// Instance unique, prête à l'emploi.
  static Dio get instance => _dio;

  // ── Construction initiale ──────────────────────────────────────
  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: SupabaseConfig.restUrl,
        headers: {
          // Clé publique Supabase (obligatoire pour toutes les requêtes).
          'apikey': SupabaseConfig.anonKey,
          // Par défaut on envoie du JSON et on attend du JSON.
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Retourne des objets complets (et non juste les IDs) après insert/update.
          'Prefer': 'return=representation',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // ── Intercepteur de logs (mode debug uniquement) ───────────────
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          assert(() {
            // ignore: avoid_print
            print('[DioClient] → ${options.method} ${options.path}');
            return true;
          }());
          handler.next(options);
        },
        onResponse: (response, handler) {
          assert(() {
            // ignore: avoid_print
            print('[DioClient] ← ${response.statusCode} ${response.requestOptions.path}');
            return true;
          }());
          handler.next(response);
        },
        onError: (DioException e, handler) {
          assert(() {
            // ignore: avoid_print
            print('[DioClient] ✗ ${e.response?.statusCode} ${e.requestOptions.path} — ${e.message}');
            return true;
          }());
          handler.next(e);
        },
      ),
    );

    return dio;
  }

  // ── Gestion du token JWT (Supabase Auth) ───────────────────────

  /// Injecte le Bearer token après un login réussi.
  /// À appeler dès que `supabase.auth.session` renvoie un access_token.
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Supprime le token (à appeler au logout).
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Vérifie si un token est actuellement injecté.
  static bool get hasAuthToken =>
      _dio.options.headers.containsKey('Authorization');

  // ── Client Dio pour les Edge Functions ────────────────────────
  /// Utilise `functionsUrl` comme baseUrl, sinon identique.
  static Dio get functionsClient {
    final current = _dio.options.headers;
    return Dio(
      BaseOptions(
        baseUrl: SupabaseConfig.functionsUrl,
        headers: {...current},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
