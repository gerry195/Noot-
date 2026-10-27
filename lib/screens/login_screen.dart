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
    const padAtas = 28.0;
    const padBawah = 24.0;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            // Logo di atas, formulir di bawah. Saat keyboard muncul layar bisa digulir.
            final tinggiMin = c.maxHeight > padAtas + padBawah
                ? c.maxHeight - padAtas - padBawah
                : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, padAtas, 24, padBawah),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: tinggiMin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NootLogo(size: 60, radius: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          'Masuk untuk melanjutkan',
                          style: nootText(
                            36,
                            weight: FontWeight.w700,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Catatan harianmu tersimpan di perangkat ini.',
                          style: nootText(
                            18,
                            color: NootColors.muted,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const _Label('Email'),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: nootText(17),
                          decoration: nootInput('nama@email.com'),
                        ),
                        const SizedBox(height: 16),
                        const _Label('Kata sandi'),
                        TextField(
                          controller: _sandi,
                          obscureText: _sembunyikan,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _masuk(),
                          style: nootText(17),
                          decoration: nootInput(
                            'Kata sandi',
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
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _masuk,
                          child: const Text('Masuk'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _masuk,
                          child: const Text('Lanjut dengan Google'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Tampilan masuk ini belum terhubung ke akun mana pun. '
                          'Kedua tombol langsung membuka catatanmu.',
                          style: nootText(
                            14.5,
                            style: FontStyle.italic,
                            color: NootColors.muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(teks, style: nootText(15.5, weight: FontWeight.w700)),
    );
  }
}
