import 'package:flutter/material.dart';
import '../../components/seances_en_cours/course_info_card.dart';
import 'gps_flow_screen.dart';


class LocationErrorScreen extends StatelessWidget {
  const LocationErrorScreen({super.key});

  static const Color _orange = Color(0xFFFF6B35);
  static const Color _darkTeal = Color(0xFF1A3C4D);
  static const Color _red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: _orange),
        ),
        title: const Text(
          'Détails de la séance',
          style: TextStyle(
            color: _orange,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card cours
            Padding(
              padding: const EdgeInsets.all(16),
              child: const CourseInfoCard(),
            ),

            // Bandeau EN COURS
            _buildBandeau(),

            // Infos
            _buildInfoTile(Icons.calendar_month_outlined, 'DATE & HEURE', 'Lundi 14 Octobre', '08:30 — 10:30'),
            _buildInfoTile(Icons.location_on_outlined, 'EMPLACEMENT', 'Salle 302', 'Bâtiment Turing, 3ème étage'),
            _buildProfesseur(),

            const SizedBox(height: 40),

            // Icône GPS erreur
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8E8),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      color: Colors.red.shade300,
                      size: 58,
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: _red, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Titre
            const Center(
              child: Text(
                'Erreur de localisation',
                style: TextStyle(
                  color: _red,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
                  children: [
                    TextSpan(text: 'Vous êtes hors du rayon autorisé. Pour valider votre présence, vous devez vous situer à moins de '),
                    TextSpan(
                      text: '50m',
                      style: TextStyle(fontWeight: FontWeight.w700, color: _darkTeal),
                    ),
                    TextSpan(text: ' de la salle de classe.'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Distance estimée
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.social_distance, color: _orange, size: 16),
                  SizedBox(width: 6),
                  Text('Distance estimée : ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text('142m', style: TextStyle(color: _darkTeal, fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBandeau() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: _orange, width: 3)),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: _orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.calendar_today, color: _orange, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('EN COURS', style: TextStyle(color: _orange, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
              SizedBox(height: 2),
              Text('Session ouverte maintenant', style: TextStyle(color: _darkTeal, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String line1, String line2) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.grey.shade500, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              const SizedBox(height: 2),
              Text(line1, style: const TextStyle(color: _darkTeal, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(line2, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfesseur() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=51'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Professeur', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              SizedBox(height: 2),
              Text('Prof. Jean Dupont', style: TextStyle(color: _darkTeal, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _orange,
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}