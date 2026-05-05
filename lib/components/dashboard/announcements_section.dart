import 'package:flutter/material.dart';

class AnnouncementsSection extends StatelessWidget {
  // ✅ On ajoute la fonction de navigation en paramètre
  final ValueChanged<int> onNavTap;
  final List<Map<String, dynamic>> annonces;

  const AnnouncementsSection({
    super.key, 
    required this.onNavTap, // Requis pour changer d'onglet
    required this.annonces,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign_outlined, color: Color(0xFFF06424), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Annonces',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF052A36),
                ),
              ),
              const Spacer(),
              
              TextButton(
                onPressed: () {
                  onNavTap(7);
                },
                child: const Text(
                  'Voir tout',
                  style: TextStyle(color: Color(0xFFF06424), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (annonces.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Aucune annonce pour le moment",
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
            )
          else
            ...annonces.map((annonce) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildAnnouncementItem(
                  title: annonce['titre'] ?? 'Annonce',
                  time: annonce['date'] ?? '',
                  isNew: annonce['est_nouveau'] ?? false,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem({required String title, required String time, required bool isNew}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: isNew ? const Color(0xFFF06424) : Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500, 
                  fontSize: 14,
                  color: Color(0xFF052A36),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}