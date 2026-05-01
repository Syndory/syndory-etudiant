import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syndory_etudiant/screens/matieres/matiere_detail_screen.dart';
import 'calendar_data.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

TextStyle _poppins({
  double size = 14,
  FontWeight weight = FontWeight.normal,
  Color color = const Color(0xFF111827),
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    color: color,
    decoration: decoration,
    decorationColor: decorationColor,
  );
}

Color _borderColor(CourseType type) {
  switch (type) {
    case CourseType.normal:
      return kOrange;
    case CourseType.lab:
      return kBlue;
    case CourseType.exam:
      return kRed;
    case CourseType.absent:
      return kAbsentBorder;
  }
}

// ── ViewToggle ────────────────────────────────────────────────────────────────

class ViewToggle extends StatelessWidget {
  const ViewToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  static const _labels = ['Jour', 'Semaine', 'Mois'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: _poppins(
                    size: 13,
                    weight: active ? FontWeight.w600 : FontWeight.normal,
                    color: active ? kOrange : kGrey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── WeekNavigator ─────────────────────────────────────────────────────────────

class WeekNavigator extends StatelessWidget {
  const WeekNavigator({
    super.key,
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left, color: kOrange, size: 28),
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Text(
          label,
          style: _poppins(size: 16, weight: FontWeight.bold, color: kNavy),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, color: kOrange, size: 28),
          splashRadius: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}

// ── SubjectFilterBar ──────────────────────────────────────────────────────────

class SubjectFilterBar extends StatelessWidget {
  const SubjectFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final SubjectTag selected;
  final ValueChanged<SubjectTag> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SubjectTag.values.map((tag) {
          final active = tag == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? kOrange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: active
                      ? null
                      : Border.all(color: kBorder),
                ),
                child: Text(
                  tag.label,
                  style: _poppins(
                    size: 13,
                    weight: active ? FontWeight.w600 : FontWeight.normal,
                    color: active ? Colors.white : const Color(0xFF374151),
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

// ── DayHeader ─────────────────────────────────────────────────────────────────

class DayHeader extends StatelessWidget {
  const DayHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: _poppins(size: 18, weight: FontWeight.bold, color: kNavy),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: kBorder, thickness: 1)),
        ],
      ),
    );
  }
}

// ── EmptyCourseCard ───────────────────────────────────────────────────────────

class EmptyCourseCard extends StatelessWidget {
  const EmptyCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 40, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 8),
          Text(
            'Aucun cours prévu pour cette journée',
            textAlign: TextAlign.center,
            style: _poppins(size: 14, color: kGrey),
          ),
        ],
      ),
    );
  }
}

// ── _TimeChip (interne) ───────────────────────────────────────────────────────

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.isExam});

  final String label;
  final bool isExam;

  @override
  Widget build(BuildContext context) {
    if (isExam) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kRedLight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: _poppins(size: 13, weight: FontWeight.w600, color: kRed),
        ),
      );
    }
    return Text(label, style: _poppins(size: 13, color: kGrey));
  }
}

// ── _Badge (interne) ──────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge.update()
      : _type = _BadgeType.update;
  const _Badge.exam()
      : _type = _BadgeType.exam;
  const _Badge.absent()
      : _type = _BadgeType.absent;

  final _BadgeType _type;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _BadgeType.update:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kOrangeLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'MIS À JOUR',
            style: _poppins(size: 11, weight: FontWeight.w600, color: kOrange),
          ),
        );
      case _BadgeType.exam:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kRed,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.description, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                'EXAMEN',
                style: _poppins(
                    size: 11, weight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        );
      case _BadgeType.absent:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: kRed),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Absent',
            style: _poppins(size: 11, color: kRed),
          ),
        );
    }
  }
}

enum _BadgeType { update, exam, absent }

