enum JustificatifStatus { enAttente, valide, rejete }

extension JustificatifStatusInfo on JustificatifStatus {
  String get label {
    switch (this) {
      case JustificatifStatus.enAttente:
        return 'En attente';
      case JustificatifStatus.valide:
        return 'Validé';
      case JustificatifStatus.rejete:
        return 'Rejeté';
    }
  }

  String get apiValue {
    switch (this) {
      case JustificatifStatus.enAttente:
        return 'en_attente';
      case JustificatifStatus.valide:
        return 'validé';
      case JustificatifStatus.rejete:
        return 'rejeté';
    }
  }
}

JustificatifStatus justificatifStatusFromApi(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'valide':
    case 'validé':
    case 'approved':
    case 'validated':
      return JustificatifStatus.valide;
    case 'rejete':
    case 'rejeté':
    case 'rejected':
      return JustificatifStatus.rejete;
    case 'pending':
    case 'en_attente':
    default:
      return JustificatifStatus.enAttente;
  }
}

class AbsenceEnAttente {
  final String id;
  final String courseName;
  final String date;
  final String timeRange;

  const AbsenceEnAttente({
    required this.id,
    required this.courseName,
    required this.date,
    required this.timeRange,
  });

  factory AbsenceEnAttente.fromJson(Map<String, dynamic> json) {
    return AbsenceEnAttente(
      id: json['id'] as String,
      courseName: json['course_name'] as String,
      date: json['date'] as String,
      timeRange: json['time_range'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_name': courseName,
      'date': date,
      'time_range': timeRange,
    };
  }
}

class JustificatifHistorique {
  final String id;
  final String title;
  final String submittedDate;
  final JustificatifStatus status;

  const JustificatifHistorique({
    required this.id,
    required this.title,
    required this.submittedDate,
    required this.status,
  });

  factory JustificatifHistorique.fromJson(Map<String, dynamic> json) {
    return JustificatifHistorique(
      id: json['id'] as String,
      title: json['title'] as String,
      submittedDate: json['submitted_date'] as String,
      status: justificatifStatusFromApi(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'submitted_date': submittedDate,
      'status': status.apiValue,
    };
  }
}

class JustificatifHistoriqueDetaille {
  final String id;
  final String courseName;
  final String date;
  final String period;
  final String fileName;
  final JustificatifStatus status;
  final String? rejectionReason;

  const JustificatifHistoriqueDetaille({
    required this.id,
    required this.courseName,
    required this.date,
    required this.period,
    required this.fileName,
    required this.status,
    this.rejectionReason,
  });

  factory JustificatifHistoriqueDetaille.fromJson(Map<String, dynamic> json) {
    return JustificatifHistoriqueDetaille(
      id: json['id'] as String,
      courseName: json['course_name'] as String,
      date: json['date'] as String,
      period: json['period'] as String,
      fileName: json['file_name'] as String,
      status: justificatifStatusFromApi(json['status'] as String?),
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_name': courseName,
      'date': date,
      'period': period,
      'file_name': fileName,
      'status': status.apiValue,
      'rejection_reason': rejectionReason,
    };
  }
}

class JustificatifsDashboardData {
  final List<AbsenceEnAttente> pendingAbsences;
  final List<JustificatifHistorique> historiqueCompact;
  final List<JustificatifHistoriqueDetaille> historiqueDetaille;

  const JustificatifsDashboardData({
    required this.pendingAbsences,
    required this.historiqueCompact,
    required this.historiqueDetaille,
  });

  factory JustificatifsDashboardData.fromJson(Map<String, dynamic> json) {
    final pending = (json['pending_absences'] as List<dynamic>? ?? const [])
        .map(
          (entry) => AbsenceEnAttente.fromJson(entry as Map<String, dynamic>),
        )
        .toList();
    final compact = (json['historique_compact'] as List<dynamic>? ?? const [])
        .map(
          (entry) =>
              JustificatifHistorique.fromJson(entry as Map<String, dynamic>),
        )
        .toList();
    final detail = (json['historique_detaille'] as List<dynamic>? ?? const [])
        .map(
          (entry) => JustificatifHistoriqueDetaille.fromJson(
            entry as Map<String, dynamic>,
          ),
        )
        .toList();

    return JustificatifsDashboardData(
      pendingAbsences: pending,
      historiqueCompact: compact,
      historiqueDetaille: detail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending_absences': pendingAbsences
          .map((entry) => entry.toJson())
          .toList(),
      'historique_compact': historiqueCompact
          .map((entry) => entry.toJson())
          .toList(),
      'historique_detaille': historiqueDetaille
          .map((entry) => entry.toJson())
          .toList(),
    };
  }
}

const AbsenceEnAttente mockAbsenceEnAttente = AbsenceEnAttente(
  id: 'abs-001',
  courseName: 'Mathématiques',
  date: '22 Octobre 2024',
  timeRange: '14:30 — 16:30',
);

const List<AbsenceEnAttente> mockPendingAbsences = [mockAbsenceEnAttente];

final List<JustificatifHistorique> mockHistoriqueCompact = [
  const JustificatifHistorique(
    id: 'h1',
    title: 'Certificat médical',
    submittedDate: 'Soumis le 15 Oct. 2024',
    status: JustificatifStatus.enAttente,
  ),
  const JustificatifHistorique(
    id: 'h2',
    title: 'Attestation transport',
    submittedDate: 'Soumis le 08 Oct. 2024',
    status: JustificatifStatus.valide,
  ),
  const JustificatifHistorique(
    id: 'h3',
    title: 'Motif familial',
    submittedDate: 'Soumis le 01 Oct. 2024',
    status: JustificatifStatus.rejete,
  ),
];

final List<JustificatifHistoriqueDetaille> mockHistoriqueDetaille = [
  const JustificatifHistoriqueDetaille(
    id: 'd1',
    courseName: 'Examen Partiel Mathématiques',
    date: '12 Janvier 2024',
    period: 'Matin',
    fileName: 'Certificat_medical_s2.pdf',
    status: JustificatifStatus.valide,
  ),
  const JustificatifHistoriqueDetaille(
    id: 'd2',
    courseName: 'Cours Magistral – Économie',
    date: '08 Janvier 2024',
    period: 'Journée',
    fileName: 'justificatif_eco.pdf',
    status: JustificatifStatus.rejete,
    rejectionReason: 'Document non recevable (absence de signature).',
  ),
];

final JustificatifsDashboardData mockJustificatifsDashboardData =
    JustificatifsDashboardData(
      pendingAbsences: mockPendingAbsences,
      historiqueCompact: mockHistoriqueCompact,
      historiqueDetaille: mockHistoriqueDetaille,
    );
