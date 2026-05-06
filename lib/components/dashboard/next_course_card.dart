import 'package:flutter/material.dart';

class NextCourseCard extends StatelessWidget {
  final Map<String, dynamic>? courseData;

  const NextCourseCard({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData == null) return const SizedBox.shrink();

    final matiere      = courseData!['matiere']      ?? 'Cours';
    final prof         = courseData!['prof']          ?? '';
    final salle        = courseData!['salle']         ?? '';
    final horaire      = courseData!['horaire']       ?? '';
    final tempsRestant = courseData!['temps_restant'] ?? 'À venir';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 7, 57, 73),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Badge temps restant
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.orange[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tempsRestant.toString().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // 2. Titre du cours
          Text(
            matiere,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          // 3. Professeur & Salle
          Text(
            [if (prof.isNotEmpty) prof, if (salle.isNotEmpty) salle]
                .join(' • '),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 15),

          Divider(color: Colors.white.withOpacity(0.2)),

          const SizedBox(height: 10),

          // 4. Horaire
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white.withOpacity(0.7), size: 18),
              const SizedBox(width: 8),
              Text(
                horaire,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}