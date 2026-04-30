class DocumentPedago {
  final String id;
  final String titre;
  final String matiere;
  final String type; // "PDF" | "DOCX" | "PPTX"
  final String professeur;
  final DateTime dateUpload;
  final bool isNew;

  const DocumentPedago({
    required this.id,
    required this.titre,
    required this.matiere,
    required this.type,
    required this.professeur,
    required this.dateUpload,
    required this.isNew,
  });
}
