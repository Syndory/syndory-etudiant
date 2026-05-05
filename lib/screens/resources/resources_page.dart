import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'resources_data.dart';
import 'resources_widgets.dart';

class ResourcesPage extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const ResourcesPage({
    super.key,
    required this.navIndex,
    this.onNavTap,
  });

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  bool _isLoading = true;
  bool _hasLoaded = false;

  List<ResourceModel> _allResources = [];
  SubjectFilter _subject = SubjectFilter.tous;
  ResourceType? _type; // null = tous
  SortMode _sort = SortMode.date;

  // Clé : resource.id
  final Map<String, DownloadState> _downloads = {};

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void didUpdateWidget(ResourcesPage old) {
    super.didUpdateWidget(old);
    // Déclenche le chargement quand l'onglet devient actif (IndexedStack)
    if (widget.navIndex == _navIndex && !_hasLoaded) {
      _loadData();
    }
  }

  // Index de cet onglet dans l'AppShell (défini dans main.dart)
  static const int _navIndex = 6;

  Future<void> _loadData() async {
    // Remplacer par un appel API réel quand le backend sera disponible
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _allResources = getMockResources();
      _isLoading = false;
      _hasLoaded = true;
    });
  }

  // ── Filtrage & tri ────────────────────────────────────────────────────────

  List<ResourceModel> get _filtered {
    var list = _allResources.where((r) {
      final subjectMatch =
          _subject == SubjectFilter.tous || r.subjectFilter == _subject;
      final typeMatch = _type == null || r.type == _type;
      return subjectMatch && typeMatch;
    }).toList();

    switch (_sort) {
      case SortMode.date:
        list.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      case SortMode.matiere:
        list.sort((a, b) => a.subject.compareTo(b.subject));
      case SortMode.type:
        list.sort((a, b) => a.type.index.compareTo(b.type.index));
    }
    return list;
  }

  // ── Téléchargement ────────────────────────────────────────────────────────

  DownloadState _stateOf(String id) =>
      _downloads[id] ?? const DownloadState(status: DownloadStatus.idle);

  Future<void> _startDownload(ResourceModel res) async {
    if (_stateOf(res.id).status == DownloadStatus.downloading) return;

    setState(() => _downloads[res.id] =
        const DownloadState(status: DownloadStatus.downloading));

    // Simulation de progression
    for (var i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      // Simulation d'une erreur aléatoire (1 chance sur 6)
      if (i == 5 && res.id == 'r3') {
        setState(() => _downloads[res.id] =
            const DownloadState(status: DownloadStatus.error));
        _showErrorToast(res.title);
        return;
      }
      setState(() => _downloads[res.id] =
          DownloadState(status: DownloadStatus.downloading, progress: i / 10));
    }

    setState(() =>
        _downloads[res.id] = const DownloadState(status: DownloadStatus.done));
  }

  void _openFile(ResourceModel res) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ouverture de "${res.title}"…',
          style: GoogleFonts.poppins(fontSize: 13)),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showErrorToast(String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Échec du téléchargement de "$title"',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: kResRed,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action: SnackBarAction(
        label: 'Réessayer',
        textColor: Colors.white,
        onPressed: () => _startDownload(
            _allResources.firstWhere((r) => r.title == title)),
      ),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const ResourcesLoadingSkeleton()
          : Column(
              children: [
                _buildFilterBar(),
                Expanded(child: _buildBody()),
              ],
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF374151), size: 20),
        onPressed: () => widget.onNavTap?.call(0),
      ),
      title: Text(
        'Ressources',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: kResNavy,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF3F4F6),
            child: const Icon(Icons.person, color: kResGrey, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          SubjectDropdown(
            value: _subject,
            onChanged: (v) => setState(() => _subject = v),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TypeFilterBar(
              selected: _type,
              onChanged: (v) => setState(() => _type = v),
            ),
          ),
          const SizedBox(width: 8),
          SortButton(
            current: _sort,
            onChanged: (v) => setState(() => _sort = v),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final resources = _filtered;
    if (resources.isEmpty) {
      return EmptyResourcesView(
        onRefresh: () {
          setState(() {
            _subject = SubjectFilter.tous;
            _type = null;
          });
        },
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: resources.length,
      itemBuilder: (context, i) {
        final res = resources[i];
        return ResourceCard(
          resource: res,
          downloadState: _stateOf(res.id),
          onDownload: () => _startDownload(res),
          onOpen: () => _openFile(res),
          onRetry: () => _startDownload(res),
        );
      },
    );
  }
}
