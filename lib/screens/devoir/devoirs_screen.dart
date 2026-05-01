import 'package:flutter/material.dart';
import 'package:syndory_etudiant/components/appBottomNavbar.dart';
import 'package:syndory_etudiant/components/appNavbar.dart';
import 'package:syndory_etudiant/components/devoirs/devoirs_body.dart';
import 'package:syndory_etudiant/mocks/mocksDevoirs.dart';

/// Écran "Mes Devoirs".
class DevoirsScreen extends StatefulWidget {
  final int navIndex;
  final ValueChanged<int>? onNavTap;

  const DevoirsScreen({super.key, this.navIndex = 0, this.onNavTap});

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
      appBar: AppNavbar(title: 'Mes Devoirs'),
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
