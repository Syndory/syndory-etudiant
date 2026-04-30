import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/document_pedago.dart';
import '../widgets/document_card.dart';
import '../widgets/filtre_chips_bar.dart';
import '../widgets/empty_state_ressources.dart';

class RessourcesScreen extends StatefulWidget {
  final String? initialMatiere;

  const RessourcesScreen({
    super.key,
    this.initialMatiere,
  });

  @override
  State<RessourcesScreen> createState() => _RessourcesScreenState();
}

class _RessourcesScreenState extends State<RessourcesScreen> {
  final List<String> _filters = ['Cours', 'TD', 'TP', '⋯'];
  String _selectedFilter = 'Cours';

  List<DocumentPedago> get _filteredDocuments {
    List<DocumentPedago> docs = MockData.documentsDemo;
    if (widget.initialMatiere != null) {
      docs = docs.where((d) => d.matiere == widget.initialMatiere).toList();
    }
    // Simple filter simulation
    if (_selectedFilter == 'Cours') {
      return docs;
    }
    return []; // Return empty for others to show the empty state
  }

  @override
  Widget build(BuildContext context) {
    final documents = _filteredDocuments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ressources',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.bgLight,
              child: const Icon(Icons.person, color: AppColors.textSecondary, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FiltreChipsBar(
            filters: _filters,
            selectedFilter: _selectedFilter,
            hasDropdown: true,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          Expanded(
            child: documents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return DocumentCard(document: documents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: EmptyStateRessources(
            onRefresh: () {
              setState(() {
                _selectedFilter = 'Cours'; // Reset to show data
              });
            },
          ),
        ),
        // Section informative (2 lignes info pill)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInfoRow('Synchronisation automatique'),
              const SizedBox(height: 8),
              _buildInfoRow('Alertes de publication'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_none, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
