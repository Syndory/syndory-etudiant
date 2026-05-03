// lib/components/announcements/empty_state_announcements.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';

class EmptyStateAnnouncements extends StatelessWidget {
  final VoidCallback? onRefresh;

  const EmptyStateAnnouncements({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône mégaphone dans un container arrondi blanc
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.campaign_rounded,
                  color: AppColors.secondary,
                  size: 56,
                ),
              ),
            ),

            // Petites barres décoratives (pied du "moniteur")
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bar(64),
                const SizedBox(width: 6),
                _bar(40),
              ],
            ),

            const SizedBox(height: 32),

            // Titre
            const Text(
              'Aucune annonce pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.primary,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            // Sous-titre
            const Text(
              "Revenez plus tard pour les mises à jour administratives et les "
              "communications importantes de l'établissement.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.gray3,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 40),

            // Bouton "Actualiser le flux"
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onRefresh,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.gray4.withOpacity(0.5),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Actualiser le flux',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double width) => Container(
        width: width,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.gray4.withOpacity(0.5),
          borderRadius: BorderRadius.circular(3),
        ),
      );
}
