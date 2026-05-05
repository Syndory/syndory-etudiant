import 'package:flutter/material.dart';
import '../../models/matiere_model.dart';

/// Carte représentant une matière sous forme de devoir.
class DevoirCard extends StatelessWidget {
  final Matiere matiere;

  const DevoirCard({super.key, required this.matiere});

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
          // ── En-tête : nom matière + badge niveau
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                matiere.nom,
                style: TextStyle(
                  color: matiere.couleur,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: matiere.couleur.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  matiere.niveau,
                  style: TextStyle(
                    color: matiere.couleur,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Code de la matière (ex: MATH101)
          Text(
            matiere.code ?? matiere.nom,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          // ── Date (prochaine séance ou placeholder)
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 5),
              Text(
                matiere.prochaineDate ?? '—',
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
                    value: matiere.progression,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(matiere.couleur),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(matiere.progression * 100).toInt()}%',
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