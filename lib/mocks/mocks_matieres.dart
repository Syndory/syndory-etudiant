import 'package:flutter/material.dart';

/// ============================================================
///  MOCKS — Données factices pour les matières
///  (à remplacer plus tard par un vrai appel API / base de données)
/// ============================================================
///
///  Chaque matière est une Map avec les champs suivants :
///    - nom         : intitulé de la matière
///    - badge       : libellé court affiché en badge (ex: 'INFOS', 'MATHS')
///    - couleurBadge: couleur du badge
///    - assiduite   : taux d'assiduité entre 0.0 et 1.0
///    - prof        : nom du professeur
///    - coefficient : coefficient de la matière (int)
///    - progression : avancement du cours entre 0.0 et 1.0
///    - semestre    : numéro du semestre (1, 2 ou 3)
///    - avatarIcon  : icône représentant le prof (IconData)

const List<Map<String, dynamic>> mockMatieres = [
  // ── Semestre 1 ─────────────────────────────────────────────
  {
    'nom'          : 'Algorithmique Avancée',
    'badge'        : 'INF301',
    'couleurBadge' : Color(0xFFE67E22), // Orange
    'assiduite'    : 0.92,
    'prof'         : 'Prof. Jean-Marc Durand',
    'coefficient'  : 4,
    'progression'  : 0.65,
    'semestre'     : 1,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Architecture des Ordinateurs',
    'badge'        : 'SYS402',
    'couleurBadge' : Color(0xFF2C3E50), // Sombre
    'assiduite'    : 0.88,
    'prof'         : 'Dr. Sarah Khalifa',
    'coefficient'  : 6,
    'progression'  : 0.42,
    'semestre'     : 1,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Mathématiques Avancées',
    'badge'        : 'MAT205',
    'couleurBadge' : Color(0xFF3498DB), // Bleu
    'assiduite'    : 0.95,
    'prof'         : 'Prof. Alain Vernier',
    'coefficient'  : 3,
    'progression'  : 0.80,
    'semestre'     : 1,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Introduction au langage Python',
    'badge'        : 'INF202',
    'couleurBadge' : Color(0xFF1ABC9C), // Turquoise
    'assiduite'    : 0.34,
    'prof'         : 'Prof. Alain Vernier',
    'coefficient'  : 3,
    'progression'  : 0.80,
    'semestre'     : 1,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Mathématiques Financières',
    'badge'        : 'MAT205',
    'couleurBadge' : Color(0xFF3498DB),
    'assiduite'    : 0.85,
    'prof'         : 'Prof. Alain Vernier',
    'coefficient'  : 3,
    'progression'  : 0.80,
    'semestre'     : 1,
    'avatarIcon'   : Icons.person,
  },

  // ── Semestre 2 ─────────────────────────────────────────────
  {
    'nom'          : 'Bases de Données',
    'badge'        : 'INFOS',
    'couleurBadge' : Color(0xFF6C63FF),
    'assiduite'    : 0.78,
    'prof'         : 'Prof. Claire Martin',
    'coefficient'  : 4,
    'progression'  : 0.55,
    'semestre'     : 2,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Réseaux Informatiques',
    'badge'        : 'INFOS',
    'couleurBadge' : Color(0xFF6C63FF),
    'assiduite'    : 0.90,
    'prof'         : 'Dr. Éric Fontaine',
    'coefficient'  : 5,
    'progression'  : 0.70,
    'semestre'     : 2,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Statistiques et Probabilités',
    'badge'        : 'MATHS',
    'couleurBadge' : Color(0xFF00BCD4),
    'assiduite'    : 0.82,
    'prof'         : 'Prof. Alain Vernier',
    'coefficient'  : 3,
    'progression'  : 0.60,
    'semestre'     : 2,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Programmation Orientée Objet',
    'badge'        : 'INFOS',
    'couleurBadge' : Color(0xFF6C63FF),
    'assiduite'    : 0.96,
    'prof'         : 'Prof. Jean-Marc Durand',
    'coefficient'  : 4,
    'progression'  : 0.88,
    'semestre'     : 2,
    'avatarIcon'   : Icons.person,
  },

  // ── Semestre 3 ─────────────────────────────────────────────
  {
    'nom'          : 'Intelligence Artificielle',
    'badge'        : 'INFOS',
    'couleurBadge' : Color(0xFF6C63FF),
    'assiduite'    : 0.74,
    'prof'         : 'Dr. Sarah Khalifa',
    'coefficient'  : 6,
    'progression'  : 0.35,
    'semestre'     : 3,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Cryptographie et Sécurité',
    'badge'        : 'INFOS',
    'couleurBadge' : Color(0xFF6C63FF),
    'assiduite'    : 0.88,
    'prof'         : 'Dr. Éric Fontaine',
    'coefficient'  : 4,
    'progression'  : 0.50,
    'semestre'     : 3,
    'avatarIcon'   : Icons.person,
  },
  {
    'nom'          : 'Analyse Numérique',
    'badge'        : 'MATHS',
    'couleurBadge' : Color(0xFF00BCD4),
    'assiduite'    : 0.65,
    'prof'         : 'Prof. Alain Vernier',
    'coefficient'  : 3,
    'progression'  : 0.45,
    'semestre'     : 3,
    'avatarIcon'   : Icons.person,
  },
];
