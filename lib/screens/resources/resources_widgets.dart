import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'resources_data.dart';

// ── Helper typographie ────────────────────────────────────────────────────────
TextStyle _p({
  double size = 14,
  FontWeight w = FontWeight.normal,
  Color c = const Color(0xFF111827),
  TextDecoration? deco,
}) => GoogleFonts.poppins(fontSize: size, fontWeight: w, color: c, decoration: deco);

// ── SubjectDropdown ───────────────────────────────────────────────────────────

class SubjectDropdown extends StatelessWidget {
  const SubjectDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final SubjectFilter value;
  final ValueChanged<SubjectFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kResBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubjectFilter>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: kResNavy),
          style: _p(size: 13, w: FontWeight.w500, c: kResNavy),
          onChanged: (v) { if (v != null) onChanged(v); },
          items: SubjectFilter.values
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.label),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── TypeFilterBar ─────────────────────────────────────────────────────────────

class TypeFilterBar extends StatelessWidget {
  const TypeFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ResourceType? selected; // null = tous
  final ValueChanged<ResourceType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final types = [null, ...ResourceType.values]; // null = "Tous"
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((t) {
          final active = t == selected;
          final label = t?.label ?? 'Tous';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? kResOrange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: active ? null : Border.all(color: kResBorder),
                ),
                child: Text(
                  label,
                  style: _p(
                    size: 13,
                    w: active ? FontWeight.w600 : FontWeight.normal,
                    c: active ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── SortButton ────────────────────────────────────────────────────────────────

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final SortMode current;
  final ValueChanged<SortMode> onChanged;

  static const _labels = {
    SortMode.date:    'Date',
    SortMode.matiere: 'Matière',
    SortMode.type:    'Type',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kResBorder),
        ),
        child: const Icon(Icons.sort_rounded, size: 20, color: kResNavy),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trier par',
                style: _p(size: 16, w: FontWeight.bold, c: kResNavy)),
            const SizedBox(height: 12),
            ...SortMode.values.map((m) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_labels[m]!, style: _p(size: 14)),
                  trailing: current == m
                      ? const Icon(Icons.check_rounded, color: kResOrange)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onChanged(m);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// ── ResourceCard ──────────────────────────────────────────────────────────────

class ResourceCard extends StatelessWidget {
  const ResourceCard({
    super.key,
    required this.resource,
    required this.downloadState,
    required this.onDownload,
    required this.onOpen,
    required this.onRetry,
  });

  final ResourceModel resource;
  final DownloadState downloadState;
  final VoidCallback onDownload;
  final VoidCallback onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FileIcon(fileType: resource.fileType),
                const SizedBox(width: 12),
                Expanded(child: _CardInfo(resource: resource)),
                const SizedBox(width: 8),
                _ActionButton(
                  state: downloadState,
                  onDownload: onDownload,
                  onOpen: onOpen,
                  onRetry: onRetry,
                ),
              ],
            ),
            if (downloadState.status == DownloadStatus.downloading) ...[
              const SizedBox(height: 10),
              _ProgressBar(progress: downloadState.progress),
            ],
          ],
        ),
      ),
    );
  }
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({required this.fileType});
  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: fileType.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(fileType.icon, color: fileType.color, size: 22),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.resource});
  final ResourceModel resource;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                resource.title,
                style: _p(size: 14, w: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (resource.isNew) ...[
              const SizedBox(width: 6),
              _NewBadge(),
            ],
          ],
        ),
        const SizedBox(height: 3),
        Text(
          resource.subject,
          style: _p(size: 12, c: kResOrange, w: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.person_outline_rounded, size: 12, color: kResGrey),
            const SizedBox(width: 3),
            Text(resource.professor, style: _p(size: 11, c: kResGrey)),
            const SizedBox(width: 8),
            Icon(Icons.calendar_today_outlined, size: 11, color: kResGrey),
            const SizedBox(width: 3),
            Text(_formatDate(resource.uploadDate),
                style: _p(size: 11, c: kResGrey)),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'juin',
      'juil', 'août', 'sep', 'oct', 'nov', 'déc'
    ];
    if (DateTime.now().difference(d).inHours < 48) return 'Récent';
    return '${d.day} ${months[d.month]}';
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: kResOrange,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('NOUVEAU', style: _p(size: 9, w: FontWeight.bold, c: Colors.white)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.state,
    required this.onDownload,
    required this.onOpen,
    required this.onRetry,
  });

  final DownloadState state;
  final VoidCallback onDownload;
  final VoidCallback onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case DownloadStatus.idle:
        return _iconBtn(
          icon: Icons.download_rounded,
          color: kResOrange,
          bg: kResOrangeLight,
          onTap: onDownload,
        );
      case DownloadStatus.downloading:
        return const SizedBox(
          width: 32,
          height: 32,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: kResOrange,
            ),
          ),
        );
      case DownloadStatus.done:
        return _iconBtn(
          icon: Icons.check_circle_rounded,
          color: kResGreen,
          bg: kResGreen.withValues(alpha: 0.1),
          onTap: onOpen,
          tooltip: 'Ouvrir',
        );
      case DownloadStatus.error:
        return _iconBtn(
          icon: Icons.refresh_rounded,
          color: kResRed,
          bg: kResRed.withValues(alpha: 0.1),
          onTap: onRetry,
          tooltip: 'Réessayer',
        );
    }
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: kResGreyLight,
            color: kResOrange,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}%',
          style: _p(size: 11, c: kResGrey),
        ),
      ],
    );
  }
}

