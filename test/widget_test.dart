
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_app/main.dart';

void main() {
  testWidgets('Messi vote counter test', (WidgetTester tester) async {
    await tester.pumpWidget(const MessiApp());

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('VOTAR MESSI'));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
