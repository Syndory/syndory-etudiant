import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/document_pedago.dart';

class DocumentCard extends StatelessWidget {
  final DocumentPedago document;

  const DocumentCard({
    super.key,
    required this.document,
  });

  Color _getIconColor() {
    switch (document.type.toUpperCase()) {
      case 'PDF':
        return const Color(0xFFFF5722); // Rouge-orangé
      case 'DOCX':
        return const Color(0xFF2196F3); // Bleu
      case 'PPTX':
        return const Color(0xFFF44336); // Rouge
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays < 1) {
      return 'Aujourd\'hui';
    } else if (difference.inDays < 7) {
      return 'il y a ${difference.inDays} jours';
    } else {
      return '${date.day} ${_getMonth(date.month)}';
    }
  }

  String _getMonth(int month) {
    const months = ['janv', 'févr', 'mars', 'avr', 'mai', 'juin', 'juil', 'août', 'sept', 'oct', 'nov', 'déc'];
    return months[month - 1];
  }

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
          // Icône avec badge overlay
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.description, color: Colors.white, size: 20),
                ),
              ),
              if (document.isNew)
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NOUVEAU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.titre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // medium
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  document.matiere,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${document.professeur} · ${_formatDate(document.dateUpload)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bouton Download
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
