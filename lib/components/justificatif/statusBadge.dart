import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';

class StatusBadge extends StatelessWidget {
  final JustificatifStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _bg {
    switch (status) {
      case JustificatifStatus.valide:
        return AppColors.success.withOpacity(0.12);
      case JustificatifStatus.rejete:
        return AppColors.danger.withOpacity(0.12);
      case JustificatifStatus.enAttente:
        return AppColors.warning.withOpacity(0.12);
    }
  }

  Color get _fg {
    switch (status) {
      case JustificatifStatus.valide:
        return AppColors.success;
      case JustificatifStatus.rejete:
        return AppColors.danger;
      case JustificatifStatus.enAttente:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Inter',
          color: _fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}