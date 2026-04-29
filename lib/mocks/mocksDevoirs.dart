import 'package:flutter/material.dart';

/// ============================================================
///  MOCKS — Données factices pour les devoirs
///  (à remplacer plus tard par un vrai appel API / base de données)
/// ============================================================
///
///  Chaque devoir est une Map avec les champs suivants :
///    - matiere    : nom de la matière (affiché en haut de la carte)
///    - titre      : intitulé du devoir
///    - date       : date limite en texte lisible
///    - progression: avancement entre 0.0 (0 %) et 1.0 (100 %)
///    - niveau     : priorité du devoir ('HAUTE', 'MOYENNE', 'BASSE')
///    - couleur    : couleur associée à la matière
///    - statut     : 'a_faire' | 'en_cours' | 'termine'
///                   → détermine dans quel onglet le devoir apparaît

const List<Map<String, dynamic>> mockDevoirs = [
  // ── Onglet "À faire" ──────────────────────────────────
  {
    'matiere'    : 'MACROÉCONOMIE',
    'titre'      : 'Analyse de marché',
    'date'       : 'Demain, 23h59',
    'progression': 0.0,
    'niveau'     : 'HAUTE',
    'couleur'    : Colors.red,
    'statut'     : 'a_faire',
  },
  {
    'matiere'    : 'ALGORITHMIQUE',
    'titre'      : "Implémentation d'arbres",
    'date'       : '15 Octobre',
    'progression': 0.0,
    'niveau'     : 'MOYENNE',
    'couleur'    : Colors.blue,
    'statut'     : 'a_faire',
  },

  // ── Onglet "En cours" ─────────────────────────────────
  {
    'matiere'    : 'DROIT DES SOCIÉTÉS',
    'titre'      : 'Cas Pratique - SARL',
    'date'       : '20 Octobre',
    'progression': 0.5,
    'niveau'     : 'BASSE',
    'couleur'    : Colors.orange,
    'statut'     : 'en_cours',
  },
  {
    'matiere'    : 'MATHÉMATIQUES',
    'titre'      : 'Intégrales et séries',
    'date'       : '22 Octobre',
    'progression': 0.75,
    'niveau'     : 'MOYENNE',
    'couleur'    : Colors.purple,
    'statut'     : 'en_cours',
  },

  // ── Onglet "Terminés" ─────────────────────────────────
  {
    'matiere'    : 'ANGLAIS',
    'titre'      : 'Essay - Climate Change',
    'date'       : '28 Octobre',
    'progression': 1.0,
    'niveau'     : 'BASSE',
    'couleur'    : Colors.green,
    'statut'     : 'termine',
  },
  {
    'matiere'    : 'HISTOIRE',
    'titre'      : 'Dissertation — WW2',
    'date'       : '1 Octobre',
    'progression': 1.0,
    'niveau'     : 'HAUTE',
    'couleur'    : Colors.teal,
    'statut'     : 'termine',
  },
];
