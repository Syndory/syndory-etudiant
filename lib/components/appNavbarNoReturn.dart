import 'package:flutter/material.dart';

/// Barre de navigation sans retour : Avatar à gauche, Titre centré, Notification à droite.
class AppNavBarNoReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final VoidCallback? onNotificationPressed;

  const AppNavBarNoReturn({
    super.key,
    required this.title,
    this.avatarUrl,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      
      // 1. À GAUCHE : La photo de profil
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange.shade200,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
        ),
      ),

      // 2. AU CENTRE : Le titre
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,

      // 3. À DROITE : Le bouton de notification
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded, // Version "outline" plus moderne
            color: Colors.black87,
          ),
          onPressed: onNotificationPressed ?? () {
            print("Ouverture des notifications");
          },
        ),
        const SizedBox(width: 4), // Petit espace pour décoller du bord
      ],
    );
  }
}