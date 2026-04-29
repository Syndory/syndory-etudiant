import 'package:flutter/material.dart';

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
      elevation: 0,
      // Empêche Flutter d'afficher la flèche de retour par défaut
      automaticallyImplyLeading: false, 
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
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
      ],
    );
  }
}