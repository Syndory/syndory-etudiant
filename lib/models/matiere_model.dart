import 'package:flutter/material.dart';

/// ============================================================
///  Modèle — Matière (table `matieres` Supabase)
///
///  Champs renvoyés par PostgREST :
///    id, nom, code, created_at
///
///  Champs calculés côté client (non présents en DB) :
///    progression  → viendra de la table `progressions` (étape future)
///    statut       → déduit de la progression
///    couleur      → attribuée par hash sur l'id/nom
///    prochaineDate → viendra de `seances` (étape future)
/// ============================================================
class Matiere {
  final String id;
  final String nom;
  final String? code;
  final DateTime? createdAt;

  // ── Champs enrichis (calculés après fetch) ──────────────────────
  final double progression;     // 0.0 → 1.0
  final String? prochaineDate;  // ex: "15 Octobre"

  const Matiere({
    required this.id,
    required this.nom,
    this.code,
    this.createdAt,
    this.progression = 0.0,
    this.prochaineDate,
  });

  // ── Désérialisation depuis la réponse PostgREST ────────────────
  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      id: json['id'] as String,
      nom: json['nom'] as String? ?? 'Matière inconnue',
      code: json['code'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      // progression et prochaineDate seront injectés séparément
      progression: (json['progression'] as num?)?.toDouble() ?? 0.0,
      prochaineDate: json['prochaine_date'] as String?,
    );
  }

  /// Crée une copie avec des champs enrichis (immutabilité).
  Matiere copyWith({
    double? progression,
    String? prochaineDate,
  }) {
    return Matiere(
      id: id,
      nom: nom,
      code: code,
      createdAt: createdAt,
      progression: progression ?? this.progression,
      prochaineDate: prochaineDate ?? this.prochaineDate,
    );
  }

  // ── Statut calculé à partir de la progression ──────────────────

  /// 'a_faire' | 'en_cours' | 'termine'
  String get statut {
    if (progression <= 0.0) return 'a_faire';
    if (progression >= 1.0) return 'termine';
    return 'en_cours';
  }

  // ── Couleur déterministe basée sur le nom de la matière ────────
  /// Chaque matière obtient toujours la même couleur (stable entre rechargements).
  Color get couleur => _couleurParNom(nom);

  static const _palette = [
    Color(0xFFE53935), // rouge
    Color(0xFF1E88E5), // bleu
    Color(0xFF43A047), // vert
    Color(0xFFFF8F00), // orange
    Color(0xFF8E24AA), // violet
    Color(0xFF00ACC1), // cyan
    Color(0xFF6D4C41), // marron
    Color(0xFF3949AB), // indigo
  ];

  static Color _couleurParNom(String nom) {
    final hash = nom.codeUnits.fold(0, (acc, c) => acc + c);
    return _palette[hash % _palette.length];
  }

  // ── Niveau (priorité) affiché dans le badge ────────────────────
  /// Basé sur la progression : plus on est loin du bout, plus c'est urgent.
  String get niveau {
    if (progression <= 0.0) return 'HAUTE';
    if (progression < 0.5) return 'MOYENNE';
    return 'BASSE';
  }

  @override
  String toString() => 'Matiere(id: $id, nom: $nom, progression: $progression)';
}
