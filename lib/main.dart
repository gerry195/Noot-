import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const NootApp());
}

class NootApp extends StatelessWidget {
  const NootApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Noot',
        debugShowCheckedModeBanner: false,
        theme: buildNootTheme(),
        home: const SplashScreen(),
      );
}
