import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/services/calendar_service.dart';
import 'calendar_data.dart';
import 'calendar_widgets.dart';

class CalendarPage extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const CalendarPage({
    super.key,
    this.navIndex = 1, // ✅ index calendrier
    this.onNavTap,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _isLoading = true;
  bool _hasLoaded = false;
  String? _error;
  int _viewIndex = 0;
  SubjectTag _selectedTag = SubjectTag.all;
  late DateTime _weekStart;
  late DateTime _monthStart;

  List<CourseModel> _allCourses = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart  = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    _monthStart = DateTime(now.year, now.month, 1);
    if (widget.navIndex == 1) _loadData();
  }

  @override
  void didUpdateWidget(CalendarPage old) {
    super.didUpdateWidget(old);
    if (widget.navIndex == 1 && !_hasLoaded) _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final DateTime from, to;
      if (_viewIndex == 2) {
        from = _monthStart;
        to   = DateTime(_monthStart.year, _monthStart.month + 1, 0);
      } else {
        from = _weekStart;
        to   = _weekStart.add(const Duration(days: 6));
      }
      final courses = await CalendarService.instance.fetchSeances(from: from, to: to);
      if (!mounted) return;
      setState(() {
        _allCourses = courses;
        _isLoading  = false;
        _hasLoaded  = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error     = "Impossible de charger l'emploi du temps.";
      });
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  List<CourseModel> _coursesForDay(DateTime day) {
    return _allCourses.where((c) {
      final sameDay = c.date.year == day.year &&
          c.date.month == day.month &&
          c.date.day == day.day;
      final tagMatch =
          _selectedTag == SubjectTag.all || c.tag == _selectedTag;
      return sameDay && tagMatch;
    }).toList();
  }

  static const _frMonths = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];
  static const _frMonthsShort = [
    '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc',
  ];
  static const _frDays = [
    '', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche',
  ];

  String get _weekLabel {
    final end = _weekStart.add(const Duration(days: 6));
    if (_weekStart.month == end.month) {
      return '${_weekStart.day} – ${end.day} ${_frMonths[end.month]} ${end.year}';
    }
    return '${_weekStart.day} ${_frMonthsShort[_weekStart.month]} – ${end.day} ${_frMonthsShort[end.month]} ${end.year}';
  }

  String _dayLabel(DateTime date) {
    return '${_frDays[date.weekday]} ${date.day} ${_frMonthsShort[date.month]}';
  }

  void _prevWeek() {
    setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
    _loadData();
  }

  void _nextWeek() {
    setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
    _loadData();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: "Calendrier"),
      body: _isLoading
          ? const CalendarLoadingSkeleton()
          : _error != null
              ? _buildError()
              : Column(
                  children: [
                    _buildTopControls(),
                    Expanded(child: _buildBody()),
                  ],
                ),
      // ✅ Remplace le BottomNavigationBar hardcodé par le composant partagé
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: kGrey),
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: kGrey)),
          const SizedBox(height: 16),
          TextButton(onPressed: _loadData, child: const Text('Réessayer')),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          ViewToggle(
            selected: _viewIndex,
            onChanged: (i) {
              setState(() => _viewIndex = i);
              _loadData();
            },
          ),
          if (_viewIndex == 1) ...[
            const SizedBox(height: 12),
            WeekNavigator(
              label: _weekLabel,
              onPrev: _prevWeek,
              onNext: _nextWeek,
            ),
          ],
          if (_viewIndex == 2) const SizedBox(height: 4),
          const SizedBox(height: 12),
          SubjectFilterBar(
            selected: _selectedTag,
            onChanged: (t) => setState(() => _selectedTag = t),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_viewIndex == 2) {
      return MonthCalendarView(
        allCourses: _allCourses,
        selectedTag: _selectedTag,
      );
    }
    if (_viewIndex == 0) {
      return _buildDayList([_weekStart]);
    }
    return _buildDayList(_weekDays);
  }

  Widget _buildDayList(List<DateTime> days) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final courses = _coursesForDay(day);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DayHeader(label: _dayLabel(day)),
            if (courses.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: EmptyCourseCard(),
              )
            else
              ...courses.map((c) => CourseCard(course: c)),
            if (index < days.length - 1) const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}