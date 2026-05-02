import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String filiere;
  final String niveau;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.filiere,
    required this.niveau,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 42,
                backgroundImage: AssetImage("avatar.jpg"),
                backgroundColor: Color(0xFFE0E0E0),
              ),
            ),

            // Bouton édition
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "$filiere • $niveau",
          style: TextStyle(fontSize: 13, color: Color(0xFF5B4137)),
        ),
      ],
    );
  }
}
