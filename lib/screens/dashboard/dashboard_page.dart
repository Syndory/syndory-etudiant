import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
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
  // service pour les notifications
  final _notifService = NotificationService();

  // nombre de notifications non lues — affiche le badge sur la cloche
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    // on charge le compteur des non-lues au demarrage
    _loadUnreadCount();
  }

  // recupere le nombre de notifications non lues depuis Supabase via Dio
  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notifService.fetchUnreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {
      // si l'API ne repond pas on garde 0 — pas de crash
    }
  }

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
                    color: Color(0xFF052A36),
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

              // Cloche avec badge de notifications non lues
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                  // on rafraichit le badge quand on revient de la page notifications
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
                      // badge rouge — visible seulement s'il y a des notifs non lues
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
