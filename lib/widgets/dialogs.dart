import 'package:flutter/material.dart';

import '../theme.dart';

enum AksiCatatan { ubah, hapus }

Future<bool?> konfirmasiHapus(BuildContext context, String judul) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text('Hapus catatan?', style: nootText(22, weight: FontWeight.w700)),
      content: Text(
        '"$judul" akan dihapus dari perangkat ini.',
        style: nootText(17, height: 1.4),
      ),
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

/// Menu yang muncul saat kartu catatan ditekan lama.
Future<AksiCatatan?> tampilMenuCatatan(BuildContext context, String judul) {
  return showModalBottomSheet<AksiCatatan>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(
              judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: nootText(19, weight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text('Ubah', style: nootText(17)),
            onTap: () => Navigator.pop(ctx, AksiCatatan.ubah),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: NootColors.danger,
            ),
            title: Text(
              'Hapus',
              style: nootText(17, color: NootColors.danger),
            ),
            onTap: () => Navigator.pop(ctx, AksiCatatan.hapus),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
