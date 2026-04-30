import 'package:flutter/material.dart';
import '../models/session.dart';
import '../components/attendance_header.dart';
import '../components/info_row.dart';
import '../components/admin_status_card.dart';
import '../components/attachement_tile.dart';
import '../components/custom_bottom_nav.dart'; // <--- AJOUT : Import du composant

class SessionDetailScreen extends StatelessWidget {
  final Session session; 

  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE67E22)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Détails de la séance",
          style: TextStyle(color: Color(0xFFE67E22), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AttendanceHeader(session: session),
            const SizedBox(height: 20),

            InfoRow(
              icon: Icons.calendar_today_outlined,
              label: "DATE & HEURE",
              value: "${session.date}\n${session.time}",
            ),
            const SizedBox(height: 15),
            InfoRow(
              icon: Icons.location_on_outlined,
              label: "EMPLACEMENT",
              value: "${session.room}\n${session.building}",
            ),
            const SizedBox(height: 15),

            if (session.status == AttendanceStatus.justified)
              AdminStatusCard(comment: session.adminComment),
              
            _buildProfessorSection(),
            const SizedBox(height: 25),

            const Text(
              "Notes de séance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF143030)),
            ),
            const SizedBox(height: 12),
            _buildNotesContent(),
            const SizedBox(height: 100), 
          ],
        ),
      ),
      bottomSheet: session.status == AttendanceStatus.absent ? _buildBottomAction(context) : null,
      
      // AJOUT : La barre de navigation en bas de page
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1), 
    );
  }

  
  Widget _buildProfessorSection() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/prof_avatar.png'),
      ),
      title: const Text("Professeur", style: TextStyle(color: Colors.grey, fontSize: 12)),
      subtitle: Text(
        "Prof. ${session.professor}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF143030)),
      ),
    );
  }

  Widget _buildNotesContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.notes,
            style: const TextStyle(height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          const AttachmentTile(fileName: "Support_Cours_V3.pdf", isArchive: false),
          const SizedBox(height: 10),
          const AttachmentTile(fileName: "TD_Arbres_Equilibres.zip", isArchive: true),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF8F9FA),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE67E22),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          "Justifier une absence",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}