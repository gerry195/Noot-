import 'package:flutter_test/flutter_test.dart';
import 'package:noot/main.dart';
import 'package:noot/services/note_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Splash tampil lalu pindah ke Login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await NoteStore.instance.load();

    await tester.pumpWidget(const NootApp());
    expect(find.text('Noot'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Masuk untuk melanjutkan'), findsOneWidget);
  });
}