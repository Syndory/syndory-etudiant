import 'package:flutter/material.dart';

class NextCourseCard extends StatelessWidget {
  // Simulation : Si cette variable est null, la carte ne s'affiche pas
  final Map<String, dynamic>? courseData;

  const NextCourseCard({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    // CONDITION : Si pas de cours, on ne retourne rien (0 pixel)
    if (courseData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF052A36), // Bleu nuit très sombre
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Le Badge Orange
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.orange[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'DANS 45 MIN',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 15),

          // 2. Titre du cours
          const Text(
            'Macroéconomie avancée',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          // 3. Professeur et Salle
          Text(
            'Prof. N. Addo • Salle 402, Bloc C',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 15),
          
          // Ligne de séparation
          Divider(color: Colors.white.withOpacity(0.2)),
          
          const SizedBox(height: 10),

          // 4. Footer (Heure et Étudiants)
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white.withOpacity(0.7), size: 18),
              const SizedBox(width: 8),
              Text(
                '11:00 AM - 1:00 PM',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(width: 20),
              Icon(Icons.people_outline, color: Colors.white.withOpacity(0.7), size: 18),
              const SizedBox(width: 8),
              Text(
                '42 Étudiants',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}