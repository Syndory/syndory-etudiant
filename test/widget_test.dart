// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:syndory_etudiant/main.dart';

void main() {
  testWidgets('Student profile page is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const SyndoryEtudiantApp());

    expect(find.text('Mon Profil'), findsOneWidget);
    expect(find.text('Kwame Mensah'), findsOneWidget);
    expect(find.text('Informations Personnelles'), findsOneWidget);
    expect(find.text('Securite & Compte'), findsOneWidget);
  });
}
