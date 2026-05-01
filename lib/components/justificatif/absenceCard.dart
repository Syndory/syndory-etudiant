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
          children: [
            // Bordure gauche orange
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            // Icône calendrier
            Container(
              margin: const EdgeInsets.all(14),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.info,
                size: 20,
              ),
            ),
            // Infos cours
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