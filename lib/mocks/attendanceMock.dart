
import 'package:syndory_etudiant/models/periodModel.dart';

final Map<AttendancePeriod, AttendanceSnapshot> mockData = {
  // ── SEMAINE ────────────────────────────────────────────────────────────────
  AttendancePeriod.semaine: const AttendanceSnapshot(
    globalRate: 0.92,
    courses: [
      CourseAttendance(
        name: 'Algorithmique',
        subtitle: '2/2 séances',
        rate: 1.0,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Mathématiques',
        subtitle: '1/2 séances',
        rate: 0.50,
        status: AttendanceStatus.warning,
        warningMessage: 'Vous avez manqué 1 séance cette semaine.',
      ),
      CourseAttendance(
        name: 'Architecture',
        subtitle: '1/1 séance',
        rate: 1.0,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Anglais Technique',
        subtitle: '1/1 séance',
        rate: 1.0,
        status: AttendanceStatus.good,
      ),
    ],
    history: [
      HistoryEntry(
        courseName: 'Algorithmique',
        date: 'Lun 25 Nov, 08:30',
        status: HistoryStatus.present,
        iconPath: 'Al',
      ),
      HistoryEntry(
        courseName: 'Mathématiques',
        date: 'Lun 25 Nov, 10:00',
        status: HistoryStatus.absent,
        iconPath: 'Ma',
      ),
      HistoryEntry(
        courseName: 'Architecture',
        date: 'Mar 26 Nov, 08:30',
        status: HistoryStatus.present,
        iconPath: 'Ar',
      ),
      HistoryEntry(
        courseName: 'Algorithmique',
        date: 'Mer 27 Nov, 08:30',
        status: HistoryStatus.present,
        iconPath: 'Al',
      ),
      HistoryEntry(
        courseName: 'Anglais Technique',
        date: 'Jeu 28 Nov, 14:00',
        status: HistoryStatus.present,
        iconPath: 'AT',
      ),
    ],
  ),

  // ── MOIS ───────────────────────────────────────────────────────────────────
  AttendancePeriod.mois: const AttendanceSnapshot(
    globalRate: 0.75,
    courses: [
      CourseAttendance(
        name: 'Algorithmique',
        subtitle: '7/8 séances',
        rate: 0.875,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Mathématiques',
        subtitle: '4/8 séances',
        rate: 0.50,
        status: AttendanceStatus.warning,
        warningMessage: 'Votre taux d\'absence dépasse le seuil autorisé (70%).',
      ),
      CourseAttendance(
        name: 'Architecture',
        subtitle: '3/5 séances',
        rate: 0.60,
        status: AttendanceStatus.warning,
        warningMessage: 'Votre taux d\'absence dépasse le seuil autorisé (70%).',
      ),
      CourseAttendance(
        name: 'Anglais Technique',
        subtitle: '3/4 séances',
        rate: 0.75,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Base de données',
        subtitle: '2/4 séances',
        rate: 0.20,
        status: AttendanceStatus.critical,
        warningMessage: 'Risque d\'exclusion si la tendance se poursuit.',
      ),
    ],
    history: [
      HistoryEntry(
        courseName: 'Base de données',
        date: '20 Nov, 13:30',
        status: HistoryStatus.absent,
        iconPath: 'BD',
      ),
      HistoryEntry(
        courseName: 'Algorithmique',
        date: '18 Nov, 08:30',
        status: HistoryStatus.present,
        iconPath: 'Al',
      ),
      HistoryEntry(
        courseName: 'Mathématiques',
        date: '15 Nov, 10:00',
        status: HistoryStatus.absent,
        iconPath: 'Ma',
      ),
      HistoryEntry(
        courseName: 'Architecture',
        date: '13 Nov, 08:30',
        status: HistoryStatus.retard,
        iconPath: 'Ar',
      ),
      HistoryEntry(
        courseName: 'Anglais Technique',
        date: '12 Nov, 14:00',
        status: HistoryStatus.present,
        iconPath: 'AT',
      ),
      HistoryEntry(
        courseName: 'Mathématiques',
        date: '08 Nov, 10:00',
        status: HistoryStatus.absent,
        iconPath: 'Ma',
      ),
    ],
  ),

  // ── SEMESTRE ───────────────────────────────────────────────────────────────
  AttendancePeriod.semestre: const AttendanceSnapshot(
    globalRate: 0.88,
    courses: [
      CourseAttendance(
        name: 'Algorithmique',
        subtitle: '12/14 séances',
        rate: 0.857,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Mathématiques',
        subtitle: '6/14 séances',
        rate: 0.43,
        status: AttendanceStatus.warning,
        warningMessage: 'Votre taux d\'absence dépasse le seuil autorisé (30%).',
      ),
      CourseAttendance(
        name: 'Architecture',
        subtitle: '5/9 séances',
        rate: 0.56,
        status: AttendanceStatus.critical,
        warningMessage: 'Risque d\'exclusion du module si la tendance continue.',
      ),
      CourseAttendance(
        name: 'Anglais Technique',
        subtitle: '10/11 séances',
        rate: 0.91,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Base de données',
        subtitle: '8/10 séances',
        rate: 0.80,
        status: AttendanceStatus.good,
      ),
      CourseAttendance(
        name: 'Réseaux',
        subtitle: '4/7 séances',
        rate: 0.57,
        status: AttendanceStatus.warning,
        warningMessage: 'Taux de présence insuffisant, rattrapez les absences.',
      ),
    ],
    history: [
      HistoryEntry(
        courseName: 'Algorithmique',
        date: '25 Nov, 08:30',
        status: HistoryStatus.present,
        iconPath: 'Al',
      ),
      HistoryEntry(
        courseName: 'Mathématiques',
        date: '22 Nov, 10:00',
        status: HistoryStatus.absent,
        iconPath: 'Ma',
      ),
      HistoryEntry(
        courseName: 'Anglais Technique',
        date: '20 Nov, 14:00',
        status: HistoryStatus.ajour,
        iconPath: 'AT',
      ),
      HistoryEntry(
        courseName: 'Architecture',
        date: '18 Nov, 08:30',
        status: HistoryStatus.retard,
        iconPath: 'Ar',
      ),
      HistoryEntry(
        courseName: 'Réseaux',
        date: '15 Nov, 13:30',
        status: HistoryStatus.absent,
        iconPath: 'Re',
      ),
      HistoryEntry(
        courseName: 'Base de données',
        date: '13 Nov, 10:00',
        status: HistoryStatus.present,
        iconPath: 'BD',
      ),
    ],
  ),
};