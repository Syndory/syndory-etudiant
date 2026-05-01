import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';

class RessourcesScreen extends StatefulWidget {
  const RessourcesScreen({super.key});

  @override
  State<RessourcesScreen> createState() => _RessourcesScreenState();
}

class _RessourcesScreenState extends State<RessourcesScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Cours', 'TD', 'TP', 'Examens'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ressources pédagogiques',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher une ressource...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.orange : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.orange : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF4B5563),
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Liste des ressources
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildResourceCard(
                  title: 'Support_Cours_V2.pdf',
                  subtitle: 'Modifié le 12 Oct 2024 • 2.4 MB',
                  type: 'Cours',
                  icon: Icons.picture_as_pdf,
                  iconColor: const Color(0xFFEF4444), // Rouge pour PDF
                ),
                _buildResourceCard(
                  title: 'TD_Arbres_Equilibres.zip',
                  subtitle: 'Modifié le 14 Oct 2024 • 5.1 MB',
                  type: 'TD',
                  icon: Icons.folder_zip,
                  iconColor: const Color(0xFFF59E0B), // Orange pour ZIP
                ),
                _buildResourceCard(
                  title: 'TP_Graphes_Code.zip',
                  subtitle: 'Modifié le 16 Oct 2024 • 1.2 MB',
                  type: 'TP',
                  icon: Icons.folder_zip,
                  iconColor: const Color(0xFFF59E0B),
                ),
                _buildResourceCard(
                  title: 'Annales_Examen_2023.pdf',
                  subtitle: 'Modifié le 10 Sep 2024 • 3.5 MB',
                  type: 'Examens',
                  icon: Icons.picture_as_pdf,
                  iconColor: const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String subtitle,
    required String type,
    required IconData icon,
    required Color iconColor,
  }) {
    // Si le filtre ne correspond pas, on ne l'affiche pas
    if (_selectedFilter != 'Tous' && _selectedFilter != type) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Color(0xFF0284C7)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
