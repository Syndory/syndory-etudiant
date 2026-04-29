import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_data.dart';
import 'calendar_widgets.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // 0 = Jour, 1 = Semaine, 2 = Mois
  int _viewIndex = 1;

  SubjectTag _selectedTag = SubjectTag.all;

  // Semaine courante : lundi de la semaine du 14 oct 2024
  DateTime _weekStart = DateTime(2024, 10, 14);

  int _bottomNavIndex = 1;

  final List<CourseModel> _allCourses = getMockData();

  // ── Helpers ──────────────────────────────────────────────────────────────

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

  // ── Actions ───────────────────────────────────────────────────────────────

  void _prevWeek() =>
      setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() =>
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopControls(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
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
          // Filtre masqué en vue mois (la navigation mois est dans le body)
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
    // Vue Jour : affiche seulement le premier jour de la semaine
    if (_viewIndex == 0) {
      return _buildDayList([_weekStart]);
    }
    // Vue Semaine
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const EmptyCourseCard(),
              )
            else
              ...courses.map((c) => CourseCard(course: c)),
            if (index < days.length - 1) const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (i) => setState(() => _bottomNavIndex = i),
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: kOrange,
      unselectedItemColor: kGrey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
