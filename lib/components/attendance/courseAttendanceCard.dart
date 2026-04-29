import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/attendance/apptheme.dart';
import 'package:syndory_etudiant/models/periodModel.dart';

class CourseAttendanceCard extends StatefulWidget {
  final CourseAttendance course;

  const CourseAttendanceCard({super.key, required this.course});

  @override
  State<CourseAttendanceCard> createState() => _CourseAttendanceCardState();
}

class _CourseAttendanceCardState extends State<CourseAttendanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _widthAnimation = Tween<double>(begin: 0, end: widget.course.rate).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Seuils
  bool get _isCritical  => widget.course.rate < 0.70;  // < 70% → alerte
  bool get _isDanger    => widget.course.rate < 0.30;  // < 30% → danger (card en évidence)

  Color get _barColor {
    if (_isDanger)   return AppColors.danger;    // rouge vif
    if (_isCritical) return AppColors.orange;    // orange
    if (widget.course.rate >= 0.80) return AppColors.success; // vert
    return AppColors.warning;                    // jaune
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        // Fond rouge translucide si danger, fond card normal sinon
        color: _isDanger
            ? AppColors.danger.withOpacity(0.08)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        // Bordure : gauche rouge épaisse si danger, rien sinon
        border: _isDanger
            ? Border(
                left: BorderSide(color: AppColors.danger, width: 4),
              )
            : null,
        boxShadow: _isDanger
            ? [
                BoxShadow(
                  color: AppColors.danger.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header : nom + taux
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.course.name,
                      style: TextStyle(
                        // Texte rouge si danger
                        color: _isDanger
                            ? AppColors.danger
                            : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Icône ⚠️ si < 70%
                    if (_isCritical) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: _isDanger ? AppColors.danger : AppColors.warning,
                      ),
                    ],
                  ],
                ),
                Text(
                  '${(widget.course.rate * 100).round()}%',
                  style: TextStyle(
                    color: _barColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              widget.course.subtitle,
              style: TextStyle(
                color: _isDanger
                    ? AppColors.danger.withOpacity(0.7)
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            // Barre de progression animée
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    color: _isDanger
                        ? AppColors.danger.withOpacity(0.15)
                        : AppColors.progressBg,
                  ),
                  AnimatedBuilder(
                    animation: _widthAnimation,
                    builder: (context, _) {
                      return FractionallySizedBox(
                        widthFactor: _widthAnimation.value,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: _barColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Message d'alerte si < 70%
            if (_isCritical) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: _isDanger
                      ? AppColors.danger.withOpacity(0.10)
                      : AppColors.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isDanger
                        ? AppColors.danger.withOpacity(0.35)
                        : AppColors.warning.withOpacity(0.30),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: _isDanger ? AppColors.danger : AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.course.warningMessage!,
                        style: TextStyle(
                          color:
                              _isDanger ? AppColors.danger : AppColors.warning,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}