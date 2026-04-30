import 'package:flutter/material.dart';
import 'status_badge.dart';
import '../../models/session.dart';

class AttendanceHeader extends StatelessWidget {
  final Session session;

  const AttendanceHeader({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF143030), // Le bleu très sombre de la maquette
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag du type de cours
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              session.type.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          // Badge de statut
          StatusBadge(status: session.status),
          const SizedBox(height: 12),
          // Titre du cours
          Text(
            session.title,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Professeur
          Text(
            "Prof. ${session.professor}",
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
        ],
      ),
    );
  }
}