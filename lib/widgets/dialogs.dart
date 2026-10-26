import 'package:flutter/material.dart';

import '../theme.dart';

Future<bool?> konfirmasiHapus(BuildContext context, String judul) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Hapus catatan?'),
      content: Text('"$judul" akan dihapus dari perangkat ini.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: NootColors.danger),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
}
