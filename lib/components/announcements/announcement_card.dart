// lib/components/announcements/announcement_card.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
  });

  // Icône selon la catégorie
  IconData get _categoryIcon {
    switch (announcement.category) {
      case AnnouncementCategory.administration:
        return Icons.account_balance_rounded;
      case AnnouncementCategory.academique:
        return Icons.school_rounded;
      case AnnouncementCategory.bureauEtudiants:
        return Icons.groups_rounded;
      case AnnouncementCategory.serviceIT:
        return Icons.settings_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ligne source + badge NON LU ──
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _categoryIcon,
                    color: AppColors.gray3,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.source,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.gray2,
                        ),
                      ),
                      Text(
                        announcement.date,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.gray3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge "NON LU"
                if (announcement.isUnread)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NON LU',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Titre ──
            Text(
              announcement.title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primary,
                height: 1.35,
              ),
            ),

            const SizedBox(height: 6),

            // ── Aperçu ──
            Text(
              announcement.preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.gray3,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // ── Pied de carte : meta + lire la suite ──
            Row(
              children: [
                // Meta info
                Expanded(child: _buildMeta()),
                // Lire la suite →
                GestureDetector(
                  onTap: onTap,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lire la suite',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.secondary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta() {
    // Localisation
    if (announcement.location != null) {
      return Row(
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppColors.gray3, size: 13),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              announcement.location!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.gray3,
              ),
            ),
          ),
        ],
      );
    }
    // Fichiers joints
    if (announcement.attachmentCount != null) {
      return Row(
        children: [
          const Icon(Icons.attach_file_rounded,
              color: AppColors.gray3, size: 13),
          const SizedBox(width: 4),
          Text(
            '${announcement.attachmentCount} fichier${announcement.attachmentCount! > 1 ? 's' : ''} joint${announcement.attachmentCount! > 1 ? 's' : ''}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.gray3,
            ),
          ),
        ],
      );
    }
    // Urgent
    if (announcement.isUrgent) {
      return Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.secondary, size: 13),
          const SizedBox(width: 4),
          const Text(
            'Urgent',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: AppColors.secondary,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
