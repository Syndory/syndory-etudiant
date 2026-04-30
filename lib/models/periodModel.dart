enum AttendancePeriod { semaine, mois, semestre }

extension AttendancePeriodLabel on AttendancePeriod {
  String get label {
    switch (this) {
      case AttendancePeriod.semaine:
        return 'Semaine';
      case AttendancePeriod.mois:
        return 'Mois';
      case AttendancePeriod.semestre:
        return 'Semestre';
    }
  }
}

// ─── Matière ─────────────────────────────────────────────────────────────────
enum AttendanceStatus { good, warning, critical }

class CourseAttendance {
  final String name;
  final String subtitle;
  final double rate; // 0.0 – 1.0
  final AttendanceStatus status;
  final String? warningMessage;

  const CourseAttendance({
    required this.name,
    required this.subtitle,
    required this.rate,
    required this.status,
    this.warningMessage,
  });
}

// ─── Historique ──────────────────────────────────────────────────────────────
enum HistoryStatus { present, absent, ajour, retard }

extension HistoryStatusInfo on HistoryStatus {
  String get label {
    switch (this) {
      case HistoryStatus.present:
        return 'PRÉSENT';
      case HistoryStatus.absent:
        return 'ABSENT';
      case HistoryStatus.ajour:
        return 'À JOUR';
      case HistoryStatus.retard:
        return 'RETARD';
    }
  }
}

class HistoryEntry {
  final String courseName;
  final String date;
  final HistoryStatus status;
  final String iconPath;

  const HistoryEntry({
    required this.courseName,
    required this.date,
    required this.status,
    required this.iconPath,
  });
}

// ─── Snapshot global par période ─────────────────────────────────────────────
class AttendanceSnapshot {
  final double globalRate;
  final List<CourseAttendance> courses;
  final List<HistoryEntry> history;

  const AttendanceSnapshot({
    required this.globalRate,
    required this.courses,
    required this.history,
  });
}