import 'package:flutter/material.dart';

class AppNavBarNoReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed; 

  const AppNavBarNoReturn({
    super.key,
    required this.title,
    this.avatarUrl,
    this.onNotificationPressed,
    this.onProfilePressed, 
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: GestureDetector(
            onTap: onProfilePressed,
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
      ),

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
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.black87,
          ),
          onPressed: onNotificationPressed,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}