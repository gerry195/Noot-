import 'package:flutter/material.dart';

import '../theme.dart';

/// Pilihan tunggal berbentuk kotak: dipakai untuk filter kategori di Beranda
/// serta pilihan kategori dan prioritas di form.
class ChoiceTab extends StatelessWidget {
  const ChoiceTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? NootColors.navy : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: selected ? NootColors.navy : NootColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: nootText(
                16,
                color: selected ? Colors.white : NootColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
