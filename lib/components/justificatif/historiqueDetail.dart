import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/justificatif/statusBadge.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';


class HistoriqueDetailCard extends StatelessWidget {
  final JustificatifHistoriqueDetaille entry;

  const HistoriqueDetailCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ligne 1 : badge statut ─────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: StatusBadge(status: entry.status),
            ),
            const SizedBox(height: 6),

            // ── Nom du cours ───────────────────────────────────────────
            Text(
              entry.courseName,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),

            // ── Date & période ─────────────────────────────────────────
            Text(
              '${entry.date} • ${entry.period}',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.gray3,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),

            // ── Fichier joint ──────────────────────────────────────────
            Row(
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  size: 14,
                  color: AppColors.gray3,
                ),
                const SizedBox(width: 4),
                Text(
                  entry.fileName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.gray2,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // ── Motif de rejet ─────────────────────────────────────────
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
    );
  }
}