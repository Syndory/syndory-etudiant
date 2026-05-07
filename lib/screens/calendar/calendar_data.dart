import 'package:flutter/material.dart';

// ── Couleurs ──────────────────────────────────────────────────────────────────
const kOrange      = Color(0xFFF97316);
const kNavy        = Color(0xFF1E3A5F);
const kRed         = Color(0xFFEF4444);
const kRedLight    = Color(0xFFFEE2E2);
const kOrangeLight = Color(0xFFFFF3E0);
const kGrey        = Color(0xFF9CA3AF);
const kGreyLight   = Color(0xFFF3F4F6);
const kBorder      = Color(0xFFE5E7EB);
const kBlue        = Color(0xFF3B82F6);
const kAbsentBorder = Color(0xFFD1D5DB);

// ── Enums ─────────────────────────────────────────────────────────────────────
enum CourseType { normal, lab, exam, absent }

enum SubjectTag { all, maths, informatique, physique, langues }

extension SubjectTagLabel on SubjectTag {
  String get label {
    switch (this) {
      case SubjectTag.all:
        return 'Tous';
      case SubjectTag.maths:
        return 'Maths';
      case SubjectTag.informatique:
        return 'Informatique';
      case SubjectTag.physique:
        return 'Physique';
      case SubjectTag.langues:
        return 'Langues';
    }
  }
}

// ── Modèle ────────────────────────────────────────────────────────────────────
class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.professor,
    required this.type,
    required this.tag,
    required this.date,
    this.hasUpdate = false,
  });

  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final String room;
  final String professor;
  final CourseType type;
  final SubjectTag tag;
  final bool hasUpdate;
  final DateTime date;

  String get timeRange => '$startTime – $endTime';

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final matiere = json['matieres'] as Map<String, dynamic>? ?? {};
    final user    = json['users']    as Map<String, dynamic>? ?? {};
    final salle   = json['salles']   as Map<String, dynamic>? ?? {};

    final matiereName = matiere['name'] as String? ?? 'Cours';
    final matiereCode = matiere['code'] as String?;
    final isExam      = json['is_exam'] as bool? ?? false;
    final seanceType  = json['type']    as String? ?? 'cours';

    final firstName = user['first_name'] as String? ?? '';
    final lastName  = user['last_name']  as String? ?? '';
    final profName  = '$firstName $lastName'.trim();

    return CourseModel(
      id:         json['id']   as String? ?? '',
      title:      matiereName,
      startTime:  _trimTime(json['start_time'] as String?),
      endTime:    _trimTime(json['end_time']   as String?),
      room:       salle['name'] as String? ?? 'Salle inconnue',
      professor:  profName.isEmpty ? 'Professeur' : 'Prof. $profName',
      type:       _courseType(seanceType, isExam),
      tag:        _subjectTag(matiereName, matiereCode),
      date:       DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static String _trimTime(String? t) {
    if (t == null || t.isEmpty) return '--:--';
    return t.length >= 5 ? t.substring(0, 5) : t;
  }

  static CourseType _courseType(String type, bool isExam) {
    if (isExam || type == 'examen') return CourseType.exam;
    if (type == 'tp') return CourseType.lab;
    return CourseType.normal;
  }

  static SubjectTag _subjectTag(String name, String? code) {
    final n = name.toLowerCase();
    if (n.contains('math') || n.contains('analyse') || n.contains('algèbre') ||
        n.contains('calcul') || n.contains('statistique')) {
      return SubjectTag.maths;
    }
    if (n.contains('info') || n.contains('algo') || n.contains('programm') ||
        n.contains('base de données') || n.contains('réseau') ||
        n.contains('logiciel') || n.contains('système')) {
      return SubjectTag.informatique;
    }
    if (n.contains('physique') || n.contains('chimie') ||
        n.contains('biologie') || n.contains('électronique')) {
      return SubjectTag.physique;
    }
    if (n.contains('anglais') || n.contains('français') ||
        n.contains('langue') || n.contains('expression')) {
      return SubjectTag.langues;
    }
    return SubjectTag.all;
  }
}

// ── Données mock ──────────────────────────────────────────────────────────────
List<CourseModel> getMockData() {
  return [
    // Lundi 14 Oct
    CourseModel(
      id: '1',
      title: 'Mathématiques Discrètes',
      startTime: '08:30',
      endTime: '10:30',
      room: 'Amphi B – Bâtiment Curie',
      professor: 'Prof. Jean Dupont',
      type: CourseType.normal,
      tag: SubjectTag.maths,
      hasUpdate: true,
      date: DateTime(2024, 10, 14),
    ),
    CourseModel(
      id: '2',
      title: 'Algorithmique Avancée',
      startTime: '11:00',
      endTime: '13:00',
      room: 'Salle 302 – Lab Info',
      professor: 'Prof. Sarah Martin',
      type: CourseType.lab,
      tag: SubjectTag.informatique,
      date: DateTime(2024, 10, 14),
    ),
    // Mardi 15 Oct
    CourseModel(
      id: '3',
      title: 'Physique Quantique',
      startTime: '14:00',
      endTime: '16:00',
      room: 'Hall Principal',
      professor: 'Dr. Marc Leroy',
      type: CourseType.exam,
      tag: SubjectTag.physique,
      date: DateTime(2024, 10, 15),
    ),
    CourseModel(
      id: '4',
      title: 'Anglais Technique',
      startTime: '16:30',
      endTime: '18:30',
      room: 'Salle 104',
      professor: 'Mme. Clara Wilson',
      type: CourseType.absent,
      tag: SubjectTag.langues,
      date: DateTime(2024, 10, 15),
    ),
    // Mercredi 16 Oct : aucun cours
    // Jeudi 17 Oct
    CourseModel(
      id: '5',
      title: 'Algorithmique Avancée',
      startTime: '08:00',
      endTime: '10:00',
      room: 'Salle 302',
      professor: 'Prof. Sarah Martin',
      type: CourseType.normal,
      tag: SubjectTag.informatique,
      date: DateTime(2024, 10, 17),
    ),
    CourseModel(
      id: '6',
      title: 'Analyse Numérique',
      startTime: '10:30',
      endTime: '12:30',
      room: 'Amphi A',
      professor: 'Prof. Kofi Mensah',
      type: CourseType.normal,
      tag: SubjectTag.maths,
      date: DateTime(2024, 10, 17),
    ),
    // Vendredi 18 Oct
    CourseModel(
      id: '7',
      title: 'Base de Données',
      startTime: '09:00',
      endTime: '11:00',
      room: 'Salle 205',
      professor: 'Dr. Aïcha Traoré',
      type: CourseType.lab,
      tag: SubjectTag.informatique,
      date: DateTime(2024, 10, 18),
    ),
    CourseModel(
      id: '8',
      title: 'Physique Appliquée',
      startTime: '14:00',
      endTime: '16:00',
      room: 'Labo Physique',
      professor: 'Dr. Marc Leroy',
      type: CourseType.normal,
      tag: SubjectTag.physique,
      hasUpdate: true,
      date: DateTime(2024, 10, 18),
    ),
  ];
}
