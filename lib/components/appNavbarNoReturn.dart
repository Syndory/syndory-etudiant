import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/notification/notifications_screen.dart';
import 'package:syndory_etudiant/screens/profil/profile_page.dart';

class AppNavBarNoReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;

  const AppNavBarNoReturn({
    super.key,
    required this.title,
    this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5, // Une légère ombre pour détacher du contenu
      automaticallyImplyLeading: false,
      
      // --- PARTIE GAUCHE : AVATAR (PROFIL) ---
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Navigation directe vers le profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFFFE0D3), // Orange très clair
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, color: Color(0xFFF06424), size: 20)
                  : null,
            ),
          ),
        ),
      ),

      // --- TITRE ---
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF052A36), // Ton bleu nuit
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,

      // --- PARTIE DROITE : NOTIFICATIONS ---
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF052A36),
          ),
          onPressed: () {
            // Navigation directe vers les notifications
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}