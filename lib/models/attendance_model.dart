// ─── Statut d'une présence (mappe l'enum Supabase) ───────────────────────────
enum PresenceStatus { present, absent, late, justified }

extension PresenceStatusX on PresenceStatus {
  static PresenceStatus fromString(String? s) {
    switch (s) {
      case 'present':
        return PresenceStatus.present;
      case 'absent':
        return PresenceStatus.absent;
      case 'late':
        return PresenceStatus.late;
      case 'justified':
        return PresenceStatus.justified;
      default:
        return PresenceStatus.absent;
    }
  }

  String get label {
    switch (this) {
      case PresenceStatus.present:
        return 'Présent';
      case PresenceStatus.absent:
        return 'Absent';
      case PresenceStatus.late:
        return 'En retard';
      case PresenceStatus.justified:
        return 'Justifié';
    }
  }
}

// ─── Une présence individuelle (1 ligne = 1 séance) ──────────────────────────
class AttendanceEntry {
  final String presenceId;
  final String sessionId;
  final PresenceStatus status;
  final DateTime? markedAt;

  // Infos séance
  final String seanceId;
  final DateTime date;
  final String startTime;
  final String endTime;

  // Infos matière
  final String matiereId;
  final String matiereName;

  // Infos salle
  final String? salleName;

  // Infos professeur
  final String? professorFirstName;
  final String? professorLastName;

  // Justificatif éventuel
  final String? justificatifId;
  final String? justificatifStatus; // 'en_attente' | 'validé' | 'rejeté'
  final String? justificatifFileUrl;

  AttendanceEntry({
    required this.presenceId,
    required this.sessionId,
    required this.status,
    this.markedAt,
    required this.seanceId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.matiereId,
    required this.matiereName,
    this.salleName,
    this.professorFirstName,
    this.professorLastName,
    this.justificatifId,
    this.justificatifStatus,
    this.justificatifFileUrl,
  });

  String get professorFullName {
    final parts = [
      professorFirstName,
      professorLastName,
    ].where((p) => p != null && p.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(' ') : 'Professeur';
  }

  String get timeRange => '$startTime — $endTime';

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) {
    final seance = json['sessions']?['seances'] as Map<String, dynamic>? ?? {};
    final matiere = seance['matieres'] as Map<String, dynamic>? ?? {};
    final salle = seance['salles'] as Map<String, dynamic>?;
    final professor = seance['users'] as Map<String, dynamic>?;

    // Justificatif (peut être null ou liste vide)
    final justifs = json['justificatifs'] as List<dynamic>?;
    final justif = (justifs != null && justifs.isNotEmpty)
        ? justifs.first as Map<String, dynamic>
        : null;

    return AttendanceEntry(
      presenceId: json['id'] as String,
      sessionId: json['session_id'] as String,
      status: PresenceStatusX.fromString(json['status'] as String?),
      markedAt: json['marked_at'] != null
          ? DateTime.tryParse(json['marked_at'] as String)
          : null,
      seanceId: seance['id'] as String? ?? '',
      date:
          DateTime.tryParse(seance['date'] as String? ?? '') ?? DateTime.now(),
      startTime: (seance['start_time'] as String? ?? '').substring(0, 5),
      endTime: (seance['end_time'] as String? ?? '').substring(0, 5),
      matiereId: matiere['id'] as String? ?? '',
      matiereName: matiere['name'] as String? ?? 'Matière inconnue',
      salleName: salle?['name'] as String?,
      professorFirstName: professor?['first_name'] as String?,
      professorLastName: professor?['last_name'] as String?,
      justificatifId: justif?['id'] as String?,
      justificatifStatus: justif?['status'] as String?,
      justificatifFileUrl: justif?['file_url'] as String?,
    );
  }
}

// ─── Stats par matière ────────────────────────────────────────────────────────
class MatiereStats {
  final String matiereId;
  final String matiereName;
  final int total;
  final int presents;
  final int absents;
  final int lates;
  final int justified;

  MatiereStats({
    required this.matiereId,
    required this.matiereName,
    required this.total,
    required this.presents,
    required this.absents,
    required this.lates,
    required this.justified,
  });

  double get rate {
    if (total == 0) return 1.0;
    return (presents + justified) / total;
  }
}

// ─── Données complètes de la page assiduité ───────────────────────────────────
class AttendanceData {
  final List<AttendanceEntry> entries;
  final List<MatiereStats> statsByMatiere;
  final double globalRate;

  AttendanceData({
    required this.entries,
    required this.statsByMatiere,
    required this.globalRate,
  });

  bool get isEmpty => entries.isEmpty;

  /// Filtre les entrées par période
  List<AttendanceEntry> filterByPeriod(AttendancePeriodFilter period) {
    final now = DateTime.now();
    return entries.where((e) {
      switch (period) {
        case AttendancePeriodFilter.semaine:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return e.date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
        case AttendancePeriodFilter.mois:
          return e.date.year == now.year && e.date.month == now.month;
        case AttendancePeriodFilter.semestre:
          // 6 derniers mois
          return e.date.isAfter(now.subtract(const Duration(days: 180)));
      }
    }).toList();
  }
}

enum AttendancePeriodFilter { semaine, mois, semestre }