// ── CourseCard ────────────────────────────────────────────────────────────────

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final isAbsent = course.type == CourseType.absent;
    final isExam   = course.type == CourseType.exam;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatiereDetailScreen(
              nom: course.title,
              prof: course.professor,
              assiduite: 0.85,
              progression: 0.92,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
        color: isExam
            ? kRedLight
            : isAbsent
                ? kGreyLight
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: _borderColor(course.type), width: 4),
        ),
        boxShadow: isAbsent || isExam
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horaire + badge
            Row(
              children: [
                _TimeChip(label: course.timeRange, isExam: isExam),
                const Spacer(),
                if (isExam)
                  const _Badge.exam()
                else if (course.type == CourseType.absent)
                  const _Badge.absent()
                else if (course.hasUpdate)
                  const _Badge.update(),
              ],
            ),
            const SizedBox(height: 8),
            // Titre
            Text(
              course.title,
              style: _poppins(
                size: 16,
                weight: FontWeight.bold,
                color: isAbsent ? kGrey : const Color(0xFF111827),
                decoration:
                    isAbsent ? TextDecoration.lineThrough : null,
                decorationColor: isAbsent ? kGrey : null,
              ),
            ),
            const SizedBox(height: 8),
            // Salle
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: isAbsent ? kGrey : kGrey),
                const SizedBox(width: 4),
                Text(
                  course.room,
                  style: _poppins(size: 13, color: kGrey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Professeur
            Row(
              children: [
                Icon(Icons.person, size: 14, color: isAbsent ? kGrey : kGrey),
                const SizedBox(width: 4),
                Text(
                  course.professor,
                  style: _poppins(size: 13, color: kGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}

// ── MonthCalendarView ─────────────────────────────────────────────────────────

class MonthCalendarView extends StatefulWidget {
  const MonthCalendarView({
    super.key,
    required this.allCourses,
    required this.selectedTag,
  });

  final List<CourseModel> allCourses;
  final SubjectTag selectedTag;

  @override
  State<MonthCalendarView> createState() => _MonthCalendarViewState();
}

class _MonthCalendarViewState extends State<MonthCalendarView> {
  DateTime _monthStart = DateTime(2024, 10, 1);
  DateTime _selectedDay = DateTime(2024, 10, 14);

  static const _dayHeaders = ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];

  static const _frMonths = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  static const _frDays = [
    '', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche',
  ];

  List<CourseModel> _coursesForDay(DateTime day) {
    return widget.allCourses.where((c) {
      final same = c.date.year == day.year &&
          c.date.month == day.month &&
          c.date.day == day.day;
      final tag = widget.selectedTag == SubjectTag.all || c.tag == widget.selectedTag;
      return same && tag;
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String get _monthLabel =>
      '${_frMonths[_monthStart.month]} ${_monthStart.year}';

  String get _selectedLabel {
    final d = _selectedDay;
    return '${_frDays[d.weekday]} ${d.day} ${_frMonths[d.month]} ${d.year}';
  }

  List<_CalCell> get _cells {
    final first = DateTime(_monthStart.year, _monthStart.month, 1);
    final daysInMonth =
        DateTime(_monthStart.year, _monthStart.month + 1, 0).day;
    final daysInPrev =
        DateTime(_monthStart.year, _monthStart.month, 0).day;
    final offset = first.weekday - 1; // 0 = lundi

    final cells = <_CalCell>[];
    // Jours du mois précédent
    for (var i = offset - 1; i >= 0; i--) {
      cells.add(_CalCell(
        date: DateTime(_monthStart.year, _monthStart.month - 1, daysInPrev - i),
        current: false,
      ));
    }
    // Jours du mois courant
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(_CalCell(
        date: DateTime(_monthStart.year, _monthStart.month, d),
        current: true,
      ));
    }
    // Compléter jusqu'à 42 cellules
    var next = 1;
    while (cells.length < 42) {
      cells.add(_CalCell(
        date: DateTime(_monthStart.year, _monthStart.month + 1, next++),
        current: false,
      ));
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _cells;
    final courses = _coursesForDay(_selectedDay);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation mois
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => setState(() => _monthStart =
                    DateTime(_monthStart.year, _monthStart.month - 1, 1)),
                icon: const Icon(Icons.chevron_left, color: kOrange, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Text(
                _monthLabel,
                style: _poppins(size: 16, weight: FontWeight.bold, color: kNavy),
              ),
              IconButton(
                onPressed: () => setState(() => _monthStart =
                    DateTime(_monthStart.year, _monthStart.month + 1, 1)),
                icon: const Icon(Icons.chevron_right, color: kOrange, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Grille
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
            child: Column(
              children: [
                // En-têtes jours
                Row(
                  children: _dayHeaders
                      .map((h) => Expanded(
                            child: Center(
                              child: Text(
                                h,
                                style: _poppins(
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: kGrey,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 6),
                // Grille 6 × 7
                ...List.generate(6, (row) {
                  return Row(
                    children: List.generate(7, (col) {
                      final cell = cells[row * 7 + col];
                      return Expanded(child: _buildCell(cell));
                    }),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Titre séances
          Text(
            'Séances du $_selectedLabel',
            style: _poppins(size: 15, weight: FontWeight.bold, color: kNavy),
          ),
          const SizedBox(height: 12),
          if (courses.isEmpty)
            const EmptyCourseCard()
          else
            ...courses.map((c) => CourseCard(course: c)),
        ],
      ),
    );
  }

  Widget _buildCell(_CalCell cell) {
    final isSelected = _isSameDay(cell.date, _selectedDay);
    final count = cell.current ? _coursesForDay(cell.date).length : 0;

    return GestureDetector(
      onTap: cell.current
          ? () => setState(() => _selectedDay = cell.date)
          : null,
      child: SizedBox(
        height: 46,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? kOrange : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${cell.date.day}',
                style: _poppins(
                  size: 13,
                  weight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : !cell.current
                          ? const Color(0xFFD1D5DB)
                          : kNavy,
                ),
              ),
            ),
            if (count > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    count.clamp(1, 2),
                    (_) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : kOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _CalCell {
  const _CalCell({required this.date, required this.current});
  final DateTime date;
  final bool current;
}

// ── CalendarLoadingSkeleton ───────────────────────────────────────────────────

class CalendarLoadingSkeleton extends StatefulWidget {
  const CalendarLoadingSkeleton({super.key});

  @override
  State<CalendarLoadingSkeleton> createState() =>
      _CalendarLoadingSkeletonState();
}

class _CalendarLoadingSkeletonState extends State<CalendarLoadingSkeleton>
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
    _opacity = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
      builder: (_, child) => Column(
        children: [
          // Top controls skeleton (fond blanc, même hauteur que la vraie zone)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Opacity(
              opacity: _opacity.value,
              child: Column(
                children: [
                  // Toggle
                  _box(height: 40, radius: 12),
                  const SizedBox(height: 12),
                  // Navigateur semaine
                  Row(
                    children: [
                      _box(width: 28, height: 28, radius: 8),
                      const SizedBox(width: 16),
                      Expanded(child: _box(height: 18, radius: 6)),
                      const SizedBox(width: 16),
                      _box(width: 28, height: 28, radius: 8),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filtres chips
                  Row(
                    children: [56.0, 68.0, 90.0, 72.0].map((w) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _box(width: w, height: 36, radius: 20),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          // Corps skeleton
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Opacity(
                opacity: _opacity.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _daySection(cardCount: 2),
                    const SizedBox(height: 20),
                    _daySection(cardCount: 2),
                    const SizedBox(height: 20),
                    _daySection(cardCount: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _daySection({required int cardCount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête jour
        Row(
          children: [
            _box(width: 130, height: 18, radius: 6),
            const SizedBox(width: 10),
            Expanded(child: _box(height: 1, radius: 1)),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(cardCount, (_) => _courseCardSkeleton()),
      ],
    );
  }

  Widget _courseCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFFE5E7EB), width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _box(width: 110, height: 16, radius: 6),
            const Spacer(),
            _box(width: 72, height: 24, radius: 6),
          ]),
          const SizedBox(height: 10),
          _box(height: 18, radius: 6),
          const SizedBox(height: 8),
          _box(width: 170, height: 13, radius: 5),
          const SizedBox(height: 6),
          _box(width: 140, height: 13, radius: 5),
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
