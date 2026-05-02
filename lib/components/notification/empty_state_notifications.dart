import 'package:flutter/material.dart';

class EmptyStateNotifications extends StatelessWidget {
  const EmptyStateNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        // L'icône Mégaphone dans son cercle
        Center(
          child: Image(
            image: AssetImage('Background+Border.png'),
            width: 300,
            height: 300,
          ),
        ),
        const SizedBox(
          height: 40,
          child: Row(
            children: [
            //les deux rectangles
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Aucune notification pour le moment",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF052A36),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Revenez plus tard pour les mises à jour administratives et les communications importantes.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.blueGrey, height: 1.5),
          ),
        ),
        const SizedBox(height: 40),
        // Bouton Actualiser
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE9F0FF)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            "Actualiser le flux",
            style: TextStyle(color: Color(0xFF052A36), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}