// lib/screens/announcements/announcements_screen.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/announcements/empty_state_announcements.dart';
import 'package:syndory_etudiant/components/announcements/announcements_hero_header.dart';
import 'package:syndory_etudiant/components/announcements/announcements_filter_tabs.dart';
import 'package:syndory_etudiant/components/announcements/announcement_card.dart';
import 'package:syndory_etudiant/mocks/announcements_mock.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';
import 'package:syndory_etudiant/screens/announcements/announcement_detail_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const AnnouncementsScreen({
    super.key,
    this.navIndex = 5,
    this.onNavTap,
  });

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  // ── Bascule vide/rempli pour le dev ──────────────────────────────────────
  bool _hasAnnouncements = true;

  // ── Filtre actif (null = Toutes) ─────────────────────────────────────────
  AnnouncementCategory? _activeFilter;

  List<AnnouncementModel> get _filtered {
    if (_activeFilter == null) return AnnouncementsMock.announcements;
    return AnnouncementsMock.announcements
        .where((a) => a.category == _activeFilter)
        .toList();
  }

  void _onRefresh() => setState(() => _hasAnnouncements = true);

  void _openDetail(AnnouncementModel a) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailScreen(
          announcement: a,
          navIndex: widget.navIndex,
          onNavTap: widget.onNavTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: "Annonce", onNotificationPressed: () {  },),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
      body: _hasAnnouncements ? _buildListView() : _buildEmptyView(),
    );
  }


  // ─────────────────────────────────────────────────────────────────────────
  // État vide
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEmptyView() {
    return EmptyStateAnnouncements(onRefresh: _onRefresh);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Liste des annonces
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildListView() {
    final items = _filtered;

    return ListView(
      children: [
        // Hero "Restez informé"
        const AnnouncementsHeroHeader(),

        const SizedBox(height: 16),

        // Onglets de filtre
        AnnouncementsFilterTabs(
          selected: _activeFilter,
          onChanged: (cat) => setState(() => _activeFilter = cat),
        ),

        const SizedBox(height: 12),

        // Cartes
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                'Aucune annonce dans cette catégorie.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.gray3,
                ),
              ),
            ),
          )
        else
          ...items.map(
            (a) => AnnouncementCard(
              announcement: a,
              onTap: () => _openDetail(a),
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
