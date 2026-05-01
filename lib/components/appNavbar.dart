import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syndory_etudiant/screens/profil/profile_page.dart';
import 'package:syndory_etudiant/profile/controllers/profile_controller.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final String? avatarUrl;

  const AppNavbar({
    super.key,
    required this.title,
    this.onBack,
    this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
        onPressed: onBack ?? () => Navigator.maybePop(context),
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
        GestureDetector(
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
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange.shade200,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
