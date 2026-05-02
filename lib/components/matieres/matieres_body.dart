import 'package:flutter/material.dart';
import 'matiere_card.dart';
import 'package:syndory_etudiant/screens/matieres/matiere_detail_screen.dart';

/// Corps principal de l'écran "Mes Matières".
/// Contient une barre de recherche, des onglets Semestre 1/2/3,
/// et filtre les matières dynamiquement.
///
/// [activeSemestre]      : semestre actif (1, 2 ou 3)
/// [onSemestreChanged]   : callback quand l'utilisateur change de semestre.
/// [matieres]            : liste COMPLÈTE des matières (avec champ 'semestre').
class MatieresBody extends StatelessWidget {
  final int activeSemestre;
  final ValueChanged<int>? onSemestreChanged;
  final List<Map<String, dynamic>> matieres;
  final String searchQuery;
  final ValueChanged<String>? onSearchChanged;

  const MatieresBody({super.key, 
    this.activeSemestre = 1,
    this.onSemestreChanged,
    required this.matieres,
    this.searchQuery = '',
    this.onSearchChanged,
  });

  static const _semestres = ['Semestre 1', 'Semestre 2', 'Semestre 3'];

  @override
  Widget build(BuildContext context) {
    // ── Filtre : semestre + recherche textuelle ──────────────────────────
    final matieresFiltrees = matieres.where((m) {
      final matchSemestre = m['semestre'] == activeSemestre;
      final matchSearch = searchQuery.isEmpty ||
          (m['nom'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          (m['prof'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      return matchSemestre && matchSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Barre de recherche ───────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Rechercher une matière...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // ── Onglets Semestre ─────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 12),
          child: Row(
            children: List.generate(_semestres.length, (index) {
              final isActive = activeSemestre == index + 1;
              return Padding(
                padding: EdgeInsets.only(
                    right: index < _semestres.length - 1 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => onSemestreChanged?.call(index + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.orange : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? Colors.orange
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      _semestres[index],
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 4),

        // ── Liste filtrée des matières ────────────────────────────────────
        Expanded(
          child: matieresFiltrees.isEmpty
              // Message si aucune matière
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        searchQuery.isEmpty
                            ? 'Aucune matière ce semestre'
                            : 'Aucun résultat pour "$searchQuery"',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: matieresFiltrees.length,
                  itemBuilder: (context, index) {
                    final m = matieresFiltrees[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatiereDetailScreen(matiere: m),
                          ),
                        );
                      },
                      child: MatiereCard(
                        nom: m['nom'] as String,
                        badge: m['badge'] as String,
                        couleurBadge: m['couleurBadge'] as Color,
                        assiduite: (m['assiduite'] as num).toDouble(),
                        prof: m['prof'] as String,
                        coefficient: m['coefficient'] as int,
                        progression: (m['progression'] as num).toDouble(),
                        avatarIcon: m['avatarIcon'] as IconData,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}