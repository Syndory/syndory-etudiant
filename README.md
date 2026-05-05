# Syndory Étudiant

Application mobile Flutter pour les étudiants de la plateforme universitaire **Syndory**.
Ce dépôt correspond à la partie **étudiant** du projet (gestion des présences, emploi du temps, devoirs, ressources pédagogiques).

> Projet scolaire L3 — travail d'équipe.

---

## Stack technique

- **Framework** : Flutter
- **Langage** : Dart (SDK >= 3.10.0)
- **Données** : Mock statique (pas encore de backend connecté)
- **Design** : Figma — SYNDORI-ETU

---

## Prérequis

- Flutter installé (version recommandée : 3.41.9 / Dart >= 3.10)
- Un émulateur Android, iOS, ou Chrome (web)

Vérifier l'installation :
```bash
flutter doctor
```

---

## Installation et lancement

```bash
# 1. Cloner le projet
git clone https://github.com/Syndory/syndory-etudiant
cd syndory-etudiant

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run
```

Choisir le device quand Flutter le demande (Chrome recommandé pour tester rapidement).

---

## Structure des fichiers

```
lib/
├── main.dart                          # Point d'entrée, routes, navigation principale
│
├── screens/                           # Pages de l'application (une par fonctionnalité)
│   ├── auth/
│   │   └── login_screen.dart          # Page de connexion (ETU-01)
│   ├── dashboard/
│   │   └── dashboard_page.dart        # Tableau de bord principal (ETU-02)
│   ├── profile/
│   │   └── profile_screen.dart        # Profil étudiant (ETU-03)
│   ├── calendar/
│   │   └── calendar_page.dart         # Calendrier / emploi du temps
│   ├── justificatif/
│   │   └── justificatifs_tab.dart     # Justificatifs d'absence
│   ├── attendance/
│   │   └── attendanceScreen.dart      # Assiduité
│   ├── matieres/
│   │   ├── matieres_screen.dart       # Liste des matières
│   │   └── matiere_detail_screen.dart # Détail d'une matière
│   ├── devoir/
│   │   └── devoirs_screen.dart        # Mes devoirs
│   ├── resources/
│   │   └── resources_page.dart        # Ressources pédagogiques
│   ├── annonces/
│   │   └── annonces_screen.dart       # Annonces + détail annonce
│   └── seances_en_cours/              # Flow GPS présence
│
├── components/                        # Widgets réutilisables
│   ├── appTheme.dart                  # Couleurs et typographie (AppColors)
│   ├── appBottomNavbar.dart           # Barre de navigation (8 onglets)
│   ├── appNavbar.dart                 # Header générique avec retour
│   ├── dashboard/                     # Composants du dashboard
│   ├── attendance/                    # Composants assiduité
│   ├── devoirs/                       # Composants devoirs
│   ├── justificatif/                  # Composants justificatifs
│   ├── matieres/                      # Composants matières
│   └── seances_en_cours/              # Composants GPS
│
└── mocks/                             # Données fictives (à remplacer par l'API)
    ├── dashboardMockData.dart          # Utilisateur, session active, annonces
    ├── attendanceMock.dart             # Données d'assiduité
    ├── mocksDevoirs.dart               # Devoirs
    └── mocks_matieres.dart             # Liste des matières (3 semestres)
```

---

## Navigation

L'application utilise une **barre de navigation à 8 onglets** :

| Index | Icône | Écran |
|-------|-------|-------|
| 0 | Maison | Tableau de bord |
| 1 | Calendrier | Calendrier |
| 2 | Personne barrée | Justificatifs d'absence |
| 3 | Check-list | Assiduité |
| 4 | Livre | Mes Matières |
| 5 | Devoir | Mes Devoirs |
| 6 | Dossier | Ressources |
| 7 | Personne | Mon Profil |

L'app démarre sur la **page de connexion**. Après connexion, on arrive sur le tableau de bord.

---

## État actuel du projet

- Toutes les données sont **mockées** (fichiers dans `lib/mocks/`)
- Il n'y a **aucun appel API réel** pour l'instant
- Le backend (NestJS) est en cours de développement par une autre équipe
- Les boutons "Enregistrer", "Changer mot de passe" simulent un délai réseau avec `Future.delayed`
- L'authentification est simulée : n'importe quel email valide + 6 caractères minimum connecte

---

## Comment tester les écrans

1. **Login** : saisir un email quelcquonque (avec `@`) + mot de passe quelqconque (6+ caractères) → bouton "Se connecter"
2. **Dashboard** : vérifier le header, la bannière de session active, la carte "À suivre", cliquer la cloche pour aller aux annonces
3. **Annonces** : accessible depuis la cloche ou "Voir tout" → filtres par catégorie → cliquer une annonce pour le détail
4. **Matières** : changer de semestre, rechercher, cliquer une carte → détail avec stats et séances
5. **Profil** : onglet 8 (icône personne) → modifier les champs → "Enregistrer" → tester la déconnexion

---

## Branches

- `master` : code stable de l'équipe
- `develop` : branche d'intégration

---

## Intégration backend (à venir)

Quand le backend NestJS sera prêt, il faudra :

1. Ajouter `dio` dans `pubspec.yaml` pour les appels HTTP
2. Créer `lib/services/api_service.dart` avec l'URL de base
3. Créer `lib/services/auth_service.dart` avec la méthode `login()` et la gestion du token JWT
4. Remplacer les données mock par de vrais appels dans chaque écran
