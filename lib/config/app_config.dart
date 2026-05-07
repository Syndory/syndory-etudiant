import 'package:syndory_etudiant/core/supabase_config.dart';

// Point d'entrée unique pour la config Supabase — délègue à SupabaseConfig
// Pour switcher prod ↔ test : changer _kLocal dans supabase_config.dart
class AppConfig {
  static String get supabaseUrl     => SupabaseConfig.url;
  static String get supabaseAnonKey => SupabaseConfig.anonKey;
}
