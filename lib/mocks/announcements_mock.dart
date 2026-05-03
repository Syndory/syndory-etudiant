// lib/mocks/announcements_mock.dart

import 'package:syndory_etudiant/models/announcement_model.dart';

class AnnouncementsMock {
  static const List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'ann_01',
      source: 'Administration',
      category: AnnouncementCategory.administration,
      title: "Mise à jour des frais d'inscription 2024",
      preview:
          "Veuillez noter que le calendrier de paiement pour le semestre…",
      date: 'Il y a 3 jours',
      isUnread: true,
      readTime: '3 min read',
      authorName: 'Dr. Jean Dupont',
      authorRole: 'Directeur des Études',
      publishDate: '12 Octobre 2023',
      publishTime: '14:30',
      body:
          "Chers étudiants, nous vous informons d'un ajustement mineur concernant "
          "les dates des épreuves finales pour le semestre en cours. Cette décision "
          "fait suite à une concertation avec le conseil académique pour optimiser "
          "la préparation des salles.\n\n"
          "Le calendrier initial prévoyait un début des épreuves le 15 Novembre. Après "
          "révision, la nouvelle date officielle de lancement est fixée au 20 Novembre "
          "2023. Cet aménagement offre une semaine supplémentaire de révisions intensives.\n\n"
          "Veuillez consulter la liste détaillée jointe à cette annonce pour connaître "
          "les horaires précis par filière. Les cartes d'étudiant seront exigées à "
          "l'entrée de chaque salle. Aucun retard ne sera toléré au-delà de 15 minutes "
          "après le début de l'épreuve.",
      quote:
          '"La réussite académique dépend de l\'organisation et de la sérénité. '
          'Nous mettons tout en œuvre pour vous offrir les meilleures conditions d\'examen."',
      attachments: [
        AnnouncementAttachment(
            filename: 'Planning_Final_S2.pdf', size: '1.2 MB', isPdf: true),
        AnnouncementAttachment(
            filename: 'Plan_Salles_Campus.jpg', size: '3.5 MB', isPdf: false),
      ],
    ),
    AnnouncementModel(
      id: 'ann_02',
      source: 'Prof. Smith',
      category: AnnouncementCategory.academique,
      title: "Ressources supplémentaires : Algèbre Linéaire",
      preview:
          "Les notes de cours révisées et les exercices pratiques pour le Chapitre…",
      date: '2 Septembre 2024',
      isUnread: false,
      attachmentCount: 2,
      readTime: '4 min read',
      authorName: 'Prof. Smith',
      authorRole: 'Professeur de Mathématiques',
      publishDate: '2 Septembre 2024',
      publishTime: '10:00',
      body:
          "Chers étudiants, je mets à votre disposition les ressources complémentaires "
          "pour le chapitre 3 d'Algèbre Linéaire. Ces documents contiennent les "
          "corrections des exercices du TD ainsi que des fiches de révision résumant "
          "les points clés du cours.\n\n"
          "N'hésitez pas à me contacter par email si vous avez des questions avant "
          "l'évaluation du 15 Septembre.",
      attachments: [
        AnnouncementAttachment(
            filename: 'Cours_Algebre_Ch3.pdf', size: '2.8 MB', isPdf: true),
        AnnouncementAttachment(
            filename: 'Exercices_Corriges.pdf', size: '1.1 MB', isPdf: true),
      ],
    ),
    AnnouncementModel(
      id: 'ann_03',
      source: "Bureau des Étudiants",
      category: AnnouncementCategory.bureauEtudiants,
      title: "Soirée de bienvenue - Session d'automne",
      preview:
          "Rejoignez-nous ce vendredi au Grand Hall pour célébrer le début…",
      date: '28 Août 2024',
      isUnread: false,
      location: 'Grand Hall, Campus Nord',
      readTime: '2 min read',
      authorName: 'Bureau des Étudiants',
      authorRole: 'Organisation étudiante',
      publishDate: '28 Août 2024',
      publishTime: '09:00',
      body:
          "Le Bureau des Étudiants a le plaisir de vous inviter à la soirée de "
          "bienvenue pour la session d'automne 2024. Au programme : animations, "
          "buffet dînatoire et remise des kits étudiants.\n\n"
          "Venez nombreux célébrer le début de cette nouvelle année académique avec "
          "vos camarades et l'équipe encadrante.",
    ),
    AnnouncementModel(
      id: 'ann_04',
      source: 'Service IT',
      category: AnnouncementCategory.serviceIT,
      title: "Maintenance du portail étudiant",
      preview:
          "Le portail sera temporairement indisponible ce dimanche de 02:00…",
      date: '30 Août 2024',
      isUnread: true,
      isUrgent: true,
      readTime: '2 min read',
      authorName: 'Service IT',
      authorRole: 'Direction des Systèmes d\'Information',
      publishDate: '30 Août 2024',
      publishTime: '08:00',
      body:
          "Nous vous informons qu'une opération de maintenance planifiée aura lieu "
          "ce dimanche de 02:00 à 06:00. Durant cette plage horaire, l'accès au "
          "portail étudiant, aux emplois du temps en ligne et au dépôt de devoirs "
          "sera temporairement suspendu.\n\n"
          "Nous vous recommandons de télécharger vos documents nécessaires avant "
          "ce créneau. Merci de votre compréhension.",
    ),
  ];
}
