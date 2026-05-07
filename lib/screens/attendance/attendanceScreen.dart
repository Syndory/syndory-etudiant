import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/attendance/courseAttendanceCard.dart';
import 'package:syndory_etudiant/components/attendance/historyItem.dart';
import 'package:syndory_etudiant/components/attendance/progressring.dart';
import 'package:syndory_etudiant/components/attendance/tabBar.dart';
import 'package:syndory_etudiant/controllers/attendance_controller.dart';
import 'package:syndory_etudiant/models/attendance_model.dart';
import 'package:syndory_etudiant/models/periodModel.dart';
import 'package:syndory_etudiant/models/session_status.dart';
import 'package:syndory_etudiant/screens/attendance/detail_seance_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const AttendanceScreen({super.key, this.navIndex = 2, this.onNavTap});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _controller = AttendanceController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          appBar: AppNavBarNoReturn(title: 'Assiduité'),
          body: SafeArea(child: _buildBody()),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: widget.navIndex,
            onTap: widget.onNavTap,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    if (_controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _controller.refresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
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
        key: ValueKey(_controller.period),
        controller: _controller,
      ),
    );
  }
}

// ─── Corps principal ───────────────────────────────────────────────────────────
class _AttendanceBody extends StatelessWidget {
  final AttendanceController controller;
  const _AttendanceBody({super.key, required this.controller});

  AttendancePeriod _toPeriodEnum(AttendancePeriodFilter f) {
    switch (f) {
      case AttendancePeriodFilter.semaine:
        return AttendancePeriod.semaine;
      case AttendancePeriodFilter.mois:
        return AttendancePeriod.mois;
      case AttendancePeriodFilter.semestre:
        return AttendancePeriod.semestre;
    }
  }

  AttendancePeriodFilter _fromPeriodEnum(AttendancePeriod p) {
    switch (p) {
      case AttendancePeriod.semaine:
        return AttendancePeriodFilter.semaine;
      case AttendancePeriod.mois:
        return AttendancePeriodFilter.mois;
      case AttendancePeriod.semestre:
        return AttendancePeriodFilter.semestre;
    }
  }

  // ─── Mapping MatiereStats → CourseAttendance ──────────────────────────────
  CourseAttendance _toCourseAttendance(MatiereStats s) {
    final AttendanceStatus status;
    if (s.rate < 0.70) {
      status = AttendanceStatus.critical;
    } else if (s.rate < 0.80) {
      status = AttendanceStatus.warning;
    } else {
      status = AttendanceStatus.good;
    }

    final presents = s.presents + s.justified;
    final subtitle =
        '$presents présence${presents > 1 ? 's' : ''} '
        'sur ${s.total} séance${s.total > 1 ? 's' : ''}';

    String? warningMessage;
    if (s.rate < 0.30) {
      warningMessage =
          'Taux critique ! Vous risquez d\'être exclu des examens.';
    } else if (s.rate < 0.70) {
      warningMessage =
          'Taux insuffisant. Contactez votre responsable pédagogique.';
    }

    return CourseAttendance(
      name: s.matiereName,
      subtitle: subtitle,
      rate: s.rate,
      status: status,
      warningMessage: warningMessage,
    );
  }

  // ─── Mapping AttendanceEntry → HistoryEntry ───────────────────────────────
  HistoryEntry _toHistoryEntry(AttendanceEntry e) {
    final HistoryStatus historyStatus;
    switch (e.status) {
      case PresenceStatus.present:
        historyStatus = HistoryStatus.present;
        break;
      case PresenceStatus.absent:
        historyStatus = HistoryStatus.absent;
        break;
      case PresenceStatus.justified:
        historyStatus = HistoryStatus.ajour;
        break;
      case PresenceStatus.late:
        historyStatus = HistoryStatus.retard;
        break;
    }

    final words = e.matiereName.trim().split(' ');
    final iconPath = words.length >= 2
        ? '${words[0][0]}${words[1][0]}'.toUpperCase()
        : e.matiereName
              .substring(0, e.matiereName.length.clamp(0, 2))
              .toUpperCase();

    return HistoryEntry(
      courseName: e.matiereName,
      date: _formatDate(e.date),
      status: historyStatus,
      iconPath: iconPath,
    );
  }

  String _formatDate(DateTime d) {
    const jours = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const mois = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    return '${jours[d.weekday - 1]}. ${d.day} ${mois[d.month - 1]}.';
  }

  // ─── Navigation vers le détail avec les vraies données ───────────────────
  void _openDetail(BuildContext context, AttendanceEntry entry) {
    final SessionStatus sessionStatus;
    switch (entry.status) {
      case PresenceStatus.present:
        sessionStatus = SessionStatus.presence;
        break;
      case PresenceStatus.absent:
        sessionStatus = entry.justificatifId != null
            ? SessionStatus.justified
            : SessionStatus.absence;
        break;
      case PresenceStatus.justified:
        sessionStatus = SessionStatus.justified;
        break;
      case PresenceStatus.late:
        sessionStatus = SessionStatus.absence;
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailSeanceScreen(
          status: sessionStatus,
          courseName: entry.matiereName,
          professorName: entry.professorFullName,
          presenceId: entry.presenceId,
          date: entry.date,
          startTime: entry.startTime,
          endTime: entry.endTime,
          salleName: entry.salleName ?? 'Salle inconnue',
          justificatifStatus: entry.justificatifStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = controller.filteredEntries;
    final stats = controller.data?.statsByMatiere ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Center(
            child: GlobalProgressRing(rate: controller.periodRate, size: 150),
          ),
          const SizedBox(height: 24),

          Center(
            child: PeriodTabBar(
              selected: _toPeriodEnum(controller.period),
              onChanged: (p) => controller.setPeriod(_fromPeriodEnum(p)),
            ),
          ),
          const SizedBox(height: 28),

          // ── Stats par matière ──────────────────────────────────────
          const _SectionHeader(title: 'Cours par matière'),
          const SizedBox(height: 12),
          if (stats.isEmpty)
            const _EmptySection(message: 'Aucune donnée pour cette période')
          else
            ...stats.map(
              (s) => CourseAttendanceCard(
                key: ValueKey(s.matiereId),
                course: _toCourseAttendance(s),
              ),
            ),

          const SizedBox(height: 20),

          // ── Historique récent ──────────────────────────────────────
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
          if (entries.isEmpty)
            const _EmptySection(message: 'Aucune présence cette semaine')
          else
            ...entries
                .take(5)
                .map(
                  (e) => GestureDetector(
                    onTap: () => _openDetail(context, e), // ← navigation réelle
                    child: RecentHistoryItem(entry: _toHistoryEntry(e)),
                  ),
                ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Center(
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const _SectionHeader({required this.title, this.action});
  @override
  Widget build(BuildContext context) => Row(
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
