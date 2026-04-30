import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FiltreChipsBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final bool hasDropdown;

  const FiltreChipsBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.hasDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasDropdown) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(20), // pill-shape
              ),
              child: Row(
                children: const [
                  Text(
                    'Matière',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
          ...filters.map((filter) {
            final isActive = filter == selectedFilter;
            return GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.bgLight,
                  borderRadius: BorderRadius.circular(20), // pill-shape
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
