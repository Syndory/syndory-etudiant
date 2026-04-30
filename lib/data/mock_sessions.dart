import '../models/session.dart';

class MockSessions {
  // Cas 1 : Présence enregistrée (Badge Vert)
  static final sessionPresent = Session(
    title: "Algorithmique Avancée",
    type: "Cours Magistral",
    professor: "Jean Dupont",
    date: "Lundi 14 Octobre",
    time: "08:30 — 10:30",
    room: "Salle 302",
    building: "Bâtiment Turing, 3ème étage",
    status: AttendanceStatus.present,
    notes: "Lors de cette séance, nous avons exploré la complexité algorithmique des structures de données avancées, notamment les arbres B+ et les graphes pondérés.",
  );

  // Cas 2 : Absence observée (Bouton Orange de justification)
  static final sessionAbsent = Session(
    title: "Algorithmique Avancée",
    type: "Cours Magistral",
    professor: "Jean Dupont",
    date: "Lundi 14 Octobre",
    time: "08:30 — 10:30",
    room: "Salle 302",
    building: "Bâtiment Turing, 3ème étage",
    status: AttendanceStatus.absent,
    notes: "Lors de cette séance, nous avons exploré la complexité algorithmique des structures de données avancées...",
  );

  // Cas 3 : Absence justifiée (Bloc Admin activé)
  static final sessionJustified = Session(
    title: "Algorithmique Avancée",
    type: "Cours Magistral",
    professor: "Jean Dupont",
    date: "Lundi 14 Octobre",
    time: "08:30 — 10:30",
    room: "Salle 302",
    building: "Bâtiment Turing, 3ème étage",
    status: AttendanceStatus.justified,
    adminComment: "Justificatif médical reçu le 15/10 et approuvé.",
    notes: "Lors de cette séance, nous avons exploré la complexité algorithmique des structures de données avancées...",
  );
}