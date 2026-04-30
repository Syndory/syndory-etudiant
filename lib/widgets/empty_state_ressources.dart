import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EmptyStateRessources extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyStateRessources({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        // Illustration centrale
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.folder_open,
                size: 80,
                color: AppColors.bgLight,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Textes
        const Text(
          'Aucun document disponible',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // semibold
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Il n\'y a aucun document pour le moment. Revenez plus tard ou contactez votre administration si cela semble être une erreur.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        // Bouton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Rafraîchir la page',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
