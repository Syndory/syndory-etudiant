import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

// ─── Zone vide : tirets + invite à cliquer ────────────────────────────────────
class FileUploadZoneEmpty extends StatelessWidget {
  final VoidCallback? onTap;

  const FileUploadZoneEmpty({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray4,
            width: 1.5,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.upload_file_rounded,
                color: AppColors.gray3,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cliquer pour choisir un fichier',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Formats acceptés : PDF, JPG, PNG',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.gray3,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fichier sélectionné avec progression ─────────────────────────────────────
class FileUploadZoneUploading extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final double progress; // 0.0 – 1.0
  final VoidCallback? onCancel;

  const FileUploadZoneUploading({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icône PDF orange
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Nom + taille
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileSize,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.gray3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Pourcentage
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.gray4.withOpacity(0.4),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ),
          const SizedBox(height: 10),
          // Lien annuler
          GestureDetector(
            onTap: onCancel,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, size: 14, color: AppColors.gray3),
                SizedBox(width: 4),
                Text(
                  'Annuler l\'envoi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.gray3,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}