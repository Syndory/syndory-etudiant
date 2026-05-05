import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
import 'package:syndory_etudiant/components/dashboard/empty_state_card.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/screens/annonces/annonces_screen.dart';

class DashboardPage extends StatefulWidget { 
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const DashboardPage({
    super.key,
    this.navIndex = 0, 
    this.onNavTap,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final activeSession = MockData.activeSession;
    final nextCourse = MockData.nextCourse;
    final user = MockData.currentUser;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(user, nextCourse),
              
              if (activeSession != null) const ActiveSessionBanner(),
              
              // Zone de contenu dynamique selon le prochain cours
              if (nextCourse != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: _PlaceholderStats(title: "PRÉSENCE", value: "85%")),
                      SizedBox(width: 15),
                      Expanded(child: _PlaceholderStats(title: "DEVOIRS", value: "3")),
                    ],
                  ),
                ),
                NextCourseCard(courseData: nextCourse),
                const TimetableSection(),
              ] else ...[
                const EmptyStateCard(),
              ],

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  "Annonces",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF052A36),
                  ),
                ),
              ),
              AnnouncementsSection(
                onNavTap: widget.onNavTap!,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  "Documents récents",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF052A36)
                  ),
                ),
              ),
              const RecentDocumentsSection(),
              
               StatsGridSection(
                  navIndex: widget.navIndex,
                  onNavTap: widget.onNavTap!,
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        AppBottomNavBar(
          currentIndex: widget.navIndex,
          onTap: widget.onNavTap,
        ),
      ],
    );
  }

  Widget _buildHeader(Map<String, dynamic> user) {
    final String nom = user['nom'] ?? '';
    // on prend juste le prenom (premier mot du nom complet)
    final String prenom = nom.split(' ').first;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // avatar avec les initiales
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.secondary.withOpacity(0.15),
              child: Text(
                nom.isNotEmpty ? nom[0].toUpperCase() : 'E',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // nom de l'app en orange
                const Text(
                  'Syndory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Bonjour, $prenom',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const Spacer(),
            // badge responsable si besoin
            if (user['role'] == 'responsable')
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Responsable',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Inter'),
                ),
              ),
            // cloche de notification
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const AnnonceScreen(),
                ));
              },
              child: Stack(
                children: [
                  const Icon(Icons.notifications_none_outlined,
                    color: AppColors.primary, size: 26),
                  // point rouge pour indiquer qu'il y a des nouvelles annonces
                  Positioned(
                    right: 0, top: 0,
                    child: Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}