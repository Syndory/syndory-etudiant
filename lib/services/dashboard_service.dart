import 'package:dio/dio.dart';
import 'package:syndory_etudiant/services/dio_client.dart';
import 'package:syndory_etudiant/services/auth_service.dart';

class DashboardData {
  final Map<String, dynamic> user;
  final Map<String, dynamic>? activeSession;
  final Map<String, dynamic>? nextCourse;
  final int devoirsCount;
  final double presenceRate;
  final List<Map<String, dynamic>> lastAnnonces;
  final List<Map<String, dynamic>> recentDocuments;
  final List<Map<String, dynamic>> timetable;

  DashboardData({
    required this.user,
    this.activeSession,
    this.nextCourse,
    required this.devoirsCount,
    required this.presenceRate,
    required this.lastAnnonces,
    this.recentDocuments = const [],
    this.timetable = const [],
  });
}

class DashboardService {
  DashboardService._();
  static final DashboardService instance = DashboardService._();

  final Dio _dio = DioClient.instance;

  Future<DashboardData> fetchDashboardData() async {
    try {
      // 1. Récupérer l'ID de l'utilisateur connecté via l'AuthService
      final currentUserAuth = AuthService.instance.user;
      final userId = currentUserAuth?['id'];
      
      if (userId == null) {
        throw Exception("Utilisateur non connecté");
      }

      // --- Requêtes en parallèle ---
      final futures = await Future.wait([
        _fetchUserProfile(userId),
        _fetchActiveSession(),
        _fetchNextCourse(),
        _fetchDevoirsCount(),
        _fetchPresenceRate(userId),
        _fetchAnnonces(),
        _fetchTimetable(),
        _fetchRecentDocuments(),
      ]);

      final userProfile = futures[0] as Map<String, dynamic>? ?? {};
      final activeSession = futures[1] as Map<String, dynamic>?;
      final nextCourse = futures[2] as Map<String, dynamic>?;
      final devoirsCount = futures[3] as int? ?? 0;
      final presenceRate = futures[4] as double? ?? 0.0;
      final lastAnnonces = futures[5] as List<Map<String, dynamic>>? ?? [];
      final timetable = futures[6] as List<Map<String, dynamic>>? ?? [];
      final recentDocuments = futures[7] as List<Map<String, dynamic>>? ?? [];

      return DashboardData(
        user: {
          "id": userId,
          "nom": "${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}".trim(),
          "role": userProfile['role'] ?? 'etudiant',
          "filiere": userProfile['filiere_name'] ?? "Génie Logiciel — L3",
          "universite": "Université d'Abomey-Calavi",
        },
        activeSession: activeSession,
        nextCourse: nextCourse,
        devoirsCount: devoirsCount,
        presenceRate: presenceRate,
        lastAnnonces: lastAnnonces,
        timetable: timetable,
        recentDocuments: recentDocuments,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 1. Profil Utilisateur
  Future<Map<String, dynamic>?> _fetchUserProfile(String userId) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'id': 'eq.$userId',
          'select': 'first_name,last_name,role',
          'limit': 1,
        },
      );
      final data = response.data as List<dynamic>;
      if (data.isNotEmpty) {
        return data.first as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // 2. Session Active
  Future<Map<String, dynamic>?> _fetchActiveSession() async {
    try {
      // Une session active est une session dont le statut est 'ouverte' ou 'closed_at' est null
      // Le RLS Supabase filtre automatiquement les sessions pour la classe de l'étudiant
      final response = await _dio.get(
        '/sessions',
        queryParameters: {
          'closed_at': 'is.null', // ou status='eq.ouverte' selon la DB exacte
          'select': 'id,seance_id,seances(matieres(name),users(first_name,last_name),salles(name))',
          'limit': 1,
        },
      );
      final data = response.data as List<dynamic>;
      if (data.isNotEmpty) {
        final session = data.first;
        final seance = session['seances'];
        final matiere = seance?['matieres']?['name'] ?? 'Matière Inconnue';
        final profName = "${seance?['users']?['first_name'] ?? ''} ${seance?['users']?['last_name'] ?? ''}".trim();
        final salle = seance?['salles']?['name'] ?? 'Salle Inconnue';

        return {
          "id": session['id'],
          "matiere": matiere,
          "prof": profName.isEmpty ? "Professeur" : profName,
          "salle": salle,
          "est_ouverte": true,
        };
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // 3. Prochain Cours
  Future<Map<String, dynamic>?> _fetchNextCourse() async {
    try {
      // Les séances à venir (à partir d'aujourd'hui)
      // RLS filtre pour l'étudiant
      final now = DateTime.now().toIso8601String();
      final response = await _dio.get(
        '/seances',
        queryParameters: {
          'date': 'gte.${now.split('T')[0]}', // Filtrer les dates >= aujourd'hui
          'status': 'eq.publié',
          'order': 'date.asc,start_time.asc',
          'select': 'id,date,start_time,end_time,matieres(name),users(first_name,last_name),salles(name)',
          'limit': 1,
        },
      );
      final data = response.data as List<dynamic>;
      if (data.isNotEmpty) {
        final seance = data.first;
        final matiere = seance['matieres']?['name'] ?? 'Matière Inconnue';
        final profName = "${seance['users']?['first_name'] ?? ''} ${seance['users']?['last_name'] ?? ''}".trim();
        final salle = seance['salles']?['name'] ?? 'Salle Inconnue';
        
        final startTime = seance['start_time'] != null ? seance['start_time'].substring(0, 5) : '';
        final endTime = seance['end_time'] != null ? seance['end_time'].substring(0, 5) : '';

        return {
          "matiere": matiere,
          "prof": profName.isEmpty ? "Professeur" : profName,
          "salle": salle,
          "horaire": "$startTime - $endTime",
          "nb_etudiants": 0, // Optionnel ou complexe à calculer ici
          "temps_restant": "À venir", // Pourrait être calculé plus finement
        };
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // 4. Nombre de devoirs (Séances avec is_exam = true)
  Future<int> _fetchDevoirsCount() async {
    try {
      final response = await _dio.get(
        '/seances',
        queryParameters: {
          'is_exam': 'eq.true',
          'select': 'id', // just count
        },
      );
      final data = response.data as List<dynamic>;
      return data.length;
    } catch (_) {
      return 0;
    }
  }

  // 5. Taux de présence
  Future<double> _fetchPresenceRate(String userId) async {
    try {
      final response = await _dio.get(
        '/presences',
        queryParameters: {
          'student_id': 'eq.$userId',
          'select': 'status',
        },
      );
      final data = response.data as List<dynamic>;
      if (data.isEmpty) return 1.0; // Par défaut s'il n'y a pas de présences

      int presentsEtJustifies = 0;
      for (var p in data) {
        final status = p['status'];
        if (status == 'present' || status == 'justified') {
          presentsEtJustifies++;
        }
      }
      return presentsEtJustifies / data.length;
    } catch (_) {
      return 0.85; // Fallback
    }
  }

  // 6. Annonces Récentes
  Future<List<Map<String, dynamic>>> _fetchAnnonces() async {
    try {
      // Les RLS s'occupent de filtrer les annonces visibles par l'utilisateur
      final response = await _dio.get(
        '/annonces',
        queryParameters: {
          'is_published': 'eq.true',
          'order': 'created_at.desc',
          'select': 'id,title,created_at',
          'limit': 2,
        },
      );
      final data = response.data as List<dynamic>;
      return data.map((json) {
        final date = DateTime.tryParse(json['created_at'] ?? '');
        String dateStr = '';
        bool isNew = false;
        if (date != null) {
          dateStr = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
          // Considéré comme nouveau si moins de 48h
          isNew = DateTime.now().difference(date).inHours < 48;
        }
        
        return {
          "titre": json['title'] ?? 'Annonce sans titre',
          "date": dateStr,
          "est_nouveau": isNew,
        };
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // 7. Emploi du temps du jour
  Future<List<Map<String, dynamic>>> _fetchTimetable() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _dio.get(
        '/seances',
        queryParameters: {
          'date': 'eq.$today',
          'status': 'eq.publié',
          'order': 'start_time.asc',
          'select': 'id,start_time,end_time,matieres(name),salles(name)',
        },
      );
      final data = response.data as List<dynamic>;
      return data.map((json) {
        final start = json['start_time'] != null ? (json['start_time'] as String).substring(0, 5) : '--:--';
        final end   = json['end_time']   != null ? (json['end_time']   as String).substring(0, 5) : '--:--';
        return {
          'horaire':  '$start - $end',
          'matiere':  json['matieres']?['name'] ?? 'Cours',
          'salle':    json['salles']?['name']   ?? 'Salle inconnue',
        };
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // 8. Documents récents
  Future<List<Map<String, dynamic>>> _fetchRecentDocuments() async {
    try {
      final response = await _dio.get(
        '/ressources',
        queryParameters: {
          'order': 'created_at.desc',
          'select': 'id,title,file_url,created_at',
          'limit': 3,
        },
      );
      final data = response.data as List<dynamic>;
      return data.map((json) {
        final date = DateTime.tryParse(json['created_at'] ?? '');
        String dateInfo = '';
        if (date != null) {
          final diff = DateTime.now().difference(date);
          if (diff.inDays == 0) {
            dateInfo = "Ajouté aujourd'hui";
          } else if (diff.inDays == 1) {
            dateInfo = 'Ajouté hier';
          } else {
            dateInfo = 'Ajouté il y a ${diff.inDays} jours';
          }
        }
        final fileUrl = json['file_url'] as String? ?? '';
        final fileName = fileUrl.isNotEmpty ? fileUrl.split('/').last.split('?').first : (json['title'] ?? 'document');
        return {
          'nom':  fileName,
          'info': dateInfo,
          'url':  fileUrl,
        };
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de connexion dépassé. Vérifiez votre réseau.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Impossible de joindre le serveur. Vérifiez votre connexion.');
    }
    return Exception('Erreur de chargement du tableau de bord.');
  }
}
