import 'package:flutter/material.dart';
import 'package:syndory_etudiant/dashboard_mock_data.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/components/dashboard/main_navigation_bar.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération des données depuis le fichier MockData
    final activeSession = MockData.activeSession;
    final nextCourse = MockData.nextCourse;
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. Header (Profil utilisateur dynamique)
            _buildHeader(user),

            // 2. Banner Session Active (Conditionnelle)
            // Affiche le bandeau seulement si 'activeSession' n'est pas null
            if (activeSession != null) 
              const ActiveSessionBanner(),

            // 3. Section "À suivre"
            // Ne s'affiche que s'il y a un prochain cours prévu
            if (nextCourse != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'À suivre',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF052A36),
                  ),
                ),
              ),
              NextCourseCard(courseData: nextCourse),
            ],

            // 4. Emploi du temps (Carrousel horizontal)
            const TimetableSection(),

            // 5. Grille de Statistiques (Présence & Devoirs)
            // Utilise les compteurs venant des MockData
            const StatsGridSection(),

            // 6. Dernières annonces
            // Le composant gère l'affichage des 2 dernières[cite: 1]
            const AnnouncementsSection(),

            // 7. Documents récents
            // Liste des 3 derniers documents[cite: 1]
            const RecentDocumentsSection(),

            // Espacement pour la navigation basse
            const SizedBox(height: 30),
          ],
        ),
      ),
      // 8. Barre de navigation basse (5 destinations)[cite: 1]
      bottomNavigationBar: const MainNavigationBar(currentIndex: 0),
    );
  }

  // Header intégré pour l'exemple, à extraire si besoin
  Widget _buildHeader(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange[100],
            child: const Icon(Icons.person, color: Color(0xFFF06424)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bonjour, ${user['nom']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user['filiere'],
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          // Badge "Responsable" si le rôle le permet[cite: 1]
          if (user['role'] == 'responsable')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF052A36),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Responsable",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}