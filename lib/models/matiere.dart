import 'document_pedago.dart';

class Matiere {
  final String id;
  final String code; // ex: "INF 301"
  final String nom;
  final String professeur;
  final int coefficient;
  final double tauxAssiduite; // 0.0 - 1.0
  final double tauxProgression; // 0.0 - 1.0
  final List<Chapitre> chapitres;
  final List<DocumentPedago> ressources;
  final List<Seance> seances;

  const Matiere({
    required this.id,
    required this.code,
    required this.nom,
    required this.professeur,
    required this.coefficient,
    required this.tauxAssiduite,
    required this.tauxProgression,
    required this.chapitres,
    required this.ressources,
    required this.seances,
  });
}

class Chapitre {
  final String titre;
  final String description;
  final bool traite;

  const Chapitre({
    required this.titre,
    required this.description,
    required this.traite,
  });
}

class Seance {
  final DateTime date;
  final String label;
  final String salle;
  final String heureDebut;
  final String heureFin;
  final String statut; // "PRESENT" | "ABSENT" | "JUSTIFIE"

  const Seance({
    required this.date,
    required this.label,
    required this.salle,
    required this.heureDebut,
    required this.heureFin,
    required this.statut,
  });
}
