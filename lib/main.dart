import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/screens/attendance/attendanceScreen.dart';
import 'package:syndory_etudiant/screens/attendance/emptyAttendanceScreen.dart';
import 'package:syndory_etudiant/screens/dashboard/dashboard_page.dart';
import 'package:syndory_etudiant/screens/calendar/calendar_page.dart';
import 'package:syndory_etudiant/screens/devoir/devoirs_screen.dart';
import 'package:syndory_etudiant/screens/justificatif/justificatifs_tab.dart';
import 'package:syndory_etudiant/screens/matieres/matieres_screen.dart';
import 'package:syndory_etudiant/screens/resources/resources_page.dart';
import 'package:syndory_etudiant/screens/profil/profile_page.dart';
import 'package:syndory_etudiant/profile/controllers/profile_controller.dart';
import 'package:syndory_etudiant/screens/announcements/announcements_screen.dart';
import 'package:syndory_etudiant/providers/devoir_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => DevoirProvider()),
      ],
      child: MaterialApp(
        title: 'Syndory Étudiant',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onNavTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(navIndex: _currentIndex, onNavTap: _onNavTap),
          CalendarPage(navIndex: _currentIndex, onNavTap: _onNavTap),
          JustificatifsTab(navIndex: _currentIndex, onNavTap: _onNavTap),
          AttendanceTab(navIndex: _currentIndex, onNavTap: _onNavTap),
          MatieresScreen(navIndex: _currentIndex, onNavTap: _onNavTap),
          AnnouncementsScreen(navIndex: _currentIndex, onNavTap: _onNavTap),
        ],
      ),
    );
  }
}

/// Onglet Assiduité : bascule entre écran vide et écran rempli.
class AttendanceTab extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const AttendanceTab({required this.navIndex, required this.onNavTap});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  bool _hasData = false;

  @override
  Widget build(BuildContext context) {
    if (_hasData) {
      return AttendanceScreen(
        navIndex: widget.navIndex,
        onNavTap: widget.onNavTap,
      );
    }

    return EmptyAttendanceScreen(
      navIndex: widget.navIndex,
      onNavTap: widget.onNavTap,
      onRefresh: () => setState(() => _hasData = true),
    );
  }
}
