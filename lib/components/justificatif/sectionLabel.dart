import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';

class SectionLabel extends StatelessWidget {
  final String title;
  final Widget? action;

  const SectionLabel({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.gray3,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}