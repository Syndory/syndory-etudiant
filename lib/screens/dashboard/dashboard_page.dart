import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/dashboard/header.dart';
import 'package:syndory_etudiant/components/dashboard/main_navigation_bar.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/components/dashboard/timetable_section.dart';
import 'package:syndory_etudiant/components/dashboard/active_session_banner.dart';
import 'package:syndory_etudiant/components/dashboard/empty_state_day_off.dart';
import 'package:syndory_etudiant/components/dashboard/stats_grid_section.dart';
import 'package:syndory_etudiant/components/dashboard/announcements_section.dart';
import 'package:syndory_etudiant/components/dashboard/recent_documents_section.dart';
import 'package:syndory_etudiant/components/dashboard/next_course_card.dart';
import '../notification/notifications_screen.dart'; 

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // simulation : change à 'true' pour voir la bannière de cours clignotante
    bool hasClassToday = false; 

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER AVEC NAVIGATION VERS NOTIFICATIONS
              _buildHeader(context),

              // 2. ZONE DYNAMIQUE (COURS VS REPOS)
              if (hasClassToday) ...[
                const ActiveSessionBanner(), // Ton composant pixel-perfect clignotant
                const NextCourseCard(), 
              ] else 
                const EmptyStateDayOff(), // Le composant avec le cornet de fête

              // 3. SECTIONS PERMANENTES
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: _PlaceholderStats(title: "PRÉSENCE", value: "85%")),
                    SizedBox(width: 15),
                    Expanded(child: _PlaceholderStats(title: "DEVOIRS", value: "3")),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  "Annonces",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF052A36)
                  ),
                ),
              ),
              const AnnouncementsSection(),

              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  "Documents récents",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF052A36)
                  ),
                ),
              ),
              const RecentDocumentsSection(),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(),
    );
  }

  // HEADER AVEC ACTION DE NOTIFICATION
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFE9F0FF),
                child: Icon(Icons.person, color: Color(0xFF052A36)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Syndory",
                    style: TextStyle(
                      color: Color(0xFFF06424), // Orange Syndory
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    ),
                  ),
                  Text(
                    "Bonjour, Kwame", 
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)
                  ),
                ],
              ),
            ],
          ),
          // BOUTON NOTIFICATION
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded, 
              size: 28, 
              color: Color(0xFF667A81)
            ),
          ),
        ],
      ),
    );
  }
}

// Simple Placeholder pour compiler sans erreurs si tes sections ne sont pas prêtes
class _PlaceholderStats extends StatelessWidget {
  final String title;
  final String value;
  const _PlaceholderStats({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}