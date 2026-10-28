import 'package:flutter_test/flutter_test.dart';

import 'package:noot/main.dart';

void main() {
  testWidgets('Splash menampilkan nama aplikasi', (tester) async {
    await tester.pumpWidget(const NootApp());
    expect(find.text('Noot'), findsOneWidget);

    // Habiskan timer splash agar tidak tersisa saat tes selesai.
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
