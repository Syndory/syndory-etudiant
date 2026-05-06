import 'package:flutter/material.dart';

class RecentDocumentsSection extends StatelessWidget {
  final List<Map<String, dynamic>> documents;

  const RecentDocumentsSection({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          if (documents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Aucun document disponible",
                style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
              ),
            )
          else
            ...documents.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDocumentTile(
                fileName: doc['nom'] ?? 'document',
                fileInfo: doc['info'] ?? '',
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildDocumentTile({required String fileName, required String fileInfo}) {
    // Détermination de l'icône selon l'extension
    final ext = fileName.split('.').last.toLowerCase();
    IconData icon;
    Color iconColor;
    Color bgColor;
    if (ext == 'pdf') {
      icon = Icons.picture_as_pdf;
      iconColor = Colors.red;
      bgColor = Colors.red.shade50;
    } else if (['doc', 'docx'].contains(ext)) {
      icon = Icons.description;
      iconColor = Colors.blue;
      bgColor = Colors.blue.shade50;
    } else if (['ppt', 'pptx'].contains(ext)) {
      icon = Icons.slideshow;
      iconColor = Colors.orange;
      bgColor = Colors.orange.shade50;
    } else {
      icon = Icons.insert_drive_file;
      iconColor = Colors.blueGrey;
      bgColor = Colors.blueGrey.shade50;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
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
          Icon(Icons.file_download_outlined, color: Colors.grey[400]),
        ],
      ),
    );
  }
}