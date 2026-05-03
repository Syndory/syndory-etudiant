// lib/models/announcement_model.dart

enum AnnouncementCategory { administration, academique, bureauEtudiants, serviceIT }

class AnnouncementAttachment {
  final String filename;
  final String size;
  final bool isPdf;

  const AnnouncementAttachment({
    required this.filename,
    required this.size,
    required this.isPdf,
  });
}

class AnnouncementModel {
  final String id;
  final String source;           // "Administration", "Prof. Smith", …
  final AnnouncementCategory category;
  final String title;
  final String preview;          // texte tronqué affiché dans la liste
  final String date;             // "Il y a 3 jours", "2 Septembre 2024"…
  final bool isUnread;
  final bool isUrgent;
  final String? location;        // "Grand Hall, Campus Nord"
  final int? attachmentCount;
  final String readTime;         // "5 min read"
  final String body;             // contenu complet
  final String? quote;           // citation mise en valeur
  final String? authorName;
  final String? authorRole;
  final String? publishDate;     // "12 Octobre 2023"
  final String? publishTime;     // "14:30"
  final List<AnnouncementAttachment> attachments;

  const AnnouncementModel({
    required this.id,
    required this.source,
    required this.category,
    required this.title,
    required this.preview,
    required this.date,
    this.isUnread = false,
    this.isUrgent = false,
    this.location,
    this.attachmentCount,
    this.readTime = '3 min read',
    this.body = '',
    this.quote,
    this.authorName,
    this.authorRole,
    this.publishDate,
    this.publishTime,
    this.attachments = const [],
  });

  String get categoryLabel {
    switch (category) {
      case AnnouncementCategory.administration:
        return 'ADMINISTRATION';
      case AnnouncementCategory.academique:
        return 'ACADÉMIQUE';
      case AnnouncementCategory.bureauEtudiants:
        return 'BUREAU DES ÉTUDIANTS';
      case AnnouncementCategory.serviceIT:
        return 'SERVICE IT';
    }
  }
}
