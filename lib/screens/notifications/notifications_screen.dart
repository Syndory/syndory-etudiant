import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/services/notification_service.dart';

// page qui liste les notifications personnelles de l'etudiant
// ces notifs viennent de la table "notifications" du backend
// (different des annonces publiques de la table "annonces")
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationService();

  // la liste des notifications chargees depuis le backend
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // on charge les notifs des qu'on arrive sur la page
    _loadNotifications();
  }

  // appel reseau pour recuperer les notifications
  Future<void> _loadNotifications() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _service.fetchNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Impossible de charger les notifications.';
        _isLoading = false;
      });
    }
  }

  // marque une notif comme lue puis met a jour l'affichage
  Future<void> _marquerLue(Map<String, dynamic> notif) async {
    if (notif['is_read'] == true) return; // deja lue, rien a faire
    try {
      await _service.markAsRead(notif['id']);
      // on met a jour localement sans recharger toute la liste
      setState(() {
        final index = _notifications.indexOf(notif);
        if (index != -1) {
          _notifications[index] = {...notif, 'is_read': true};
        }
      });
    } catch (_) {
      // si ca echoue on laisse l'interface telle quelle
    }
  }

  // marque tout comme lu
  Future<void> _toutMarquerLu() async {
    try {
      await _service.markAllAsRead();
      setState(() {
        _notifications = _notifications.map((n) => {...n, 'is_read': true}).toList();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // nombre de notifications non lues pour le titre
    final nonLues = _notifications.where((n) => n['is_read'] == false).length;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.primary,
              ),
            ),
            // on affiche le nombre de non-lues si il y en a
            if (nonLues > 0)
              Text(
                '$nonLues non lue${nonLues > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: AppColors.secondary,
                ),
              ),
          ],
        ),
        actions: [
          // bouton pour tout marquer comme lu
          if (nonLues > 0)
            TextButton(
              onPressed: _toutMarquerLu,
              child: const Text(
                'Tout lire',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // affichage du spinner pendant le chargement
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      );
    }

    // affichage de l'erreur si le chargement a echoue
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_outlined, size: 52, color: AppColors.gray4),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter')),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadNotifications,
              child: const Text('Reessayer', style: TextStyle(color: AppColors.secondary)),
            ),
          ],
        ),
      );
    }

    // liste vide
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 64, color: AppColors.gray4),
            const SizedBox(height: 12),
            const Text(
              'Aucune notification',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // liste des notifications
    return RefreshIndicator(
      color: AppColors.secondary,
      // tirer vers le bas pour rafraichir
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _buildNotifCard(_notifications[index]);
        },
      ),
    );
  }

  // carte pour une notification individuelle
  Widget _buildNotifCard(Map<String, dynamic> notif) {
    final bool lue = notif['is_read'] == true;
    final String type = notif['type'] ?? 'announcement';
    final String titre = notif['title'] ?? '';
    final String message = notif['message'] ?? '';

    // on formate la date de creation
    String dateFormatee = '';
    try {
      final date = DateTime.parse(notif['created_at']).toLocal();
      dateFormatee = DateFormat('d MMM, HH:mm', 'fr_FR').format(date);
    } catch (_) {}

    return GestureDetector(
      // quand on tape sur la notif, on la marque comme lue
      onTap: () => _marquerLue(notif),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // les non-lues ont un fond legerement orange
          color: lue ? AppColors.white : AppColors.secondary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.cardShadow,
          border: lue ? null : Border.all(color: AppColors.secondary.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icone selon le type de notification
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _couleurType(type).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconeType(type), color: _couleurType(type), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(titre,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: lue ? FontWeight.w500 : FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.gray1,
                          ),
                        ),
                      ),
                      // point orange si non lue
                      if (!lue)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(message,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(dateFormatee,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.gray3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // retourne l'icone selon le type de notification
  IconData _iconeType(String type) {
    switch (type) {
      case 'session_opened': return Icons.event_available_outlined;
      case 'session_cancelled': return Icons.event_busy_outlined;
      case 'new_resource': return Icons.folder_open_outlined;
      case 'schedule_update': return Icons.update_outlined;
      case 'justification_status': return Icons.fact_check_outlined;
      case 'exam_reminder': return Icons.school_outlined;
      case 'announcement': return Icons.campaign_outlined;
      default: return Icons.notifications_outlined;
    }
  }

  // retourne la couleur selon le type de notification
  Color _couleurType(String type) {
    switch (type) {
      case 'session_cancelled': return AppColors.danger;
      case 'justification_status': return AppColors.warning;
      case 'exam_reminder': return AppColors.danger;
      case 'new_resource': return AppColors.success;
      default: return AppColors.primary;
    }
  }
}
