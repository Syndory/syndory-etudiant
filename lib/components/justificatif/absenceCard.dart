import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

class AbsenceCard extends StatelessWidget {
  final AbsenceEnAttente absence;

  const AbsenceCard({super.key, required this.absence});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Bordure gauche orange ──────────────────────────────────
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Icône calendrier ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE), // bleu clair comme dans l'image
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF5B8DEF), // bleu doux
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Infos cours ────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      absence.courseName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${absence.date}, ${absence.timeRange}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.gray3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}