import 'package:flutter/material.dart';

// ── Couleurs locales ──────────────────────────────────────────────────────────
const kResNavy       = Color(0xFF1E3A5F);
const kResOrange     = Color(0xFFF97316);
const kResOrangeLight= Color(0xFFFFF3E0);
const kResGrey       = Color(0xFF9CA3AF);
const kResGreyLight  = Color(0xFFF3F4F6);
const kResBorder     = Color(0xFFE5E7EB);
const kResRed        = Color(0xFFEF4444);
const kResBlue       = Color(0xFF3B82F6);
const kResGreen      = Color(0xFF10B981);
const kResPurple     = Color(0xFF8B5CF6);

// ── Enums ─────────────────────────────────────────────────────────────────────
enum ResourceType { cours, td, tp, annonce, autre }

enum FileType { pdf, docx, pptx, image, other }

enum SubjectFilter { tous, maths, informatique, physique, langues, autre }

enum SortMode { date, matiere, type }

enum DownloadStatus { idle, downloading, done, error }

extension ResourceTypeLabel on ResourceType {
  String get label {
    switch (this) {
      case ResourceType.cours:   return 'Cours';
      case ResourceType.td:      return 'TD';
      case ResourceType.tp:      return 'TP';
      case ResourceType.annonce: return 'Annonce';
      case ResourceType.autre:   return 'Autre';
    }
  }
}

extension SubjectFilterLabel on SubjectFilter {
  String get label {
    switch (this) {
      case SubjectFilter.tous:         return 'Tous';
      case SubjectFilter.maths:        return 'Maths';
      case SubjectFilter.informatique: return 'Informatique';
      case SubjectFilter.physique:     return 'Physique';
      case SubjectFilter.langues:      return 'Langues';
      case SubjectFilter.autre:        return 'Autre';
    }
  }
}

extension FileTypeInfo on FileType {
  String get label {
    switch (this) {
      case FileType.pdf:   return 'PDF';
      case FileType.docx:  return 'DOCX';
      case FileType.pptx:  return 'PPTX';
      case FileType.image: return 'IMG';
      case FileType.other: return 'FILE';
    }
  }

  Color get color {
    switch (this) {
      case FileType.pdf:   return kResRed;
      case FileType.docx:  return kResBlue;
      case FileType.pptx:  return kResOrange;
      case FileType.image: return kResGreen;
      case FileType.other: return kResGrey;
    }
  }

  IconData get icon {
    switch (this) {
      case FileType.pdf:   return Icons.picture_as_pdf_rounded;
      case FileType.docx:  return Icons.description_rounded;
      case FileType.pptx:  return Icons.slideshow_rounded;
      case FileType.image: return Icons.image_rounded;
      case FileType.other: return Icons.insert_drive_file_rounded;
    }
  }
}

// ── Modèle ────────────────────────────────────────────────────────────────────
class ResourceModel {
  const ResourceModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.subjectFilter,
    required this.type,
    required this.fileType,
    required this.professor,
    required this.uploadDate,
    required this.fileSizeKb,
  });

  final String id;
  final String title;
  final String subject;
  final SubjectFilter subjectFilter;
  final ResourceType type;
  final FileType fileType;
  final String professor;
  final DateTime uploadDate;
  final int fileSizeKb;

  bool get isNew =>
      DateTime.now().difference(uploadDate).inHours < 48;

  String get fileSizeLabel {
    if (fileSizeKb >= 1024) {
      return '${(fileSizeKb / 1024).toStringAsFixed(1)} Mo';
    }
    return '$fileSizeKb Ko';
  }
}

// ── État de téléchargement ────────────────────────────────────────────────────
class DownloadState {
  const DownloadState({required this.status, this.progress = 0.0});
  final DownloadStatus status;
  final double progress; // 0.0 → 1.0
}

// ── Données mock ──────────────────────────────────────────────────────────────
List<ResourceModel> getMockResources() {
  final now = DateTime.now();
  return [
    ResourceModel(
      id: 'r1',
      title: 'Support de cours - Algorithmique Avancée',
      subject: 'Algorithmique Avancée',
      subjectFilter: SubjectFilter.informatique,
      type: ResourceType.cours,
      fileType: FileType.pdf,
      professor: 'Prof. Jean Dupont',
      uploadDate: now.subtract(const Duration(hours: 20)),
      fileSizeKb: 2340,
    ),
    ResourceModel(
      id: 'r2',
      title: 'Examen - Sessions 2023',
      subject: 'Théorie des Graphes',
      subjectFilter: SubjectFilter.informatique,
      type: ResourceType.annonce,
      fileType: FileType.pdf,
      professor: 'Prof. Marc Lepraud',
      uploadDate: DateTime(2024, 9, 2),
      fileSizeKb: 890,
    ),
    ResourceModel(
      id: 'r3',
      title: 'Énoncé TD3 - Optimisation',
      subject: 'Recherche Opérationnelle',
      subjectFilter: SubjectFilter.maths,
      type: ResourceType.td,
      fileType: FileType.docx,
      professor: 'Dr. Aïcha Traoré',
      uploadDate: DateTime(2024, 9, 29),
      fileSizeKb: 540,
    ),
    ResourceModel(
      id: 'r4',
      title: 'Assets Projet Final',
      subject: 'Design UI/UX',
      subjectFilter: SubjectFilter.autre,
      type: ResourceType.cours,
      fileType: FileType.image,
      professor: 'Sarah Martin',
      uploadDate: DateTime(2024, 9, 25),
      fileSizeKb: 8720,
    ),
    ResourceModel(
      id: 'r5',
      title: 'Cours 4 : Architecture Cloud',
      subject: 'Systèmes Distribués',
      subjectFilter: SubjectFilter.informatique,
      type: ResourceType.cours,
      fileType: FileType.pptx,
      professor: 'Prof. Jean Dupont',
      uploadDate: DateTime(2024, 9, 22),
      fileSizeKb: 4150,
    ),
    ResourceModel(
      id: 'r6',
      title: 'Assets Projet Final',
      subject: 'Design UI/UX',
      subjectFilter: SubjectFilter.autre,
      type: ResourceType.td,
      fileType: FileType.image,
      professor: 'Sarah Martin',
      uploadDate: DateTime(2024, 9, 23),
      fileSizeKb: 6300,
    ),
    ResourceModel(
      id: 'r7',
      title: 'TP3 - Programmation Fonctionnelle',
      subject: 'Algorithmique Avancée',
      subjectFilter: SubjectFilter.informatique,
      type: ResourceType.tp,
      fileType: FileType.docx,
      professor: 'Dr. Kofi Mensah',
      uploadDate: DateTime(2024, 9, 18),
      fileSizeKb: 320,
    ),
    ResourceModel(
      id: 'r8',
      title: 'Résumé - Analyse Numérique',
      subject: 'Analyse Numérique',
      subjectFilter: SubjectFilter.maths,
      type: ResourceType.cours,
      fileType: FileType.pdf,
      professor: 'Prof. Kofi Mensah',
      uploadDate: DateTime(2024, 9, 15),
      fileSizeKb: 1200,
    ),
  ];
}
