import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/mocks/dashboardMockData.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/screens/notifications/notifications_screen.dart';
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
  final _notifService = NotificationService();

  // nombre de notifications non lues (pour le badge sur la cloche)
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    // on charge le nombre de notifs non lues au demarrage du dashboard
    _loadUnreadCount();
  }

  // recupere le nombre de notifications non lues depuis Supabase
  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notifService.fetchUnreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {
      // si ca echoue on laisse le badge a zero sans crasher
    }
  }

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
    // nom vient du mock pour l'instant — sera remplace par les donnees de l'API auth
    final String nom = user['nom'] as String? ?? '';
    // on prend juste le prenom (premier mot du nom complet)
    final String prenom = nom.isNotEmpty ? nom.split(' ').first : 'Etudiant';

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
            // cloche de notification — va vers les notifs personnelles
            GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ));
                // quand on revient de la page notifs, on rafraichit le compteur
                _loadUnreadCount();
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_outlined,
                    color: AppColors.primary, size: 26),
                  // badge rouge avec le nombre de non-lues
                  if (_unreadCount > 0)
                    Positioned(
                      right: -4, top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
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
          ],
        ),
      ),
    );
  }
}