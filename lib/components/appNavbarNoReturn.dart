import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/notification/notifications_screen.dart';

class AppNavBarNoReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;

  //Callback optionnel : appelé quand on tape sur l'avatar
  // Si null, le tap ne fait rien (rétrocompatible avec les autres pages)
  final VoidCallback? onProfileTap;

  const AppNavBarNoReturn({
    super.key,
    required this.title,
    this.avatarUrl,
    this.onProfileTap, //optionnel → pas besoin de tout modifier
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,

      // --- PARTIE GAUCHE : AVATAR (PROFIL) ---
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: GestureDetector(
            // Utilise le callback si fourni, sinon ne fait rien
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFFFE0D3),
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
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
          color: Color(0xFF052A36),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
