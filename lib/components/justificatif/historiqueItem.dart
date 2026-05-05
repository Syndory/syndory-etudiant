import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/justificatif/statusBadge.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';


class HistoriqueItem extends StatelessWidget {
  final JustificatifHistorique entry;

  const HistoriqueItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          // Icône document
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.info,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Titre + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.submittedDate,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.gray3,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(status: entry.status),
        ],
      ),
    );
  }
}