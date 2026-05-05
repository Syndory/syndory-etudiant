import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

/// Carte représentant une matière.
class MatiereCard extends StatelessWidget {
  final String nom;
  final String badge;
  final Color couleurBadge;
  final double assiduite;   // entre 0.0 et 1.0
  final String prof;
  final int coefficient;
  final double progression; // entre 0.0 et 1.0
  final IconData avatarIcon;

  const MatiereCard({super.key, 
    required this.nom,
    required this.badge,
    required this.couleurBadge,
    required this.assiduite,
    required this.prof,
    required this.coefficient,
    required this.progression,
    this.avatarIcon = Icons.person,
  });

  /// Couleur de l'assiduité selon le taux
  Color get _couleurAssiduite {
    if (assiduite >= 0.80) return AppColors.success;
    if (assiduite >= 0.50) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatiereDetailScreen(
              matiere: {
                'nom': nom,
                'avatarIcon': avatarIcon,
                'badge': badge,
                'couleurBadge': couleurBadge,
                'progression': progression,
                'assiduite': assiduite,
                'prof': prof,
                'coefficient': coefficient,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border(
          left: BorderSide(color: couleurBadge, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: couleurBadge.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: couleurBadge,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'ASSIDUITÉ',
                    style: AppTextStyles.sectionLabel,
                  ),
                  Text(
                    '${(assiduite * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _couleurAssiduite,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            nom,
            style: AppTextStyles.heading.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: couleurBadge.withOpacity(0.15),
                child: Icon(avatarIcon, size: 16, color: couleurBadge),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prof,
                    style: AppTextStyles.body.copyWith(fontSize: 12),
                  ),
                  Text(
                    'Coefficient: $coefficient',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Progression du cours',
                style: AppTextStyles.body.copyWith(fontSize: 11, color: AppColors.gray2),
              ),
              const Spacer(),
              Text(
                '${(progression * 100).toInt()}%',
                style: AppTextStyles.body.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progression,
              minHeight: 6,
              backgroundColor: AppColors.gray4.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
