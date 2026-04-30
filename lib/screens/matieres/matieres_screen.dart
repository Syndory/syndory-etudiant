import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbar.dart';
import 'package:syndory_etudiant/components/matieres/matieres_body.dart';
import 'package:syndory_etudiant/mocks/mocks_matieres.dart';

/// Écran "Mes Matières".
class MatieresScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const MatieresScreen({
    super.key,
    this.navIndex = 2,
    this.onNavTap,
  });

  @override
  State<MatieresScreen> createState() => _MatieresScreenState();
}

class _MatieresScreenState extends State<MatieresScreen> {
  int _activeSemestre = 1;
  String _searchQuery = '';
  final List<Map<String, dynamic>> _matieres = mockMatieres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppNavbar(title: 'Mes matières'),
      body: MatieresBody(
        activeSemestre: _activeSemestre,
        matieres: _matieres,
        searchQuery: _searchQuery,
        onSemestreChanged: (semestre) =>
            setState(() => _activeSemestre = semestre),
        onSearchChanged: (query) =>
            setState(() => _searchQuery = query),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }
}
