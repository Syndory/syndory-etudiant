import 'package:flutter/material.dart';

class StatsGridSection extends StatelessWidget {
  const StatsGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------
          // 1. CARTE PRÉSENCE
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
                  // Graphique circulaire
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 75,
                        width: 75,
                        child: CircularProgressIndicator(
                          value: 0.85,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFF06424), // Orange de la maquette
                          ),
                        ),
                      ),
                      const Text(
                        "85%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF052A36),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Bonne situation",
                    style: TextStyle(
                      color: Color(0xFF00897B), // Vert sombre
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Bouton Voir tout (Lien Présence)
                  _buildViewAllButton(
                    onPressed: () {
                      // LIEN : Naviguer vers la page ETU-09 (Historique d'assiduité / Présence)
                      print("Navigation vers ETU-09...");
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ---------------------------------------------------------
          // 2. CARTE DEVOIRS
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
                  const Text(
                    "3",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF052A36),
                    ),
                  ),
                  const Text(
                    "À rendre cette\nsemaine",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Bouton Voir tout (Lien Devoirs)
                  _buildViewAllButton(
                    onPressed: () {
                      // LIEN : Naviguer vers la page ETU-08 (Liste des devoirs / Ressources)
                      print("Navigation vers ETU-08...");
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

  // Helper pour construire le fond blanc des cartes
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

  // Helper pour le bouton "Voir tout" uniforme
  Widget _buildViewAllButton({required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 35,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF5F7F8), // Gris très clair
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          "Voir tout",
          style: TextStyle(
            color: Color(0xFF052A36), // Bleu nuit sombre
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}