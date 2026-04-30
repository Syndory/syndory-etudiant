import 'package:flutter/material.dart';
import '../components/devoirs/app_navbar.dart';
import '../components/matieres/matieres_body.dart';
import '../mocks/mocks_matieres.dart'; // ← données factices (remplacées plus tard par l'API)

/// Écran "Mes Matières".
/// Assemble AppNavbar + MatieresBody avec filtrage par semestre et recherche.
class MatieresScreen extends StatefulWidget {
  @override
  State<MatieresScreen> createState() => _MatieresScreenState();
}

class _MatieresScreenState extends State<MatieresScreen> {
  int _activeSemestre = 1;    // 1 = Semestre 1 | 2 = Semestre 2 | 3 = Semestre 3
  String _searchQuery = '';   // texte de recherche en cours

  // Données factices importées depuis lib/mocks/mocks_matieres.dart
  // Pour utiliser la vraie API plus tard : remplace mockMatieres par ton appel réseau
  final List<Map<String, dynamic>> _matieres = mockMatieres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      // ── 1. Barre de navigation supérieure 
      appBar: AppNavbar(title: 'Mes matières'),

      // ── 2. Corps principal (filtrage géré dans MatieresBody) ─
      body: MatieresBody(
        activeSemestre: _activeSemestre,
        matieres: _matieres,
        searchQuery: _searchQuery,
        onSemestreChanged: (semestre) =>
            setState(() => _activeSemestre = semestre),
        onSearchChanged: (query) =>
            setState(() => _searchQuery = query),
      ),

      // NOTE : la BottomNavBar est dans MainScreen, pas ici.
      //        Comme ça elle reste visible sur tous les écrans.
    );
  }
}
