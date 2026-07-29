import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesou/app/tesou_app.dart';

void main() {
  testWidgets('affiche la promesse et les actions principales', (tester) async {
    await tester.pumpWidget(const TesouApp());

    expect(find.text('T’es où ? Je suis là !'), findsOneWidget);
    expect(find.text('Rassurer plutôt que surveiller.'), findsOneWidget);
    expect(find.text('Je pars'), findsOneWidget);
    expect(find.text('Coucou'), findsOneWidget);
    expect(find.text('T’es où ?'), findsOneWidget);
  });

  testWidgets('annonce une fonction à venir au clic', (tester) async {
    await tester.pumpWidget(const TesouApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Coucou'));
    await tester.pump();

    expect(find.text('Fonction bientôt disponible'), findsOneWidget);
  });
}
