import 'package:flutter/material.dart';
import 'package:syndory_etudiant/models/justificatifModels.dart';
import 'package:syndory_etudiant/screens/justificatif/emptyJustificatifScreen.dart';
import 'package:syndory_etudiant/screens/justificatif/uploadScreen.dart';

class JustificatifsTab extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int> onNavTap;
  
  final List<AbsenceEnAttente> pendingAbsences;

  const JustificatifsTab({
    super.key,
    required this.navIndex,
    required this.onNavTap,
    this.pendingAbsences = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (pendingAbsences.isEmpty) {
      
      return EmptyJustificatifsScreen(
        navIndex: navIndex,
        onNavTap: onNavTap,
      );
    }
    return JustificatifsUploadScreen(
      absence: pendingAbsences.first,
      navIndex: navIndex,
      onNavTap: onNavTap,
    );
  }
}