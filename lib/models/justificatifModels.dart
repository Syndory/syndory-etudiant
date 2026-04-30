// ─── Statuts ─────────────────────────────────────────────────────────────────
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
}

// ─── Absence en attente de justificatif ──────────────────────────────────────
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
}

// ─── Historique compact (écrans 2 & 3) ───────────────────────────────────────
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
}

// ─── Historique détaillé (écran 1) ───────────────────────────────────────────
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
}

// ─── MOCKS ────────────────────────────────────────────────────────────────────

const AbsenceEnAttente mockAbsenceEnAttente = AbsenceEnAttente(
  id: 'abs-001',
  courseName: 'Mathématiques',
  date: '22 Octobre 2024',
  timeRange: '14:30 — 16:30',
);

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