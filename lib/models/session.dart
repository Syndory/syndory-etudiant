enum AttendanceStatus { present, absent, justified }

class Session {
  final String title;
  final String type;
  final String professor;
  final String date;
  final String time;
  final String room;
  final String building;
  final AttendanceStatus status;
  final String? adminComment;
  final String notes;

  Session({
    required this.title,
    required this.type,
    required this.professor,
    required this.date,
    required this.time,
    required this.room,
    required this.building,
    required this.status,
    this.adminComment,
    required this.notes,
  });
}