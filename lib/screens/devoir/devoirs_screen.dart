import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbarNoReturn.dart'; 
import 'package:syndory_etudiant/components/devoirs/devoirs_body.dart';
import 'package:syndory_etudiant/mocks/mocksDevoirs.dart';
import 'package:syndory_etudiant/screens/notification/notifications_screen.dart';

/// Écran "Mes Devoirs".
class DevoirsScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const DevoirsScreen({
    super.key, 
    this.navIndex = 0, 
    this.onNavTap,
  });

  @override
  State<DevoirsScreen> createState() => _DevoirsScreenState();
}

class _DevoirsScreenState extends State<DevoirsScreen> {
  int _activeTab = 0;
  final List<Map<String, dynamic>> _devoirs = mockDevoirs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      
      // CORRECTION : Remplacement par AppNavBarNoReturn
      appBar: AppNavBarNoReturn(
        title: 'Mes Devoirs',
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
      ),
      
      body: DevoirsBody(
        activeTab: _activeTab,
        devoirs: _devoirs,
        onTabChanged: (index) => setState(() => _activeTab = index),
      ),
      
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navIndex,
        onTap: widget.onNavTap,
      ),
    );
  }
}