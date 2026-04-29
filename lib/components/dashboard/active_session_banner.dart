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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF00875A); // Vert émeraude de la maquette
    const Color bgMenthe = Color(0xFFEFFFF5);   // Fond menthe pâle
    const Color borderMenthe = Color(0xFFD1FADC); // Bordure douce

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgMenthe,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderMenthe, width: 1.5),
      ),
      child: Row(
        children: [
          // 1. INDICATEUR CLIGNOTANT (Point + Cercle fin)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDBF7E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ligne fine extérieure
                  Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: brandGreen, width: 1.5),
                    ),
                  ),
                  // Point central
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: brandGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
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
                    color: brandGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Structures de données & Algorithmes',
                  style: TextStyle(
                    color: Color(0xFF0A261D), // Vert-Noir très sombre
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 3. BOUTON PRÉSENCE
          ElevatedButton(
            onPressed: () {
              // LIEN : Vers marquage géolocalisé (ETU-06)
              debugPrint("Navigation vers ETU-06");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const StadiumBorder(), // Forme pilule parfaite
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Présence',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}