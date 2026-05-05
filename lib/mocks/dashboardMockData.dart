// lib/mock_data.dart

class MockData {
  // Flag pour simuler l'absence de cours (pour le test de l'état vide)
  static bool hasCoursesToday = false;

  // 1. Profil de l'utilisateur connecté
  static Map<String, dynamic> currentUser = {
    "id": "u1",
    "nom": "Kofi Hounnou",
    "role": "etudiant", // Changez en 'responsable' pour tester le bandeau admin
    "filiere": "Génie Logiciel — L3",
    "universite": "Université d'Abomey-Calavi",
    "assiduite_globale": 0.85,
  };

  // 2. La session active (pour le bandeau qui clignote)
  // Si null, le bandeau ne s'affiche pas
  static Map<String, dynamic>? activeSession = {
    "id": "sess_01",
    "matiere": "Structures de données & Algorithmes",
    "prof": "Dr. Ahouandjinou",
    "salle": "Amphi B, Bâtiment FAST",
    "est_ouverte": true,
  };

  // 3. Prochain cours (pour la carte "À suivre")
  static Map<String, dynamic>? nextCourse = {
    "matiere": "Systèmes d'exploitation",
    "prof": "Prof. Dossou-Gbété",
    "salle": "Salle 204, Bâtiment INFO",
    "horaire": "10h00 - 12h00",
    "nb_etudiants": 38,
    "temps_restant": "45 MIN",
  };

  // 4. Statistiques rapides
  static int devoirsCount = 3;
  static double presenceRate = 0.85;

  // 5. Les 2 dernières annonces (CDC : aperçu limité à 2)
  static List<Map<String, dynamic>> lastAnnonces = [
    {
      "titre": "Ouverture des inscriptions aux examens de fin de semestre",
      "date": "Aujourd'hui, 08h30",
      "est_nouveau": true,
    },
    {
      "titre": "Mise à jour du calendrier des soutenances UAC",
      "date": "Hier, 14h15",
      "est_nouveau": false,
    }
  ];
}