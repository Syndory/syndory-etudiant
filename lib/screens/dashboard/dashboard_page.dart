import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart'; 
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
import 'package:syndory_etudiant/components/dashboard/header.dart';
import 'package:syndory_etudiant/components/dashboard/empty_state_card.dart';
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
    final hasCourses = MockData.hasCoursesToday;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                HeaderSection(user: user),
                
                if (hasCourses) ...[
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
                ] else ...[
                  const EmptyStateCard(),
                ],

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
      ),
    );
  }
}
