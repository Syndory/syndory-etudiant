import 'package:flutter/material.dart';

/// Carte représentant un devoir.
/// Réutilisable partout dans l'app.
class DevoirCard extends StatelessWidget {
  final String matiere;
  final String titre;
  final String date;
  final double progression; // entre 0.0 et 1.0
  final String niveau;
  final Color couleur;

  const DevoirCard({
    required this.matiere,
    required this.titre,
    required this.date,
    required this.progression,
    required this.niveau,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête : matière + badge niveau 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                matiere,
                style: TextStyle(
                  color: couleur,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: couleur.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  niveau,
                  style: TextStyle(
                    color: couleur,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Titre du devoir 
          Text(
            titre,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          //  Date avec icône calendrier 
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 5),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Barre de progression + pourcentage 
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progression,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progression * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}