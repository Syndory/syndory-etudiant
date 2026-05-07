import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/announcements/empty_state_announcements.dart';
import 'package:syndory_etudiant/components/announcements/announcements_hero_header.dart';
import 'package:syndory_etudiant/components/announcements/announcements_filter_tabs.dart';
import 'package:syndory_etudiant/components/announcements/announcement_card.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';
import 'package:syndory_etudiant/providers/announcement_provider.dart';
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
  AnnouncementCategory? _activeFilter;

  @override
  void initState() {
    super.initState();
    // Charger les annonces au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().loadAnnouncements();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<AnnouncementProvider>().loadAnnouncements();
  }

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
      appBar: AppNavBarNoReturn(title: "Annonce"),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
      body: Consumer<AnnouncementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.announcements.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
          }

          if (provider.errorMessage != null && provider.announcements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.gray2),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }

          if (provider.announcements.isEmpty) {
            return _buildEmptyView();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.secondary,
            child: _buildListView(provider),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return EmptyStateAnnouncements(onRefresh: _onRefresh);
  }

  Widget _buildListView(AnnouncementProvider provider) {
    final items = provider.getFilteredAnnouncements(_activeFilter);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const AnnouncementsHeroHeader(),
        const SizedBox(height: 16),
        AnnouncementsFilterTabs(
          selected: _activeFilter,
          onChanged: (cat) => setState(() => _activeFilter = cat),
        ),
        const SizedBox(height: 12),
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
