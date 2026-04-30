import 'package:flutter/material.dart';
import '../components/custom_bottom_nav.dart'; // Import du composant
import '../data/mock_sessions.dart';
import 'session_detail_screen.dart';
import '../models/session.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Session> sessions = [
      MockSessions.sessionPresent,
      MockSessions.sessionAbsent,
      MockSessions.sessionJustified,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Séances", style: TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(
                session.status == AttendanceStatus.present ? Icons.check_circle : Icons.error,
                color: session.status == AttendanceStatus.present ? Colors.green : const Color(0xFFE67E22),
              ),
              title: Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${session.date} • ${session.time}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SessionDetailScreen(session: session)),
                );
              },
            ),
          );
        },
      ),
      // Intégration de la barre de navigation (image_9a1490.png)
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1), 
    );
  }
}