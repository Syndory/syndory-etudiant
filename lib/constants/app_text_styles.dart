import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Titre écran 20sp bold
  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Titre carte 15sp semibold
  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // Corps 13sp regular
  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  // Label 11sp regular
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textSecondary,
  );
}
