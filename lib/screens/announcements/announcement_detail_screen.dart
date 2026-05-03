// lib/screens/announcements/announcement_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/announcements/attachment_item.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
    this.navIndex = 5,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(context),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: onNavTap,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge catégorie + temps de lecture ──
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    announcement.categoryLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: AppColors.secondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '• ${announcement.readTime}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.gray3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Titre ──
            Text(
              announcement.title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.primary,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            // ── Carte auteur ──
            if (announcement.authorName != null) _buildAuthorCard(),

            const SizedBox(height: 16),

            // ── Image hero ──
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/decoration.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.gray4,
                    size: 64,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Corps du texte ──
            _buildBodyText(),

            // ── Pièces jointes ──
            if (announcement.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAttachments(),
            ],
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AppBar personnalisée : ← Détail [cloche orange]
  // ─────────────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Détail',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: AppColors.primary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.secondary,
            size: 24,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Carte auteur
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAuthorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          // Nom + rôle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.authorName!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                if (announcement.authorRole != null)
                  Text(
                    announcement.authorRole!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.gray3,
                    ),
                  ),
              ],
            ),
          ),
          // Date + heure
          if (announcement.publishDate != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  announcement.publishDate!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
                if (announcement.publishTime != null)
                  Text(
                    'Publié à ${announcement.publishTime}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.gray3,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Corps : paragraphes séparés par la citation
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBodyText() {
    final parts = announcement.body.split('\n\n');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Text(
              parts[i],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.gray2,
                height: 1.65,
              ),
            ),
            // Insérer la citation après le 2e paragraphe
            if (i == 1 && announcement.quote != null) ...[
              const SizedBox(height: 16),
              _buildQuote(),
              const SizedBox(height: 2),
            ],
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Bloc citation (bordure orange gauche, fond bleu très clair)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildQuote() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FB),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: AppColors.secondary, width: 3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Text(
        announcement.quote!,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontStyle: FontStyle.italic,
          fontSize: 13,
          color: AppColors.gray2,
          height: 1.6,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Section pièces jointes
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAttachments() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre section
          Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Pièces jointes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Liste des fichiers
          ...announcement.attachments.map(
            (a) => AttachmentItem(attachment: a),
          ),
        ],
      ),
    );
  }
}
