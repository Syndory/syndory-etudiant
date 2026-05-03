// lib/components/announcements/announcements_filter_tabs.dart

import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/models/announcement_model.dart';

/// null = "Toutes"
typedef CategoryFilter = AnnouncementCategory?;

class AnnouncementsFilterTabs extends StatelessWidget {
  final CategoryFilter selected;
  final ValueChanged<CategoryFilter> onChanged;

  const AnnouncementsFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = <_TabEntry>[
    _TabEntry(label: 'Toutes', value: null),
    _TabEntry(label: 'Administratif', value: AnnouncementCategory.administration),
    _TabEntry(label: 'Académique', value: AnnouncementCategory.academique),
    _TabEntry(label: 'Étudiants', value: AnnouncementCategory.bureauEtudiants),
    _TabEntry(label: 'Service IT', value: AnnouncementCategory.serviceIT),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tab = _tabs[i];
          final isActive = tab.value == selected;
          return GestureDetector(
            onTap: () => onChanged(tab.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.secondary.withOpacity(0.12)
                    : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? AppColors.secondary
                      : AppColors.gray4.withOpacity(0.6),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                  color:
                      isActive ? AppColors.secondary : AppColors.gray2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabEntry {
  final String label;
  final CategoryFilter value;
  const _TabEntry({required this.label, required this.value});
}
