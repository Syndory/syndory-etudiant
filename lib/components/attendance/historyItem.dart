import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';

import 'package:syndory_etudiant/models/periodModel.dart';


/// Ligne d'historique pour une séance passée.
class RecentHistoryItem extends StatelessWidget {
  final HistoryEntry entry;

  const RecentHistoryItem({super.key, required this.entry});

  Color get _statusColor {
    switch (entry.status) {
      case HistoryStatus.present:
        return AppColors.success;
      case HistoryStatus.absent:
        return AppColors.danger;
      case HistoryStatus.ajour:
        return AppColors.orange;
      case HistoryStatus.retard:
        return AppColors.warning;
    }
  }

  Color get _iconBgColor {
    switch (entry.status) {
      case HistoryStatus.present:
        return AppColors.success.withOpacity(0.15);
      case HistoryStatus.absent:
        return AppColors.danger.withOpacity(0.15);
      case HistoryStatus.ajour:
        return AppColors.orange.withOpacity(0.15);
      case HistoryStatus.retard:
        return AppColors.warning.withOpacity(0.15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Course icon avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                entry.iconPath,
                style: TextStyle(
                  color: _statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Course name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.courseName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  entry.date,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              entry.status.label,
              style: TextStyle(
                color: _statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}