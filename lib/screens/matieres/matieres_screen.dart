import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart'; // Import du nouveau composant
import 'package:syndory_etudiant/components/matieres/matieres_body.dart';
import 'package:syndory_etudiant/mocks/mocks_matieres.dart';
import 'package:syndory_etudiant/screens/notification/notifications_screen.dart'; // Import pour le clic

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
      
      // CORRECTION : Utilisation de AppNavBarNoReturn avec action notification
      appBar: AppNavBarNoReturn(
        title: 'Mes matières',
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
      ),
      
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