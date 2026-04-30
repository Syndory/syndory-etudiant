import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/matiere_card.dart';
import 'matiere_detail_screen.dart';

class MesMatieresScreen extends StatefulWidget {
  const MesMatieresScreen({super.key});

  @override
  State<MesMatieresScreen> createState() => _MesMatieresScreenState();
}

class _MesMatieresScreenState extends State<MesMatieresScreen> {
  String _selectedSemestre = 'Semestre 1';
  final List<String> _semestres = ['Semestre 1', 'Semestre 2', 'Semestre 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: const Text(
          'Mes matières',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une matière...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.bgLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          // Tabs semestre
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _semestres.map((semestre) {
                final isActive = semestre == _selectedSemestre;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSemestre = semestre),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      semestre,
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Liste des matières
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.matieresDemo.length,
              itemBuilder: (context, index) {
                final matiere = MockData.matieresDemo[index];
                return MatiereCard(
                  matiere: matiere,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatiereDetailScreen(matiere: matiere),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
