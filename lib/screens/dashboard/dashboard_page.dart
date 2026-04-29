import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart'; 
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';

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

  // ✅ Plus de Scaffold ici — retourne directement le contenu
  return Column(
    children: [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(user),
            if (activeSession != null) const ActiveSessionBanner(),
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
            const TimetableSection(),
            const StatsGridSection(),
            const AnnouncementsSection(),
            const RecentDocumentsSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // ✅ NavBar en bas de la colonne
      AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    ],
  );
}

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
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user['filiere'],
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          if (user['role'] == 'responsable')
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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