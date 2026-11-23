import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

void main() {
  testWidgets('Education requires an end date before showing the summary', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
    await tester.enterText(find.byType(TextFormField).first, 'Universitas');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final startCalendar = find.byIcon(Icons.calendar_today_outlined).first;
    await tester.ensureVisible(startCalendar);
    await tester.tap(startCalendar);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final save = find.text('Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Tanggal selesai wajib diisi'), findsOneWidget);

    final endCalendar = find.byIcon(Icons.calendar_today_outlined).last;
    await tester.ensureVisible(endCalendar);
    await tester.tap(endCalendar);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'Tanggal Selesai: \d{2}/\d{2}/\d{4}')),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('dd/mm/yyyy'), findsNWidgets(2));
  });
}
