import 'package:flutter/material.dart';
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
            ),
          ),
        ],
      ),
    );
  }
}
