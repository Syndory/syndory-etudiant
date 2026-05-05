import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/annonces/annonces_screen.dart';

class AnnouncementsSection extends StatelessWidget {
  // ✅ On ajoute la fonction de navigation en paramètre
  final ValueChanged<int> onNavTap;

  const AnnouncementsSection({
    super.key, 
    required this.onNavTap, // Requis pour changer d'onglet
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AnnonceScreen(),
                  ));
                },
                child: const Text('Voir tout', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _buildAnnouncementItem(
            title: "Ouverture des inscriptions au forum carrière",
            time: "Aujourd'hui, 08h30",
            isNew: true,
          ),
          const SizedBox(height: 15),
          _buildAnnouncementItem(
            title: "Mise à jour des horaires de la bibliothèque",
            time: "Hier, 14h15",
            isNew: false,
          ),
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