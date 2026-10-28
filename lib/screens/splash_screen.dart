import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../widgets/noot_widgets.dart';
import 'login_screen.dart';

/// Halaman 1: logo dan nama aplikasi.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _duration = Duration(milliseconds: 2400);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_duration + const Duration(milliseconds: 200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: NootColors.blue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
            child: Column(
              children: [
                const Spacer(flex: 5),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 18 * (1 - t)),
                      child: child,
                    ),
                  ),
                  child: Column(
                    children: const [
                      NootLogo(size: 112),
                      SizedBox(height: 28),
                      Text(
                        'Noot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Simpan setiap ide, rencana, dan momen berharga dalam satu tempat.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFDCE6FF),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: _duration,
                  curve: Curves.easeInOut,
                  builder: (context, t, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: SizedBox(
                      width: 160,
                      height: 6,
                      child: LinearProgressIndicator(
                        value: t,
                        backgroundColor: const Color(0xFF4A7DF7),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
