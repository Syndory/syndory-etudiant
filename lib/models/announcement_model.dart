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
  final String source; // "Administration", "Prof. Smith", …
  final AnnouncementCategory category;
  final String title;
  final String preview; // texte tronqué affiché dans la liste
  final String date; // "Il y a 3 jours", "2 Septembre 2024"…
  final bool isUnread;
  final bool isUrgent;
  final String? location; // "Grand Hall, Campus Nord"
  final int? attachmentCount;
  final String readTime; // "5 min read"
  final String body; // contenu complet
  final String? quote; // citation mise en valeur
  final String? authorName;
  final String? authorRole;
  final String? publishDate; // "12 Octobre 2023"
  final String? publishTime; // "14:30"
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

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    // 1. Extraire les infos de l'auteur depuis la jointure users!published_by
    final author = json['users'] as Map<String, dynamic>?;
    final String roleStr = author?['role'] ?? 'admin';
    final String firstName = author?['first_name'] ?? '';
    final String lastName = author?['last_name'] ?? '';
    final String fullName = "$firstName $lastName".trim();

    // 2. Mapper le rôle vers une catégorie UI
    AnnouncementCategory category;
    String authorRoleLabel = "Administration";
    
    switch (roleStr) {
      case 'professor':
        category = AnnouncementCategory.academique;
        authorRoleLabel = "Professeur";
        break;
      case 'class_representative':
        category = AnnouncementCategory.bureauEtudiants;
        authorRoleLabel = "Délégué de classe";
        break;
      case 'admin':
      default:
        category = AnnouncementCategory.administration;
        authorRoleLabel = "Administration";
        break;
    }

    // 3. Formater la date
    final createdAt = DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now();
    final dateStr = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    final timeStr = "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

    // 4. Gérer l'aperçu
    final String content = json['content'] ?? '';
    final String preview = content.length > 100 ? "${content.substring(0, 97)}..." : content;

    // 5. Gérer les pièces jointes (url unique pour le moment selon le schéma)
    final String? attachmentUrl = json['attachment_url'];
    List<AnnouncementAttachment> attachments = [];
    if (attachmentUrl != null && attachmentUrl.isNotEmpty) {
      final fileName = attachmentUrl.split('/').last.split('?').first;
      attachments.add(AnnouncementAttachment(
        filename: fileName,
        size: 'N/A',
        isPdf: fileName.toLowerCase().endsWith('.pdf'),
      ));
    }

    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      source: fullName.isNotEmpty ? fullName : authorRoleLabel,
      category: category,
      title: json['title'] ?? 'Sans titre',
      preview: preview,
      date: dateStr,
      body: content,
      authorName: fullName.isNotEmpty ? fullName : authorRoleLabel,
      authorRole: authorRoleLabel,
      publishDate: dateStr,
      publishTime: timeStr,
      attachments: attachments,
      attachmentCount: attachments.length,
      isUrgent: json['target_type'] == 'all', // Hypothèse : les annonces globales sont urgentes
      isUnread: false, // À gérer via une table de lecture si besoin
    );
  }

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
