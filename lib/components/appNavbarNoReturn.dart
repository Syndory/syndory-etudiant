import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syndory_etudiant/screens/notification/notifications_screen.dart';
import 'package:syndory_etudiant/screens/profil/profile_page.dart';
import 'package:syndory_etudiant/profile/controllers/profile_controller.dart';

class AppNavBarNoReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;

  const AppNavBarNoReturn({super.key, required this.title, this.avatarUrl});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,

      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<ProfileController>(),
              child: ProfilePage(navIndex: 7, onNavTap: (index) {}),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
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

      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF052A36),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,

      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF052A36),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
