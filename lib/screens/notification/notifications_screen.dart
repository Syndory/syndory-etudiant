import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syndory_etudiant/components/notification/notification_card.dart';
import 'package:syndory_etudiant/components/notification/empty_state_notifications.dart';
import 'package:syndory_etudiant/components/notification/notification_navigation_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. DATA BRUTE (Simule ce que tu recevras de Supabase via un Stream ou Future)
    final List<Map<String, dynamic>> rawNotifications = [
      {
        "title": "Session de présence ouverte",
        "desc": "Algorithmie - Amphi B (Expire dans 10min)",
        "created_at": DateTime.now().toIso8601String(),
        "type": "presence",
        "unread": true,
        "urgent": true,
      },
      {
        "title": "Emploi du temps modifié",
        "desc": "La salle de Mathématiques a été déplacée en Salle 202",
        "created_at": DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        "type": "edt",
        "unread": false,
        "urgent": false,
      },
      {
        "title": "Rappel Examen",
        "desc": "Mathématiques (Partiel) - Demain à 08h00",
        "created_at": DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        "type": "exam",
        "unread": false,
        "urgent": false,
      },
    ];

    // 2. TRI CHRONOLOGIQUE (Le plus récent en haut)
    rawNotifications.sort((a, b) => b['created_at'].compareTo(a['created_at']));

    // 3. GROUPEMENT DYNAMIQUE
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var n in rawNotifications) {
      final date = DateTime.parse(n['created_at']);
      final now = DateTime.now();
      String label;

      if (date.day == now.day && date.month == now.month && date.year == now.year) {
        label = "AUJOURD'HUI";
      } else if (date.day == now.subtract(const Duration(days: 1)).day) {
        label = "HIER";
      } else {
        label = DateFormat('dd MMMM yyyy').format(date).toUpperCase();
      }

      if (!grouped.containsKey(label)) grouped[label] = [];
      grouped[label]!.add(n);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF052A36)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Color(0xFFF06424), fontWeight: FontWeight.bold),
        ),
      ),
      body: rawNotifications.isEmpty
          ? const EmptyStateNotifications()
          : ListView.builder(
              itemCount: grouped.keys.length + 2, // +1 pour le bouton, +1 pour le footer
              itemBuilder: (context, index) {
                
                // 1. POSITION DU BOUTON "TOUT MARQUER COMME LU"
                if (index == 0) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      child: TextButton(
                        onPressed: () => debugPrint("Tout lire"),
                        child: const Text(
                          "Tout marquer comme lu",
                          style: TextStyle(
                            color: Color(0xFFF06424),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // 2. FOOTER DE FIN DE PAGE (PNG)
                if (index == grouped.keys.length + 1) {
                  return _buildFooterDecoration();
                }

                // 3. SECTIONS CHRONOLOGIQUES (Index décalé de -1 à cause du bouton)
                String dateLabel = grouped.keys.elementAt(index - 1);
                List<Map<String, dynamic>> items = grouped[dateLabel]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(dateLabel),
                    ...items.map((n) => NotificationCard(
                          title: n['title'],
                          description: n['desc'],
                          time: _formatTime(n['created_at']),
                          isUnread: n['unread'],
                          isUrgent: n['urgent'],
                          icon: _getIconByType(n['type']),
                        )),
                  ],
                );
              },
            ),
            bottomNavigationBar: const NotificationNavigationBar(),
    );
  }

  // --- HELPERS DYNAMIQUES ---

  String _formatTime(String isoDate) {
    final date = DateTime.parse(isoDate);
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return "Maintenant";
    if (diff.inHours < 24 && date.day == DateTime.now().day) return "Il y a ${diff.inHours}h";
    return DateFormat('HH:mm').format(date);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF052A36), letterSpacing: 1.1)),
    );
  }

  Widget _buildFooterDecoration() {
    return Column(
      children: [
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset('decoration.png', width: 160, height: 160, fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        const Text(
          "Vous êtes à jour dans vos notifications académiques.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  IconData _getIconByType(String type) {
    switch (type) {
      case 'presence': return Icons.person_add_alt_1;
      case 'edt': return Icons.calendar_month;
      case 'exam': return Icons.alarm;
      case 'document': return Icons.description_outlined;
      default: return Icons.notifications_none;
    }
  }
}