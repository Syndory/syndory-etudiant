import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF092C4C);   // navy
  static const Color secondary = Color(0xFFF2994A); // orange

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color info    = Color(0xFF2F80ED);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFE2B93B);
  static const Color danger  = Color(0xFFEB5757);

  // ── Grays ─────────────────────────────────────────────────────────────────
  static const Color gray1 = Color(0xFF333333);
  static const Color gray2 = Color(0xFF4F4F4F);
  static const Color gray3 = Color(0xFF828282);
  static const Color gray4 = Color(0xFFBDBDBD);
  static const Color white = Color(0xFFFFFFFF);

  // ── Backgrounds 
  static const Color bgPrimary = Color(0xFFF4F4F4); // écran
  static const Color bgCard    = Color(0xFFFFFFFF); // cartes

  // ── Aliases pour les anciens widgets (rétro-compat) ───────────────────────
  static const Color orange      = secondary;
  static const Color orangeLight = Color(0xFFF9B27A);
  static const Color textPrimary   = primary;
  static const Color textSecondary = gray3;
  static const Color textMuted     = gray4;
  static const Color progressBg    = gray4;

  // ── Ombre carte 
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}

class AppTextStyles {
  // Inter SemiBold 16px navy — noms / titres
  static const TextStyle heading = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.primary,
  );

  // Inter Regular 14px gray1 — corps de texte
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.gray1,
  );

  // Inter SemiBold 12px gray3 uppercase — labels de section
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.gray3,
    letterSpacing: 0.8,
  );

  // Inter Bold — boutons
  static const TextStyle button = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: AppColors.white,
  );
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        fontFamily: 'Inter',

        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.bgCard,
          error: AppColors.danger,
        ),

        // AppBar : fond blanc, titre navy bold
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primary),
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppColors.primary,
          ),
        ),

        // Bottom nav : fond navy, actif orange
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.primary,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Color(0xFF7A9BB5),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
          ),
          elevation: 0,
        ),

        // Cartes : fond blanc, radius 12, shadow subtile
        cardTheme: CardThemeData(
          color: AppColors.bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black.withOpacity(0.08),
        ),

        // Bouton primaire : navy, radius 12
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            textStyle: AppTextStyles.button,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),

        // Bouton secondaire/CTA : orange, radius 12
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.white,
            side: BorderSide.none,
            textStyle: AppTextStyles.button,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );
}