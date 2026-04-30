import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/matiere.dart';

class SeanceItem extends StatelessWidget {
  final Seance seance;

  const SeanceItem({
    super.key,
    required this.seance,
  });

  String _getMois(int month) {
    const moisList = ['JAN', 'FÉV', 'MAR', 'AVR', 'MAI', 'JUI', 'JUI', 'AOÛ', 'SEP', 'OCT', 'NOV', 'DÉC'];
    return moisList[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final mois = _getMois(seance.date.month);
    final jour = seance.date.day.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.bgLight),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Colonne date
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(
                  mois,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  jour,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Colonne centrale
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seance.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // medium
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${seance.salle} - ${seance.heureDebut} - ${seance.heureFin}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: seance.statut == 'PRESENT'
                  ? const Color(0xFFDCFCE7)
                  : seance.statut == 'ABSENT'
                      ? const Color(0xFFFEE2E2)
                      : AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              seance.statut,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: seance.statut == 'PRESENT'
                    ? const Color(0xFF166534)
                    : seance.statut == 'ABSENT'
                        ? const Color(0xFF991B1B)
                        : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
