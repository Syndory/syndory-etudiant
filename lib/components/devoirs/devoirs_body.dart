import 'package:flutter/material.dart';
import '../../models/matiere_model.dart';
import 'devoir_card.dart';
import 'tab_item.dart';

class DevoirsBody extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int>? onTabChanged;
  final List<Matiere> matieres;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;

  const DevoirsBody({
    super.key,
    this.activeTab = 0,
    this.onTabChanged,
    required this.matieres,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  static const _tabs = ['À faire', 'En cours', 'Terminés'];
  static const _statuts = ['a_faire', 'en_cours', 'termine'];

  @override
  Widget build(BuildContext context) {
    final statutRecherche = _statuts[activeTab];
    final filteredMatieres = matieres.where((m) => m.statut == statutRecherche).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Onglets de filtre ────────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => onTabChanged?.call(index),
                  child: TabItem(
                    text: _tabs[index],
                    active: activeTab == index,
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 8),

        // ── Contenu Principal ───────────────────────────────────────────────
        Expanded(
          child: _buildContent(context, filteredMatieres),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, List<Matiere> filtered) {
    if (isLoading && matieres.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && matieres.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage!, textAlign: TextAlign.center),
            TextButton(onPressed: onRefresh, child: const Text('Réessayer')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: filtered.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return DevoirCard(matiere: filtered[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: 150, child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'Aucun devoir ici !',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

