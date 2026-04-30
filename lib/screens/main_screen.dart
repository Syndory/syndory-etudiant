import 'package:flutter/material.dart';
import '../components/devoirs/bottom_nav_bar.dart';

// Les 4 écrans correspondant aux 4 icônes de la barre de navigation
import 'accueil_screen.dart';
import 'devoirs_screen.dart';
import 'matieres_screen.dart'; // ← remplace la page vide EmploiScreen
import 'profil_screen.dart';

///  Point d'entrée de la navigation principale.
///  Gère le changement d'écran quand on clique sur la BottomNavBar.

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index de l'icône active dans la barre de navigation (0 = Accueil)
  int _activeNav = 1; // On démarre sur "Devoirs" par défaut

  // La liste des 4 écrans, dans le même ordre que les icônes de la BottomNavBar
  //   index 0 → Accueil
  //   index 1 → Devoirs
  //   index 2 → Emploi du temps
  //   index 3 → Profil
  final List<Widget> _screens = [
    const AccueilScreen(),
    DevoirsScreen(),         // l'écran qu'on avait déjà
    MatieresScreen(),        //  Mes Matières (remplace la page vide Emploi)
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ─ Affiche l'écran correspondant à l'icône cliquée 
      body: _screens[_activeNav],

      //  Barre de navigation inférieure 
      bottomNavigationBar: BottomNavBar(
        currentIndex: _activeNav,
        onTap: (index) => setState(() => _activeNav = index), // change d'écran
      ),
    );
  }
}
