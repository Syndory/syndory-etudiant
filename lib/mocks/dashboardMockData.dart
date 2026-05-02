// lib/mock_data.dart

class MockData {
  // Flag pour simuler l'absence de cours (pour le test de l'état vide)
  static bool hasCoursesToday = false;

  // 1. Profil de l'utilisateur connecté
  static Map<String, dynamic> currentUser = {
    "id": "u1",
    "nom": "Jean Dupont",
    "role": "etudiant", // Changez en 'responsable' pour tester le bandeau admin
    "filiere": "Architecture Logicielle",
    "assiduite_globale": 0.85,
  };

  // 2. La session active (pour le bandeau qui clignote)
  // Si null, le bandeau ne s'affiche pas
  static Map<String, dynamic>? activeSession = {
    "id": "sess_01",
    "matiere": "Structures de données & Algorithmes",
    "prof": "Dr. Sossa",
    "salle": "Salle 403, Bloc C",
    "est_ouverte": true,
  };

  // 3. Prochain cours (pour la carte "À suivre")
  static Map<String, dynamic>? nextCourse = {
    "matiere": "Macroéconomie avancée",
    "prof": "Prof. N. Addo",
    "salle": "Salle 402, Bloc C",
    "horaire": "11:00 AM - 1:00 PM",
    "nb_etudiants": 42,
    "temps_restant": "45 MIN",
  };

  // 4. Statistiques rapides
  static int devoirsCount = 3;
  static double presenceRate = 0.85;

  // 5. Les 2 dernières annonces (CDC : aperçu limité à 2)
  static List<Map<String, dynamic>> lastAnnonces = [
    {
      "titre": "Ouverture des inscriptions au forum carrière",
      "date": "Aujourd'hui, 08h30",
      "est_nouveau": true,
    },
    {
      "titre": "Mise à jour des horaires de la bibliothèque",
      "date": "Hier, 14h15",
      "est_nouveau": false,
    }
  ];
}