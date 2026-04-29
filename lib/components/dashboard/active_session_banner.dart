import 'package:flutter/material.dart';

class ActiveSessionBanner extends StatefulWidget {
  const ActiveSessionBanner({super.key});

  @override
  State<ActiveSessionBanner> createState() => _ActiveSessionBannerState();
}

class _ActiveSessionBannerState extends State<ActiveSessionBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Animation rapide pour le petit point vert uniquement
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // COULEUR CORRIGÉE : Bleu nuit sombre de la maquette
        color: const Color(0xFF052A36), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. INDICATEUR : Le cercle de fond est fixe, seul le point pulse
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
              // SEUL CE POINT VERT CLIGNOTE
              FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00897B), // Vert émeraude de présence
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // 2. TEXTES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EN COURS',
                  style: TextStyle(
                    color: Color(0xFF00897B), // Vert pour le statut
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Structures de données & Algorithmes',
                  style: TextStyle(
                    color: Colors.white, // Texte blanc sur fond bleu nuit
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 3. BOUTON PRÉSENCE (Action vers ETU-06)
          ElevatedButton(
            onPressed: () {
              // LIEN : Vers marquage géolocalisé[cite: 1]
              debugPrint("Navigation vers ETU-06");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B), // Vert émeraude[cite: 1]
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              'Présence',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}