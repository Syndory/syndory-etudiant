// lib/components/announcements/attachment_item.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';

class AttachmentItem extends StatelessWidget {
  final AnnouncementAttachment attachment;

  const AttachmentItem({super.key, required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray4.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icône fichier
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: attachment.isPdf
                  ? const Color(0xFFFFEEEE)
                  : const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              attachment.isPdf
                  ? Icons.picture_as_pdf_rounded
                  : Icons.image_rounded,
              color: attachment.isPdf
                  ? const Color(0xFFE53935)
                  : const Color(0xFF1565C0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Nom + taille
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.filename,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  attachment.size,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.gray3,
                  ),
                ),
              ],
            ),
          ),
          // Bouton télécharger
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.bgPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.download_rounded,
              color: AppColors.gray3,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
