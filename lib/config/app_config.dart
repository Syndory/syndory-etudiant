// configuration globale de l'application
// on met les constantes du backend ici pour pouvoir les retrouver facilement
class AppConfig {
  // adresse du projet Supabase (base de toutes les requetes)
  static const String supabaseUrl = 'https://xxcwmwftjliagwykluex.supabase.co';

  // cle publique (anon key) — pas de secret ici, c'est fait pour etre exposee
  // les vraies restrictions de securite sont gereees par les RLS cote serveur
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4Y3dtd2Z0amxpYWd3eWtsdWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NzQ0MzAsImV4cCI6MjA5MzE1MDQzMH0'
      '.rXSTVwdjYjd8zdld6rPOHQsbbtoxy41IJPvlCoo-z7I';
}
