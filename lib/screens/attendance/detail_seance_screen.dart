import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/reusable/session_card.dart';
import 'package:syndory_etudiant/components/reusable/info_row.dart';
import 'package:syndory_etudiant/components/reusable/custom_buttons.dart';
import 'package:syndory_etudiant/models/session_status.dart';
import 'package:syndory_etudiant/screens/justificatif/uploadScreen.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

class DetailSeanceScreen extends StatelessWidget {
  final SessionStatus status;
  final String courseName;
  final String professorName;

  // ── Données réelles passées depuis AttendanceScreen ──────────────────────
  final String? presenceId;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? salleName;
  final String? justificatifStatus; // 'en_attente' | 'validé' | 'rejeté'

  const DetailSeanceScreen({
    super.key,
    required this.status,
    required this.courseName,
    required this.professorName,
    // Optionnels pour rétrocompatibilité
    this.presenceId,
    this.date,
    this.startTime,
    this.endTime,
    this.salleName,
    this.justificatifStatus,
  });

  // ── Formatage de la date ──────────────────────────────────────────────────
  String get _formattedDate {
    if (date == null) return 'Date inconnue';
    const jours = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    const mois = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${jours[date!.weekday - 1]} ${date!.day} ${mois[date!.month - 1]}';
  }

  String get _timeRange {
    if (startTime == null || endTime == null) return '--:-- — --:--';
    return '$startTime — $endTime';
  }

  String get _salleDisplay => salleName ?? 'Salle inconnue';

  // ── Libellé du statut justificatif ───────────────────────────────────────
  String get _justifLabel {
    switch (justificatifStatus) {
      case 'validé':
        return 'Validé par l\'Administration';
      case 'rejeté':
        return 'Rejeté';
      case 'en_attente':
        return 'En cours de traitement';
      default:
        return 'Justificatif soumis';
    }
  }

  String get _justifSubtitle {
    switch (justificatifStatus) {
      case 'validé':
        return 'Votre justificatif a été accepté.';
      case 'rejeté':
        return 'Votre justificatif a été refusé. Contactez votre professeur.';
      case 'en_attente':
        return 'Votre justificatif est en attente de traitement.';
      default:
        return '';
    }
  }

  Color _justifColor(BuildContext context) {
    switch (justificatifStatus) {
      case 'validé':
        return AppColors.success;
      case 'rejeté':
        return AppColors.danger;
      default:
        return AppColors.orange;
    }
  }

  IconData _justifIcon() {
    switch (justificatifStatus) {
      case 'validé':
        return Icons.check_circle;
      case 'rejeté':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  void _showJustifyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: JustificatifsUploadScreen(
            absence: AbsenceEnAttente(
              id: presenceId ?? '0',
              courseName: courseName,
              date: _formattedDate,
              timeRange: _timeRange,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: const Text(
          'Détails de la séance',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Carte statut ────────────────────────────────────────────
            SessionCard(
              status: status,
              courseName: courseName,
              professorName: professorName,
            ),
            const SizedBox(height: 16),

            // ── Date & heure ────────────────────────────────────────────
            InfoRow(
              icon: Icons.calendar_month_outlined,
              label: 'DATE & HEURE',
              line1: _formattedDate,
              line2: _timeRange,
            ),
            const SizedBox(height: 12),

            // ── Salle ───────────────────────────────────────────────────
            InfoRow(
              icon: Icons.location_on_outlined,
              label: 'EMPLACEMENT',
              line1: _salleDisplay,
            ),
            const SizedBox(height: 12),

            // ── Professeur ──────────────────────────────────────────────
            InfoRow(
              customLeading: const CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=51',
                ),
              ),
              label: 'PROFESSEUR',
              line1: professorName,
            ),
            const SizedBox(height: 20),

            // ── Bouton justifier (si absent sans justificatif) ───────────
            if (status == SessionStatus.absence) ...[
              AppPrimaryButton(
                text: 'Justifier une absence',
                icon: Icons.upload_file,
                onPressed: () => _showJustifyModal(context),
              ),
              const SizedBox(height: 20),
            ],

            // ── Statut du justificatif (si justified) ────────────────────
            if (status == SessionStatus.justified) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STATUT DE TRAITEMENT',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _justifIcon(),
                          color: _justifColor(context),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _justifLabel,
                            style: TextStyle(
                              color: _justifColor(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_justifSubtitle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _justifSubtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
