import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';


class EmptyAttendanceScreen extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;
  final VoidCallback? onRefresh;

  const EmptyAttendanceScreen({
    super.key,
    this.navIndex = 0,
    this.onNavTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: 'Assiduité'),
      // SingleChildScrollView évite le RenderFlex overflow sur petits écrans
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            // hauteur min = écran dispo pour centrer le contenu sur grands écrans
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  72, // hauteur bottom nav
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // ── Illustration ────────────────────────────────────────
                  const _IllustrationWidget(),

                  const SizedBox(height: 32),

                  // ── Titre ───────────────────────────────────────────────
                  const Text(
                    'Presque là !',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Description ─────────────────────────────────────────
                  const Text(
                    'Pas encore de données d\'assiduité. Vos présences s\'afficheront ici dès qu\'elles seront enregistrées par vos professeurs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Bouton ──────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        'Actualiser la page',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
    );
  }

}

/// Illustration fidèle au design : carte claire + icône orange flottante.
class _IllustrationWidget extends StatelessWidget {
  const _IllustrationWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Carte blanche de fond (légèrement inclinée) ─────────────────
          Positioned(
            bottom: 0,
            child: Transform.rotate(
              angle: 0.05,
              child: Container(
                width: 160,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                // Lignes simulant du contenu
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FakeLine(width: 100, opacity: 0.25),
                      const SizedBox(height: 6),
                      _FakeLine(width: 70, opacity: 0.15),
                      const SizedBox(height: 6),
                      _FakeLine(width: 85, opacity: 0.20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Icône orange flottante ───────────────────────────────────────
          Positioned(
            top: 0,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mail_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeLine extends StatelessWidget {
  final double width;
  final double opacity;
  const _FakeLine({required this.width, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(opacity),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}