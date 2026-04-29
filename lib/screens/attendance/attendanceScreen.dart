import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/attendance/courseAttendanceCard.dart';
import 'package:syndory_etudiant/components/attendance/historyItem.dart';
import 'package:syndory_etudiant/components/attendance/progressring.dart';
import 'package:syndory_etudiant/components/attendance/tabBar.dart';
import 'package:syndory_etudiant/mocks/attendanceMock.dart';
import 'package:syndory_etudiant/models/periodModel.dart';


class AttendanceScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const AttendanceScreen({
    super.key,
    this.navIndex = 2,
    this.onNavTap,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendancePeriod _selectedPeriod = AttendancePeriod.semaine;

  AttendanceSnapshot get _snapshot => mockData[_selectedPeriod]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: 'Assiduité'),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: _AttendanceBody(
            key: ValueKey(_selectedPeriod),
            snapshot: _snapshot,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (p) => setState(() => _selectedPeriod = p),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }

}

class _AttendanceBody extends StatelessWidget {
  final AttendanceSnapshot snapshot;
  final AttendancePeriod selectedPeriod;
  final ValueChanged<AttendancePeriod> onPeriodChanged;

  const _AttendanceBody({
    super.key,
    required this.snapshot,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: GlobalProgressRing(rate: snapshot.globalRate, size: 150),
          ),
          const SizedBox(height: 24),
          Center(
            child: PeriodTabBar(
              selected: selectedPeriod,
              onChanged: onPeriodChanged,
            ),
          ),
          const SizedBox(height: 28),
          const _SectionHeader(title: 'Cours par matière'),
          const SizedBox(height: 12),
          ...snapshot.courses.map(
            (c) => CourseAttendanceCard(key: ValueKey(c.name), course: c),
          ),
          const SizedBox(height: 20),
          _SectionHeader(
            title: 'Historique récent',
            action: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Voir tout',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...snapshot.history.map((e) => RecentHistoryItem(entry: e)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}