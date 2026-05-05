import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:syndory_etudiant/components/appTheme.dart';

// page de detail d'une matiere
// on arrive ici en cliquant sur une carte dans "Mes matieres"
class MatiereDetailScreen extends StatelessWidget {
  final Map<String, dynamic> matiere;

  const MatiereDetailScreen({super.key, required this.matiere});

  // couleur selon le taux d'assiduite
  Color _couleurAssiduite(double taux) {
    if (taux >= 0.80) return AppColors.success;
    if (taux >= 0.50) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final String nom = matiere['nom'] ?? '';
    final String badge = matiere['badge'] ?? '';
    final Color couleur = matiere['couleurBadge'] ?? AppColors.primary;
    final double assiduite = (matiere['assiduite'] ?? 0.0) as double;
    final double progression = (matiere['progression'] ?? 0.0) as double;
    final String prof = matiere['prof'] ?? '';
    final int coeff = (matiere['coefficient'] ?? 1) as int;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: couleur,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(badge,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // bandeau du haut avec le nom de la matiere
            _buildBandeau(nom, prof, couleur),
            const SizedBox(height: 16),
            // stats rapides (assiduite + progression)
            _buildStats(assiduite, progression, coeff, couleur),
            const SizedBox(height: 16),
            // sessions recentes (mock)
            _buildSessionsRecentes(),
          ],
        ),
      ),
    );
  }

  // bandeau colore avec le nom et le prof
  Widget _buildBandeau(String nom, String prof, Color couleur) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nom,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(prof,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // cartes de statistiques
  Widget _buildStats(double assiduite, double progression, int coeff, Color couleur) {
    final Color coulAssiduite = _couleurAssiduite(assiduite);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // ligne avec assiduite et coefficient
          Row(
            children: [
              Expanded(child: _statCard(
                label: 'Assiduite',
                value: '${(assiduite * 100).toInt()}%',
                couleur: coulAssiduite,
                icon: Icons.fact_check_outlined,
              )),
              const SizedBox(width: 12),
              Expanded(child: _statCard(
                label: 'Coefficient',
                value: '$coeff',
                couleur: AppColors.primary,
                icon: Icons.star_outline,
              )),
            ],
          ),
          const SizedBox(height: 12),
          // barre de progression du cours
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Progression du cours',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.gray1,
                      ),
                    ),
                    Text('${(progression * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: couleur,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progression,
                    minHeight: 8,
                    backgroundColor: AppColors.gray4.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(couleur),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // petite carte de stat individuelle
  Widget _statCard({required String label, required String value, required Color couleur, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: couleur, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: couleur,
                ),
              ),
              Text(label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // liste des dernieres seances (donnees fictives)
  Widget _buildSessionsRecentes() {
    // seances fictives pour la demo
    final List<Map<String, dynamic>> seances = [
      {'date': 'Lundi 28 avril', 'duree': '2h', 'statut': 'present'},
      {'date': 'Lundi 21 avril', 'duree': '2h', 'statut': 'present'},
      {'date': 'Lundi 14 avril', 'duree': '2h', 'statut': 'absent'},
      {'date': 'Lundi 7 avril', 'duree': '2h', 'statut': 'present'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Seances recentes',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.gray1,
            ),
          ),
          const SizedBox(height: 12),
          ...seances.map((s) => _buildSeanceItem(s)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSeanceItem(Map<String, dynamic> seance) {
    final bool present = seance['statut'] == 'present';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          // icone present ou absent
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: present
                ? AppColors.success.withOpacity(0.1)
                : AppColors.danger.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              present ? Icons.check : Icons.close,
              color: present ? AppColors.success : AppColors.danger,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(seance['date'],
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.gray1,
                  ),
                ),
                Text('Duree : ${seance['duree']}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            present ? 'Present' : 'Absent',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: present ? AppColors.success : AppColors.danger,
=======
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/screens/ressources/ressources_screen.dart';

class MatiereDetailScreen extends StatelessWidget {
  final Map<String, dynamic> matiere;

  const MatiereDetailScreen({
    super.key,
    required this.matiere,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Color(0xFFF06424)),
        ),
        title: Text(
          matiere['nom'] as String,
          style: const TextStyle(
            color: Color(0xFFF06424),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                matiere['avatarIcon'] as IconData,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              matiere['badge'] as String,
              style: TextStyle(
                color: matiere['couleurBadge'] as Color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              matiere['nom'] as String,
              style: const TextStyle(
                color: Color(0xFF1A3C4D),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    iconColor: const Color(0xFFF06424),
                    label: 'Progression',
                    value: '${((matiere['progression'] as double) * 100).toInt()}%',
                    valueColor: const Color(0xFFF06424),
                    progress: matiere['progression'] as double,
                    progressColor: const Color(0xFFF06424),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF2C3E50),
                    label: 'Assiduité',
                    value: '${((matiere['assiduite'] as double) * 100).toInt()}%',
                    valueColor: const Color(0xFF2C3E50),
                    progress: matiere['assiduite'] as double,
                    progressColor: const Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Programme du cours',
                  style: TextStyle(
                    color: Color(0xFF1A3C4D),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '4 / 6 Chapitres',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ChapitreItem(
              titre: 'Chapitre 1: Introduction',
              sousTitre: 'Théorie des graphes & Complexité',
              traite: true,
            ),
            const SizedBox(height: 8),
            _ChapitreItem(
              titre: 'Chapitre 2: Diviser pour régner',
              sousTitre: 'Récursivité & Master Theorem',
              traite: true,
            ),
            const SizedBox(height: 8),
            _ChapitreItem(
              titre: 'Chapitre 5: Programmation Dynamique',
              sousTitre: 'Mémoïsation & Tableaux',
              traite: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Ressources',
              style: TextStyle(
                color: Color(0xFF1A3C4D),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RessourceCard(
                    icon: Icons.picture_as_pdf,
                    iconColor: const Color(0xFFF06424),
                    iconBgColor: const Color(0xFFFFEEE6),
                    titre: 'Syllabus PDF',
                    sousTitre: '2.4 MB • v/2024',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RessourceCard(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF2C3E50),
                    iconBgColor: const Color(0xFFEEF2F5),
                    titre: 'Notes de cours',
                    sousTitre: 'Mis à jour hier',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Historique des séances',
              style: TextStyle(
                color: Color(0xFF1A3C4D),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _SeanceItem(
              mois: 'MAI',
              jour: '24',
              titre: 'Séance #12',
              sousTitre: 'Amphi A • 08:30 – 10:30',
              present: true,
            ),
            const SizedBox(height: 8),
            _SeanceItem(
              mois: 'MAI',
              jour: '17',
              titre: 'Séance #11',
              sousTitre: 'Amphi A • 09:00 – 10:30',
              present: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RessourcesScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF06424),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.folder_open),
                label: const Text(
                  'Voir les ressources pédagogiques',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final double progress;
  final Color progressColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
>>>>>>> origin/develop
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< HEAD
=======

class _ChapitreItem extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final bool traite;

  const _ChapitreItem({
    required this.titre,
    required this.sousTitre,
    required this.traite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFFF06424), width: 3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: const TextStyle(
                    color: Color(0xFF1A3C4D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sousTitre,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: traite ? const Color(0xFFE6F4EA) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              traite ? 'TRAITÉ' : 'NON\nTRAITÉ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: traite ? const Color(0xFF2E7D32) : Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RessourceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String titre;
  final String sousTitre;

  const _RessourceCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.titre,
    required this.sousTitre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            titre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A3C4D),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sousTitre,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeanceItem extends StatelessWidget {
  final String mois;
  final String jour;
  final String titre;
  final String sousTitre;
  final bool present;

  const _SeanceItem({
    required this.mois,
    required this.jour,
    required this.titre,
    required this.sousTitre,
    required this.present,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                mois,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                jour,
                style: const TextStyle(
                  color: Color(0xFF1A3C4D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: const TextStyle(
                    color: Color(0xFF1A3C4D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sousTitre,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: present ? const Color(0xFF2E7D32) : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                present ? 'PRÉSENT' : 'ABSENT',
                style: TextStyle(
                  color: present ? const Color(0xFF2E7D32) : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
>>>>>>> origin/develop
