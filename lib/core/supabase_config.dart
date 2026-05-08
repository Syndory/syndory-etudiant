/// ============================================================
///  Configuration Supabase
///  Mettre _kLocal = true pour tester en local (supabase start)
///  Mettre _kLocal = false pour pointer sur la prod
/// ============================================================
class SupabaseConfig {
  SupabaseConfig._();

  // ← toggle ici
  static const bool _kLocal = true;

  // ── Production ─────────────────────────────────────────────────
  static const String _prodUrl     = 'https://xxcwmwftjliagwykluex.supabase.co';
  static const String _prodAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4Y3dtd2Z0amxpYWd3eWtsdWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NzQ0MzAsImV4cCI6MjA5MzE1MDQzMH0'
      '.rXSTVwdjYjd8zdld6rPOHQsbbtoxy41IJPvlCoo-z7I';

  // ── Local (supabase start) ──────────────────────────────────────
  // Android émulateur → 10.0.2.2 | iOS simulateur / web → localhost
  static const String _localUrl     = 'https://ebudwigjsmrmeahfudkz.supabase.co';
  static const String _localAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVidWR3aWdqc21ybWVhaGZ1ZGt6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxNzQ4MDEsImV4cCI6MjA5Mzc1MDgwMX0'
      '._fAHHtl9lhEyDgcTdd97j1iZSMi1kqVxuwEJu1qcKgs';

  // ── API publique ────────────────────────────────────────────────
  static String get url     => _kLocal ? _localUrl     : _prodUrl;
  static String get anonKey => _kLocal ? _localAnonKey : _prodAnonKey;

  static String get restUrl      => '$url/rest/v1';
  static String get functionsUrl => '$url/functions/v1';
  static String get authUrl      => '$url/auth/v1';
}
