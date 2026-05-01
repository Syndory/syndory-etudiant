import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart'; 
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/empty_state_day_off.dart';
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
                child: Row(
                  children: [
                    Expanded(child: _PlaceholderStats(title: "PRÉSENCE", value: "85%")),
                    SizedBox(width: 15),
                    Expanded(child: _PlaceholderStats(title: "DEVOIRS", value: "3")),
                  ],
                ),
              ),

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
              const AnnouncementsSection(),

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
              
              const SizedBox(height: 30),
            ],
            const TimetableSection(),
            const StatsGridSection(),
            const AnnouncementsSection(),
            const RecentDocumentsSection(),
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Bonjour, ${user['nom']}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Syndory",
                    style: TextStyle(
                      color: Color(0xFFF06424), // Orange Syndory
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    ),
                  ),
                  Text(
                    "Bonjour, Kwame", 
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)
                  ),
                ],
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
          ),
        ],
      ),
    );
  }
}

// Simple Placeholder pour compiler sans erreurs si tes sections ne sont pas prêtes
class _PlaceholderStats extends StatelessWidget {
  final String title;
  final String value;
  const _PlaceholderStats({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}