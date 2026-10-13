import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_app/main.dart';

void main() {
  testWidgets('Messi vote counter test', (WidgetTester tester) async {
    await tester.pumpWidget(const MessiApp());

    // Contador inicial
    expect(find.text('0'), findsOneWidget);

    // Carregar no botão
    await tester.tap(find.text('VOTAR MESSI'));
    await tester.pump();

    // Verificar incremento
    expect(find.text('1'), findsOneWidget);
  });
}
