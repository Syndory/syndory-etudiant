import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/apptheme.dart';
import 'package:syndory_etudiant/components/notification/notification_card.dart';
import 'package:syndory_etudiant/components/notification/empty_state_notifications.dart';

class NotificationsScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const NotificationsScreen({
    super.key,
    this.navIndex = 1,
    this.onNavTap,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Liste avec STATUT (lu/non_lu)
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "status": "non_lu",
      "title": "Session de présence ouverte",
      "desc": "Algorithmie - Amphi B (Expire dans 10min)",
      "urgent": true,
    },
    {
      "id": 2,
      "status": "non_lu",
      "title": "Emploi du temps modifié",
      "desc": "La salle de Mathématiques a été déplacée en Salle 202",
      "urgent": false,
    },
    {
      "id": 3,
      "status": "lu",
      "title": "Rappel Examen",
      "desc": "Mathématiques (Partiel) - Demain à 08h00",
      "urgent": false,
    },
  ];

  // CHANGE LE STATUT UNIQUEMENT
  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['status'] = 'lu';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // FILTRAGE : On ne garde que les non lus
    final listToDisplay = _notifications.where((n) => n['status'] == 'non_lu').toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
      body: listToDisplay.isEmpty
          ? const EmptyStateNotifications()
          : ListView(
              children: [
                _buildMarkAsReadButton(),
                ...listToDisplay.map((n) => NotificationCard(
                      title: n['title'],
                      description: n['desc'],
                      time: "Maintenant",
                      isUnread: n['status'] == 'non_lu',
                      isUrgent: n['urgent'],
                      icon: Icons.notifications,
                    )),
                _buildFooterDecoration(),
              ],
            ),
    );
  }

  Widget _buildMarkAsReadButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 10),
        child: TextButton(
          onPressed: _markAllAsRead,
          child: const Text(
            "Tout marquer comme lu",
            style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
        const Text("Vous êtes à jour dans vos notifications.", style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 50),
      ],
    );
  }
}