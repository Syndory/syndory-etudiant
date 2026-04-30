import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/matiere.dart';
import '../widgets/chapitre_item.dart';
import '../widgets/seance_item.dart';
import 'ressources_screen.dart';

class MatiereDetailScreen extends StatelessWidget {
  final Matiere matiere;

  const MatiereDetailScreen({
    super.key,
    required this.matiere,
  });

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
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          matiere.nom,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code matière
            Text(
              matiere.code,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            // Titre principal
            Text(
              matiere.nom,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Section KPIs
            Row(
              children: [
                Expanded(child: _buildKpiCard('Progression', '${(matiere.tauxProgression * 100).toInt()}%', Icons.trending_up)),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard('Assiduité', '${(matiere.tauxAssiduite * 100).toInt()}%', Icons.person)),
              ],
            ),
            const SizedBox(height: 32),
            // Programme du cours
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Programme du cours',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600, // semibold
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${matiere.chapitres.where((c) => c.traite).length} / ${matiere.chapitres.length} Chapitres',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (matiere.chapitres.isEmpty)
              const Text('Aucun chapitre défini', style: TextStyle(color: AppColors.textSecondary)),
            ...matiere.chapitres.map((chapitre) => ChapitreItem(chapitre: chapitre)),
            const SizedBox(height: 32),
            // Ressources
            const Text(
              'Ressources',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildResourceCard(
                    context,
                    'Syllabus PDF',
                    '20 sept',
                    Icons.picture_as_pdf,
                    const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResourceCard(
                    context,
                    'Notes de cours',
                    '18 sept',
                    Icons.description,
                    const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Historique des séances
            const Text(
              'Historique des séances',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (matiere.seances.isEmpty)
              const Text('Aucune séance enregistrée', style: TextStyle(color: AppColors.textSecondary)),
            ...matiere.seances.map((seance) => SeanceItem(seance: seance)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, String title, String date, IconData icon, Color iconColor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RessourcesScreen(initialMatiere: matiere.nom),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.bgLight),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
