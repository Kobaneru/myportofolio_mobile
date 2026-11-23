import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

Future<void> _submit(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final save = find.text('Save');
  await tester.ensureVisible(save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Education enforces name and program length limits', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'a' * 256);
    await tester.enterText(fields.at(1), 'b' * 256);
    await _submit(tester);

    final institutionError = find.text('Nama institusi maksimal 255 karakter');
    final degreeError = find.text(
      'Gelar / program studi maksimal 255 karakter',
    );
    expect(institutionError, findsOneWidget);
    expect(degreeError, findsOneWidget);

    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'a' * 255);
    await tester.enterText(fields.at(1), '');
    await _submit(tester);
    expect(institutionError, findsNothing);
    expect(degreeError, findsNothing);
  });

  testWidgets('Experience checks title and optional thumbnail URL', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
    final fields = find.byType(TextFormField);
    final thumbnail = fields.at(2);
    final titleError = find.text('Nama pengalaman maksimal 255 karakter');
    final formatError = find.text('Masukkan URL thumbnail yang valid');
    final lengthError = find.text('URL thumbnail maksimal 200 karakter');

    await tester.enterText(fields.first, 'a' * 256);
    await tester.ensureVisible(thumbnail);
    await tester.enterText(thumbnail, 'https://.');
    await _submit(tester);
    expect(titleError, findsOneWidget);
    expect(formatError, findsOneWidget);

    const prefix = 'https://example.com/';
    await tester.ensureVisible(thumbnail);
    await tester.enterText(thumbnail, prefix + 'a' * (201 - prefix.length));
    await _submit(tester);
    expect(lengthError, findsOneWidget);

    await tester.ensureVisible(thumbnail);
    await tester.enterText(
      thumbnail,
      '  $prefix${'a' * (200 - prefix.length)}  ',
    );
    await _submit(tester);
    expect(formatError, findsNothing);
    expect(lengthError, findsNothing);

    await tester.ensureVisible(thumbnail);
    await tester.enterText(thumbnail, '');
    await _submit(tester);
    expect(formatError, findsNothing);
    expect(lengthError, findsNothing);
  });
}
