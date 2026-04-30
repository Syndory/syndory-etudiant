import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/matiere.dart';

class ChapitreItem extends StatelessWidget {
  final Chapitre chapitre;

  const ChapitreItem({
    super.key,
    required this.chapitre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.bgLight),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapitre.titre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // medium
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  chapitre.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: chapitre.traite ? const Color(0xFFE8F5E9) : AppColors.bgLight,
              borderRadius: BorderRadius.circular(12), // pill-shape
            ),
            child: Text(
              chapitre.traite ? 'TRAITÉ' : 'NON TRAITÉ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: chapitre.traite ? const Color(0xFF2E7D32) : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
