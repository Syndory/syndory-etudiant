import 'package:flutter/material.dart';

class RecentDocumentsSection extends StatelessWidget {
  const RecentDocumentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Titre de section
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Colors.blueGrey, size: 22),
              SizedBox(width: 8),
              Text(
                'Documents récents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 2. Liste des 3 derniers documents (ici un exemple)
          _buildDocumentTile(
            fileName: "MacroEcon_Syllabus_2024.pdf",
            fileInfo: "2.4 Mo • Ajouté il y a 2 jours",
          ),
          // Vous pourriez en ajouter deux autres ici pour respecter le "3 derniers"
        ],
      ),
    );
  }

  Widget _buildDocumentTile({required String fileName, required String fileInfo}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Icône PDF stylisée
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 15),
          // Infos fichier
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  fileInfo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          // Bouton téléchargement
          Icon(Icons.file_download_outlined, color: Colors.grey[400]),
        ],
      ),
    );
  }
}