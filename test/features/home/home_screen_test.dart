import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesou/app/tesou_app.dart';

void main() {
  testWidgets('affiche le nouvel accueil et les actions principales', (tester) async {
    await tester.pumpWidget(const TesouApp());

    expect(find.text('T’es où ?'), findsWidgets);
    expect(find.text('Je suis là.'), findsOneWidget);
    expect(find.text('Tout va bien'), findsWidgets);
    expect(find.text('Mes proches'), findsOneWidget);
    expect(find.text('Famille'), findsOneWidget);
    expect(find.text('Amis'), findsOneWidget);
    expect(find.text('Je pars'), findsOneWidget);
    expect(find.text('Coucou'), findsOneWidget);
    expect(find.text('Rassurer plutôt que surveiller.'), findsOneWidget);
  });

  testWidgets('annonce une fonction à venir au clic', (tester) async {
    await tester.pumpWidget(const TesouApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Coucou'));
    await tester.pump();

    expect(find.text('Coucou — fonction bientôt disponible'), findsOneWidget);
  });
}
