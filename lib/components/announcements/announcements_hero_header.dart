// lib/components/announcements/announcements_hero_header.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';

class AnnouncementsHeroHeader extends StatelessWidget {
  const AnnouncementsHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage('assets/Background+Border.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Gradient de lisibilité sur la partie texte
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.95),
                    AppColors.primary.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Texte à gauche
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Restez informé',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Toutes les mises à jour administratives et académiques en un seul endroit.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.white.withOpacity(0.75),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Illustration bâtiment en haut à droite
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: Image.asset(
                'assets/decoration.png',
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.05),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white24,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
