/// ============================================================
///  Configuration Supabase
///  - SUPABASE_URL      : URL du projet Supabase
///  - anonKey           : clé publique (anon), utilisée côté client
///  - serviceRoleKey    : ⚠️  NE JAMAIS utiliser côté frontend
///                        (elle bypass les RLS policies)
/// ============================================================
class SupabaseConfig {
  SupabaseConfig._(); // classe non instanciable

  static const String url = 'https://xxcwmwftjliagwykluex.supabase.co';

  /// Clé publique — safe côté client (les RLS s'appliquent).
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4Y3dtd2Z0amxpYWd3eWtsdWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NzQ0MzAsImV4cCI6MjA5MzE1MDQzMH0'
      '.rXSTVwdjYjd8zdld6rPOHQsbbtoxy41IJPvlCoo-z7I';

  // ── URL de base pour les requêtes PostgREST ─────────────────────
  static String get restUrl => '$url/rest/v1';

  // ── URL de base pour les Edge Functions ────────────────────────
  static String get functionsUrl => '$url/functions/v1';

  // ── URL pour l'authentification Supabase Auth ──────────────────
  static String get authUrl => '$url/auth/v1';
}
