import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/annonces/annonces_screen.dart';

class AnnouncementsSection extends StatelessWidget {
  const AnnouncementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. En-tête avec Icône et Titre
          Row(
            children: [
              const Icon(Icons.campaign_outlined, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Annonces',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // Le bouton pour aller vers ETU-11
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

          // 2. Les 2 dernières annonces
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
        // Le point indicateur
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: isNew ? Colors.orange : Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 15),
        // Le texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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