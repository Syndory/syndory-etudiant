import 'package:flutter/material.dart';
import '../../components/appNavbar.dart';
import '../../components/devoirs/devoirs_body.dart';
import '../../mocks/mocksDevoirs.dart'; // ← données factices (remplacées plus tard par l'API)

/// Écran "Mes Devoirs".
/// Assemble AppNavbar + DevoirsBody avec filtrage par onglet.
class DevoirsScreen extends StatefulWidget {
  @override
  State<DevoirsScreen> createState() => _DevoirsScreenState();
}

class _DevoirsScreenState extends State<DevoirsScreen> {
  int _activeTab = 0; // 0 = À faire | 1 = En cours | 2 = Terminés

  //  Données factices importées depuis lib/mocks/mocks_devoirs.dart 
  // Pour utiliser la vraie API plus tard : remplace mockDevoirs par ton appel réseau
  final List<Map<String, dynamic>> _devoirs = mockDevoirs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      // ── 1. Barre de navigation supérieure ─────────────────────
      appBar: AppNavbar(title: 'Mes Devoirs'),

      // ── 2. Corps principal (filtrage géré dans DevoirsBody) ───
      body: DevoirsBody(
        activeTab: _activeTab,
        devoirs: _devoirs,
        onTabChanged: (index) => setState(() => _activeTab = index),
      ),

      // NOTE : la BottomNavBar est dans MainScreen, pas ici.
      //        Comme ça elle reste visible sur tous les écrans.
    );
  }
}