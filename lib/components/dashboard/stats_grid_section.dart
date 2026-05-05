import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/devoir/devoirs_screen.dart';

class StatsGridSection extends StatelessWidget {
  // 1. Déclarer les variables au niveau de la classe (pas dans le build)
  final int navIndex;
  final ValueChanged<int> onNavTap;
  final double presenceRate;
  final int devoirsCount;

  const StatsGridSection({
    super.key,
    required this.navIndex,
    required this.onNavTap,
    required this.presenceRate,
    required this.devoirsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------
          // 1. CARTE PRÉSENCE (Redirige vers l'onglet du Shell)
          // ---------------------------------------------------------
          Expanded(
            child: _buildStatCard(
              child: Column(
                children: [
                  const Text(
                    "PRÉSENCE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Graphique circulaire (Exemple statique)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 75,
                        width: 75,
                        child: CircularProgressIndicator(
                          value: presenceRate,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFF06424),
                          ),
                        ),
                      ),
                      Text(
                        "${(presenceRate * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF052A36),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildViewAllButton(
                    onPressed: () {
                      onNavTap(3);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ---------------------------------------------------------
          // 2. CARTE DEVOIRS (Redirige vers un nouvel écran)
          // ---------------------------------------------------------
          Expanded(
            child: _buildStatCard(
              child: Column(
                children: [
                  const Text(
                    "DEVOIRS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$devoirsCount",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF052A36),
                    ),
                  ),
                  const Text(
                    "À rendre cette\nsemaine",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 15),
                  _buildViewAllButton(
                    onPressed: () {
                      // ✅ Ouvre l'écran Devoirs par-dessus (avec flèche retour)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DevoirsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS (Privés) ---

  Widget _buildStatCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildViewAllButton({required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 35,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF5F7F8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          "Voir tout",
          style: TextStyle(
            color: Color(0xFF052A36),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}