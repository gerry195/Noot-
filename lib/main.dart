import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/note_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteStore.instance.load();
  runApp(const NootApp());
}

class NootApp extends StatelessWidget {
  const NootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noot',
      debugShowCheckedModeBanner: false,
      theme: buildNootTheme(),
      // Di layar lebar (browser desktop) aplikasi tampil sebagai kolom selebar ponsel.
      builder: (context, child) => ColoredBox(
        color: NootColors.navy,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
