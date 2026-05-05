import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../core/supabase_config.dart';
import '../core/dio_client.dart';

/// ============================================================
///  AuthService — Authentification via Supabase Auth REST API
///
///  Utilise l'endpoint natif Supabase Auth (pas PostgREST).
///  Après un login réussi, injecte automatiquement le JWT dans
///  DioClient pour que tous les appels PostgREST soient authentifiés.
///
///  Usage :
///    final result = await AuthService.instance.signIn(email, password);
///    if (result.success) { // naviguer vers l'app }
/// ============================================================
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  // ── État ───────────────────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _accessToken != null;
  Map<String, dynamic>? get user => _user;

  // ── Client Dio dédié à l'auth (baseUrl = authUrl) ─────────────
  late final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: SupabaseConfig.authUrl,
      headers: {
        'apikey': SupabaseConfig.anonKey,
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // ── Login email / mot de passe ─────────────────────────────────

  /// Connecte l'utilisateur et injecte le token dans DioClient.
  /// Retourne `true` si succès, `false` sinon.
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authDio.post(
        '/token',
        queryParameters: {'grant_type': 'password'},
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      _accessToken = data['access_token'] as String;
      _user = data['user'] as Map<String, dynamic>?;

      // Injecter le token dans le client HTTP global
      DioClient.setAuthToken(_accessToken!);

      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Déconnecte l'utilisateur et efface le token.
  Future<void> signOut() async {
    try {
      await _authDio.post(
        '/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
        ),
      );
    } catch (_) {
      // Ignorer les erreurs de logout
    } finally {
      _accessToken = null;
      _user = null;
      DioClient.clearAuthToken();
      notifyListeners();
    }
  }

  // ── Gestion d'erreurs ──────────────────────────────────────────
  String _parseError(DioException e) {
    final statusCode = e.response?.statusCode;
    final body = e.response?.data;

    if (statusCode == 400) {
      final msg = body?['error_description'] as String?;
      if (msg != null && msg.contains('Invalid login credentials')) {
        return 'Email ou mot de passe incorrect.';
      }
      return 'Identifiants invalides.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Impossible de joindre le serveur. Vérifiez votre connexion.';
    }
    return 'Erreur inattendue (${statusCode ?? "inconnue"}).';
  }
}
