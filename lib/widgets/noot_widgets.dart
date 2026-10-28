import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';

class NootLogo extends StatelessWidget {
  const NootLogo({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/noot_logo.png',
        width: size,
        height: size,
        semanticLabel: 'Logo Noot',
      );
}

class PriorityPill extends StatelessWidget {
  const PriorityPill(this.priority, {super.key});
  final Priority priority;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: priority.bg,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          priority.label,
          style: TextStyle(
            color: priority.fg,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.onTap});
  final Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = noteSwatches[note.colorIndex];
    return Material(
      color: swatch.tint,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${note.category}  ·  ${formatTanggal(note.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: NootColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              PriorityPill(note.priority),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol utama: datar, satu warna, radius tetap.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: NootColors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          child: Text(label),
        ),
      );
}
