import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

// donnees fictives des annonces (a remplacer par l'API)
final List<Map<String, dynamic>> mockAnnonces = [
  {
    'titre': 'Ouverture des inscriptions au forum carriere',
    'description': 'Le forum carriere aura lieu le 15 mai. Les inscriptions sont ouvertes jusqu au 10 mai sur le portail etudiant.',
    'date': "Aujourd'hui, 08h30",
    'categorie': 'Administration',
    'est_nouveau': true,
  },
  {
    'titre': 'Mise a jour des horaires de la bibliotheque',
    'description': 'La bibliotheque sera ouverte de 8h a 20h du lundi au vendredi a partir du 1er mai.',
    'date': 'Hier, 14h15',
    'categorie': 'Administration',
    'est_nouveau': false,
  },
  {
    'titre': 'Rappel : remise des projets de groupe',
    'description': 'Les projets de groupe du module INF301 doivent etre rendus avant le vendredi 9 mai a 23h59.',
    'date': 'Il y a 2 jours',
    'categorie': 'Cours',
    'est_nouveau': false,
  },
  {
    'titre': 'Examen de rattrapage - Mathematiques Avancees',
    'description': 'Un examen de rattrapage est prevu le 20 mai en salle 201, Bloc A. Presentez-vous avec votre carte etudiant.',
    'date': 'Il y a 3 jours',
    'categorie': 'Examen',
    'est_nouveau': false,
  },
  {
    'titre': 'Journee portes ouvertes de l\'universite',
    'description': 'Vous etes invites a participer a la journee portes ouvertes le samedi 17 mai. Des stands et conferences seront organises.',
    'date': 'Il y a 5 jours',
    'categorie': 'Evenement',
    'est_nouveau': false,
  },
];

// page qui liste toutes les annonces
class AnnonceScreen extends StatefulWidget {
  const AnnonceScreen({super.key});

  @override
  State<AnnonceScreen> createState() => _AnnonceScreenState();
}

class _AnnonceScreenState extends State<AnnonceScreen> {

  // filtre selectionne (Toutes par defaut)
  String _filtreSelectionne = 'Toutes';

  // liste des filtres disponibles
  final List<String> _filtres = ['Toutes', 'Administration', 'Cours', 'Examen', 'Evenement'];

  // retourne les annonces filtrees selon le filtre selectionne
  List<Map<String, dynamic>> get _annoncesFiltered {
    if (_filtreSelectionne == 'Toutes') return mockAnnonces;
    return mockAnnonces.where((a) => a['categorie'] == _filtreSelectionne).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Annonces',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          // barre de filtres
          _buildFiltres(),
          // liste des annonces
          Expanded(
            child: _annoncesFiltered.isEmpty
              ? const Center(
                  child: Text('Aucune annonce dans cette categorie',
                    style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _annoncesFiltered.length,
                  itemBuilder: (context, index) {
                    return _buildAnnonceCard(_annoncesFiltered[index]);
                  },
                ),
          ),
        ],
      ),
    );
  }

  // barre de filtres avec chips cliquables
  Widget _buildFiltres() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filtres.map((filtre) {
            final bool estActif = _filtreSelectionne == filtre;
            return GestureDetector(
              onTap: () => setState(() => _filtreSelectionne = filtre),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: estActif ? AppColors.primary : AppColors.bgPrimary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: estActif ? AppColors.primary : AppColors.gray4,
                  ),
                ),
                child: Text(filtre,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: estActif ? AppColors.white : AppColors.gray2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // carte d'une annonce
  Widget _buildAnnonceCard(Map<String, dynamic> annonce) {
    final bool estNouveau = annonce['est_nouveau'] == true;

    return GestureDetector(
      onTap: () {
        // ouvre le detail de l'annonce
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => AnnonceDetailScreen(annonce: annonce),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.cardShadow,
          border: estNouveau
            ? Border.all(color: AppColors.secondary.withOpacity(0.3))
            : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // point indicateur
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: estNouveau ? AppColors.secondary : AppColors.gray4,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // badge categorie
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(annonce['categorie'],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (estNouveau) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('NOUVEAU',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(annonce['titre'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.gray1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(annonce['date'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gray4, size: 18),
          ],
        ),
      ),
    );
  }
}

// page de detail d'une annonce
class AnnonceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> annonce;

  const AnnonceDetailScreen({super.key, required this.annonce});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // categorie + badge nouveau
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(annonce['categorie'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // titre
            Text(annonce['titre'],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.gray1,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            // date
            Text(annonce['date'],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.bgPrimary, height: 1),
            const SizedBox(height: 20),
            // contenu de l'annonce
            Text(annonce['description'],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: AppColors.gray2,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
