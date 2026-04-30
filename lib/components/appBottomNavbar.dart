import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';


class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const _icons = [
  Icons.home_rounded,            // Accueil
  Icons.calendar_month_rounded,  // Calendrier
  Icons.person_off_rounded,      // Absences (Icone explicite pour l'absence)
  Icons.fact_check_rounded,      // Assiduité (Checklist de présence)
  Icons.menu_book_rounded,       // Mes Matières / Cours
  Icons.campaign_rounded,        // Annonces / Flash info
  Icons.person_rounded,          // Profil
];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(
          top: BorderSide(
            color: AppColors.textMuted.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _icons.length,
          (i) => GestureDetector(
            onTap: () => onTap?.call(i),
            behavior: HitTestBehavior.opaque,
            child: _NavItem(icon: _icons[i], isActive: currentIndex == i),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavItem({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.orange : AppColors.textMuted,
            size: 24,
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}