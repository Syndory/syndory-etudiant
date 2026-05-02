import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Map<String, dynamic> user;

  const HeaderSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            // 1. L'Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.orange[100],
              child: const Icon(Icons.person, color: Color(0xFFF06424)),
            ),
            
            const SizedBox(width: 15),
            
            // 2. Les Textes (Nom et Message)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Syndory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF06424), // Orange Syndory
                  ),
                ),
                Text(
                  'Bonjour, ${user['nom'].split(' ')[0]}', // On prend juste le prénom
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // 3. L'icône de Notification
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.grey, size: 28),
                  onPressed: () {
                    // Action future
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}