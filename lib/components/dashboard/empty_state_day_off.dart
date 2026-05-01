import 'package:flutter/material.dart';

class EmptyStateDayOff extends StatelessWidget {
  const EmptyStateDayOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // On force la largeur maximale pour coller aux bords (avec marge de 20)
      width: double.infinity, 
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cercle bleu clair avec l'icône
          Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFE9F0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration, 
              size: 50,
              color: Color(0xFF052A36), // Bleu nuit/pétrole
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Aucun cours aujourd'hui",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF052A36), //
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Profitez-en pour réviser !",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF667A81), // Gris-bleu[cite: 1]
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}