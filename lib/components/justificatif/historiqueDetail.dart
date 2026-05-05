import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/components/justificatif/statusBadge.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

class HistoriqueDetailCard extends StatelessWidget {
  final JustificatifHistoriqueDetaille entry;

  const HistoriqueDetailCard({super.key, required this.entry});

  // Couleur de la bordure gauche selon le statut
  Color get _borderColor {
    switch (entry.status) {
      case JustificatifStatus.valide:
        return AppColors.success;
      case JustificatifStatus.rejete:
        return AppColors.danger;
      case JustificatifStatus.enAttente:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Bordure gauche colorée ─────────────────────────────────
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // ── Contenu ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Icône + badge ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.bgPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.insert_drive_file_outlined,
                            color: AppColors.gray3,
                            size: 22,
                          ),
                        ),
                        StatusBadge(status: entry.status),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Nom du cours ───────────────────────────────────
                    Text(
                      entry.courseName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ── Date & période ─────────────────────────────────
                    Text(
                      '${entry.date} • ${entry.period}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.gray3,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Fichier joint ──────────────────────────────────
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_file_rounded,
                          size: 15,
                          color: AppColors.gray3,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            entry.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.gray3,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Motif de rejet ─────────────────────────────────
                    if (entry.rejectionReason != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.danger.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.error_outline_rounded,
                                size: 14,
                                color: AppColors.danger,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Motif : ${entry.rejectionReason}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.danger,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}