import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appTheme.dart';
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
  int _viewIndex = 0;
  SubjectTag _selectedTag = SubjectTag.all;
  DateTime _weekStart = DateTime(2024, 10, 14);

  List<CourseModel> _allCourses = [];

  // Déclenché quand l'onglet calendar devient actif (IndexedStack passe navIndex=1)
  @override
  void didUpdateWidget(CalendarPage old) {
    super.didUpdateWidget(old);
    if (widget.navIndex == 1 && !_hasLoaded) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    // Remplacer par un appel API réel quand le backend sera disponible
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _allCourses = getMockData();
      _isLoading = false;
      _hasLoaded = true;
    });
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

  void _prevWeek() =>
      setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() =>
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppNavBarNoReturn(title: "Calendrier", onNotificationPressed: () {  },),
      body: _isLoading
          ? const CalendarLoadingSkeleton()
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF374151)),
        onPressed: () {},
      ),
      title: Text(
        'Calendrier',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: kOrange,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF374151)),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: kGreyLight,
            child: const Icon(Icons.person, color: kGrey, size: 20),
          ),
        ),
      ],
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
            onChanged: (i) => setState(() => _viewIndex = i),
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