import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/components/dashboard/empty_state_card.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
// Notre écran de notifications (Dio + Supabase)
import 'package:syndory_etudiant/screens/notifications/notifications_screen.dart';
// Service pour recuperer le nombre de notifications non lues
import 'package:syndory_etudiant/services/notification_service.dart';
// Service pour recuperer les donnees du dashboard
import 'package:syndory_etudiant/services/dashboard_service.dart';

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
  final _notifService = NotificationService();
  int _unreadCount = 0;
  
  // Future pour les donnees du dashboard
  late Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    _dashboardDataFuture = DashboardService.instance.fetchDashboardData();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notifService.fetchUnreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {
    }
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardDataFuture = DashboardService.instance.fetchDashboardData();
    });
    await _loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F9FC),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF052A36)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Une erreur est survenue :\n${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshDashboard,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF052A36)),
                    child: const Text("Réessayer", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F9FC),
            body: Center(child: Text("Aucune donnée disponible")),
          );
        }

        final activeSession = data.activeSession;
        final nextCourse = data.nextCourse;
        final user = data.user;

        return RefreshIndicator(
          onRefresh: _refreshDashboard,
          color: const Color(0xFF052A36),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildHeader(user, nextCourse),

                    if (activeSession != null) const ActiveSessionBanner(),

                    if (nextCourse != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: _PlaceholderStats(title: "PRÉSENCE", value: "${(data.presenceRate * 100).toStringAsFixed(0)}%")),
                            const SizedBox(width: 15),
                            Expanded(child: _PlaceholderStats(title: "DEVOIRS", value: "${data.devoirsCount}")),
                          ],
                        ),
                      ),
                      NextCourseCard(courseData: nextCourse),
                      TimetableSection(timetable: data.timetable),
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
                      annonces: data.lastAnnonces,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        "Documents récents",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF052A36),
                        ),
                      ),
                    ),
                    RecentDocumentsSection(
                      documents: data.recentDocuments,
                    ),

                    StatsGridSection(
                      navIndex: widget.navIndex,
                      onNavTap: widget.onNavTap!,
                      presenceRate: data.presenceRate,
                      devoirsCount: data.devoirsCount,
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(Map<String, dynamic> user, dynamic nextCourse) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Syndory",
                    style: TextStyle(
                      color: Color(0xFFF06424),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Bonjour, ${user['nom']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              if (user['role'] == 'responsable')
                Container(
                  margin: const EdgeInsets.only(right: 10),
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

              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                  _loadUnreadCount();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF667A81),
                        size: 28,
                      ),
                      if (_unreadCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              _unreadCount > 9 ? '9+' : '$_unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceholderStats extends StatelessWidget {
  final String title;
  final String value;
  const _PlaceholderStats({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
