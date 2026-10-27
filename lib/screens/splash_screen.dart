import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/noot_logo.dart';
import 'login_screen.dart';

/// Splash: latar navy yang sama dengan latar logo, jadi pensil tampak melayang.
/// Seluruh isi berada tepat di tengah. Garis kuning di bawah nama tergambar dari
/// kiri ke kanan seperti goresan pensil, lalu aplikasi pindah ke Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _muncul;
  late final Animation<double> _garis;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _muncul = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.35, curve: Curves.easeOut),
    );
    _garis = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.85, curve: Curves.easeInOut),
    );
    _controller.addStatusListener(_onStatus);
    _controller.forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NootColors.navy,
      body: SizedBox.expand(
        child: Center(
          child: FadeTransition(
            opacity: _muncul,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NootLogo(size: 156),
                const SizedBox(height: 8),
                Text(
                  'Noot',
                  style: nootText(
                    52,
                    weight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 104,
                  height: 5,
                  child: AnimatedBuilder(
                    animation: _garis,
                    builder: (_, __) => Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _garis.value,
                        child: const ColoredBox(color: NootColors.yellow),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'catatan harian',
                  style: nootText(
                    17,
                    style: FontStyle.italic,
                    color: const Color(0xCCFFFFFF),
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
