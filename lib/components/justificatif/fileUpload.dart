import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

// ─── Modèle fichier sélectionné ───────────────────────────────────────────────
class PickedFile {
  final String name;
  final String size; // formaté ex: "1.2 MB"
  final String path;
  final File file;

  const PickedFile({
    required this.name,
    required this.size,
    required this.path,
    required this.file,
  });
}

// ─── Helper format taille ─────────────────────────────────────────────────────
String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

// ─── Zone vide : invite à choisir un fichier ─────────────────────────────────
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
          border: Border.all(color: AppColors.gray4, width: 1.5),
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

// ─── Fichier sélectionné avec barre de progression réelle ────────────────────
class FileUploadZoneUploading extends StatelessWidget {
  final PickedFile pickedFile;
  final double progress; // 0.0 – 1.0 fourni par l'appelant
  final VoidCallback? onCancel;

  const FileUploadZoneUploading({
    super.key,
    required this.pickedFile,
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
              // Icône selon type de fichier
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _iconForFile(pickedFile.name),
                  color: AppColors.secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickedFile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pickedFile.size,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.gray3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
          GestureDetector(
            onTap: onCancel,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, size: 14, color: AppColors.gray3),
                SizedBox(width: 4),
                Text(
                  "Annuler l'envoi",
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

  IconData _iconForFile(String name) {
    final ext = name.split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (['jpg', 'jpeg', 'png'].contains(ext)) return Icons.image_rounded;
    return Icons.insert_drive_file_rounded;
  }
}

// ─── Service de sélection de fichier ─────────────────────────────────────────
/// Appelle le picker natif et retourne un [PickedFile] ou null si annulé.
Future<PickedFile?> pickJustificatifFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    allowMultiple: false,
  );

  if (result == null || result.files.isEmpty) return null;

  final pf = result.files.first;
  if (pf.path == null) return null;

  final file = File(pf.path!);
  final sizeBytes = await file.length();

  return PickedFile(
    name: pf.name,
    size: _formatSize(sizeBytes),
    path: pf.path!,
    file: file,
  );
}

// ─── Service d'upload ─────────────────────────────────────────────────────────
/// À brancher sur ton backend.
/// [onProgress] est appelé avec une valeur entre 0.0 et 1.0.
///
/// Exemple avec dio :
/// ```dart
/// final dio = Dio();
/// final formData = FormData.fromMap({
///   'file': await MultipartFile.fromFile(file.path, filename: fileName),
///   'absenceId': absenceId,
///   'commentaire': commentaire,
/// });
/// await dio.post(
///   '/api/justificatifs',
///   data: formData,
///   onSendProgress: (sent, total) => onProgress(sent / total),
/// );
/// ```
typedef UploadProgressCallback = void Function(double progress);

Future<void> uploadJustificatif({
  required PickedFile pickedFile,
  required String absenceId,
  String? commentaire,
  required UploadProgressCallback onProgress,
}) async {
  // ── SIMULATION ──────────────────────────────────────────────────────────────
  // Remplace ce bloc par ton appel HTTP réel (dio, http, etc.)
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(const Duration(milliseconds: 200));
    onProgress(i / 10);
  }
  // ── FIN SIMULATION ───────────────────────────────────────────────────────────

  // ── EXEMPLE RÉEL avec dio (décommente quand tu as le backend) ───────────────
  // final dio = Dio();
  // final formData = FormData.fromMap({
  //   'file': await MultipartFile.fromFile(
  //     pickedFile.path,
  //     filename: pickedFile.name,
  //   ),
  //   'absenceId': absenceId,
  //   if (commentaire != null) 'commentaire': commentaire,
  // });
  // await dio.post(
  //   'https://ton-api.com/api/justificatifs',
  //   data: formData,
  //   onSendProgress: (sent, total) => onProgress(sent / total),
  // );
}