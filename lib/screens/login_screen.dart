import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/noot_logo.dart';
import 'home_screen.dart';

/// Login statis: hanya tampilan, tanpa autentikasi.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  bool _sembunyikan = true;

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _masuk() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NootLogo(size: 84),
                const SizedBox(height: 18),
                const Text(
                  'Noot',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Masuk untuk melanjutkan',
                  style: TextStyle(color: NootColors.muted, fontSize: 15),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: nootInput(
                    'Email',
                    prefix: const Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _sandi,
                  obscureText: _sembunyikan,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _masuk(),
                  decoration: nootInput(
                    'Kata sandi',
                    prefix: const Icon(Icons.lock_outline_rounded),
                    suffix: IconButton(
                      tooltip: _sembunyikan
                          ? 'Tampilkan kata sandi'
                          : 'Sembunyikan kata sandi',
                      icon: Icon(
                        _sembunyikan
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _sembunyikan = !_sembunyikan),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton(onPressed: _masuk, child: const Text('Masuk')),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(child: Divider(color: NootColors.line)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau',
                        style: TextStyle(color: NootColors.muted),
                      ),
                    ),
                    Expanded(child: Divider(color: NootColors.line)),
                  ],
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: _masuk,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'G',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Masuk dengan Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Mode demo: tombol masuk langsung membuka beranda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NootColors.muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
