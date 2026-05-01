import 'package:flutter/material.dart';

class NotificationNavigationBar extends StatelessWidget {
  // On passe l'index de la page actuelle pour que la barre sache quel lien éclairer
  final int currentIndex;
  
  const NotificationNavigationBar({
    super.key, 
    this.currentIndex = 1, // Par défaut sur "Devoirs" (index 1)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.only(bottom: 10), // Ajustement pour l'espace du bas
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavLink(context, 0, Icons.grid_view_rounded, "Accueil"),
          _buildNavLink(context, 1, Icons.assignment_outlined, "Devoirs"),
          _buildNavLink(context, 2, Icons.calendar_today_outlined, "Emploi"),
          _buildNavLink(context, 3, Icons.person_outline_rounded, "Profil"),
        ],
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;
    final color = isActive ? const Color(0xFFF06424) : const Color(0xFF667A81);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Rend toute la zone cliquable
        onTap: () {
          // LOGIQUE DE LIEN : ICI TU AJOUTES TA NAVIGATION
          if (!isActive) {
             print("Navigation vers la page : $label");
             // Exemple : Navigator.pushNamed(context, '/${label.toLowerCase()}');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            // Le point orange dynamique sous le texte
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFF06424),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}