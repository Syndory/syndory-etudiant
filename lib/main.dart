import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/AppBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/screens/attendance/attendanceScreen.dart';
import 'package:syndory_etudiant/screens/attendance/emptyAttendanceScreen.dart';
import 'package:syndory_etudiant/screens/dashboard/dashboard_page.dart';   
import 'package:syndory_etudiant/screens/calendar/calendar_page.dart';
import 'package:syndory_etudiant/screens/devoir/devoirs_screen.dart';
import 'package:syndory_etudiant/screens/justificatif/justificatifs_tab.dart';
import 'package:syndory_etudiant/screens/matieres/matieres_screen.dart';
import 'package:syndory_etudiant/screens/resources/resources_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syndory Étudiant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
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
          _AttendanceTab(navIndex: _currentIndex, onNavTap: _onNavTap),
          MatieresScreen(navIndex: _currentIndex, onNavTap: _onNavTap),
          DevoirsScreen(navIndex: _currentIndex, onNavTap: _onNavTap),
          ResourcesPage(navIndex: _currentIndex, onNavTap: _onNavTap),
        ],
      ),
    );
  }
}


/// Onglet Assiduité : bascule entre écran vide et écran rempli.
class _AttendanceTab extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const _AttendanceTab({required this.navIndex, required this.onNavTap});

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
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

/// Placeholder pour les onglets non encore implémentés.
class _PlaceholderPage extends StatelessWidget {
  final String label;
  final IconData icon;
  final int navIndex;
  final ValueChanged<int> onNavTap;

  const _PlaceholderPage({
    required this.label,
    required this.icon,
    required this.navIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
    );
  }
}