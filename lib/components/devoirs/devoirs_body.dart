import 'package:flutter/material.dart';
import 'devoir_card.dart';
import 'tab_item.dart';

/// Corps principal de l'écran "Mes Devoirs".
/// Filtre automatiquement les devoirs selon l'onglet actif.
///
/// [activeTab]     : index de l'onglet actif (0 = À faire, 1 = En cours, 2 = Terminés)
/// [onTabChanged]  : callback appelé quand l'utilisateur change d'onglet.
/// [devoirs]       : liste COMPLÈTE des devoirs (avec champ 'statut').
class DevoirsBody extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int>? onTabChanged;
  final List<Map<String, dynamic>> devoirs;

  const DevoirsBody({
    this.activeTab = 0,
    this.onTabChanged,
    required this.devoirs,
  });

  // Les 3 onglets et leur valeur de 'statut' correspondante dans les mocks
  static const _tabs = ['À faire', 'En cours', 'Terminés'];
  static const _statuts = ['a_faire', 'en_cours', 'termine'];

  @override
  Widget build(BuildContext context) {
    // ── Filtre : on garde uniquement les devoirs du bon onglet ──────────────
    final statutRecherche = _statuts[activeTab];
    final devoirsFiltres = devoirs
        .where((d) => d['statut'] == statutRecherche)
        .toList();

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

        // ── Liste filtrée des devoirs ─────────────────────────────────────────
        Expanded(
          child: devoirsFiltres.isEmpty
              // Message si aucun devoir dans cet onglet
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 64, color: Colors.grey.shade300),
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
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  itemCount: devoirsFiltres.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final d = devoirsFiltres[index];
                    return DevoirCard(
                      matiere: d['matiere'] as String,
                      titre: d['titre'] as String,
                      date: d['date'] as String,
                      progression: (d['progression'] as num).toDouble(),
                      niveau: d['niveau'] as String,
                      couleur: d['couleur'] as Color,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

