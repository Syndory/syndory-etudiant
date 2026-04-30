import 'package:flutter/material.dart';
import '../../models/session.dart';

class StatusBadge extends StatelessWidget {
  final AttendanceStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        text = "Présence enregistrée";
        icon = Icons.check_circle;
        break;
      case AttendanceStatus.absent:
        color = const Color(0xFFE67E22); // Orange Syndory
        text = "Absence observée";
        icon = Icons.error_outline;
        break;
      case AttendanceStatus.justified:
        color = const Color(0xFFE67E22);
        text = "Absence justifiée";
        icon = Icons.info_outline;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}