// ── EmptyResourcesView ────────────────────────────────────────────────────────

class EmptyResourcesView extends StatelessWidget {
  const EmptyResourcesView({super.key, required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                    color: kResBorder, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.description_outlined,
                      size: 56, color: const Color(0xFFD1D5DB)),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: kResOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.workspace_premium_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Aucun document disponible',
                style: _p(size: 18, w: FontWeight.bold, c: kResNavy),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
              'Il n\'y a aucun document pédagogique pour le moment. Revenez plus tard ou contactez votre administration si cela semble être une erreur.',
              style: _p(size: 13, c: kResGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kResOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text('Rafraîchir la page',
                    style: _p(size: 14, w: FontWeight.w600, c: Colors.white)),
              ),
            ),
            const SizedBox(height: 28),
            _FeatureRow(
              icon: Icons.sync_rounded,
              title: 'Synchronisation automatique',
              desc: 'Vos documents sont mis à jour en temps réel dès leur publication par les professeurs.',
            ),
            const SizedBox(height: 16),
            _FeatureRow(
              icon: Icons.notifications_active_rounded,
              title: 'Alertes de publication',
              desc: 'Recevez une notification push dès qu\'une nouvelle ressource est ajoutée à votre cursus.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: kResOrangeLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kResOrange, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _p(size: 13, w: FontWeight.w600, c: kResNavy)),
              const SizedBox(height: 2),
              Text(desc, style: _p(size: 12, c: kResGrey)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── ResourcesLoadingSkeleton ──────────────────────────────────────────────────

class ResourcesLoadingSkeleton extends StatefulWidget {
  const ResourcesLoadingSkeleton({super.key});

  @override
  State<ResourcesLoadingSkeleton> createState() =>
      _ResourcesLoadingSkeletonState();
}

class _ResourcesLoadingSkeletonState extends State<ResourcesLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.75)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Column(
          children: [
            // Barre de filtres
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  Row(children: [
                    _box(width: 110, height: 34, radius: 20),
                    const SizedBox(width: 8),
                    _box(width: 70, height: 34, radius: 20),
                    const SizedBox(width: 8),
                    _box(width: 50, height: 34, radius: 20),
                    const SizedBox(width: 8),
                    _box(width: 50, height: 34, radius: 20),
                  ]),
                ],
              ),
            ),
            // Liste de cartes
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: 5,
                itemBuilder: (_, i) => _cardSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _box(width: 44, height: 44, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(height: 15, radius: 6),
                const SizedBox(height: 6),
                _box(width: 100, height: 12, radius: 5),
                const SizedBox(height: 5),
                _box(width: 160, height: 11, radius: 5),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _box(width: 36, height: 36, radius: 18),
        ],
      ),
    );
  }

  Widget _box({double? width, required double height, double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
