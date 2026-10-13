import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/main.dart';

void main() {
  testWidgets(
    'Teste da lista de estudantes de Programação',
    (WidgetTester tester) async {
      await tester.pumpWidget(const StudentListApp());

      // Verificar o título da aplicação
      expect(find.text('Lista de Estudantes'), findsOneWidget);

      // Verificar o título da secção
      expect(
        find.text('Estudantes de Programação'),
        findsOneWidget,
      );

      // Verificar os estudantes do curso de Programação
      expect(find.text('Rita'), findsOneWidget);
      expect(find.text('Inês'), findsOneWidget);

      // João pertence ao curso de Redes e não deve aparecer
      expect(find.text('João'), findsNothing);

      // Verificar o total de estudantes filtrados
      expect(
        find.text('Total de estudantes: 2'),
        findsOneWidget,
      );
    },
  );
}