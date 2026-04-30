import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // On ne veut pas de marge en bas ici
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            // 1. L'Avatar
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Image temporaire
            ),
            
            const SizedBox(width: 15), // Espace entre l'image et le texte
            
            // 2. Les Textes (Nom et Message)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Syndory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // Couleur adaptée à votre image
                  ),
                ),
                Text(
                  'Bonjour, Kwame',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const Spacer(), // Pousse la cloche vers la droite
            
            // 3. L'icône de Notification
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {
                // Action future
              },
            ),
          ],
        ),
      ),
    );
  }
}