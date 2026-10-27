import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../theme.dart';
import '../utils/format.dart';

/// Kartu catatan: bidang warna datar. Tinggi kartu mengikuti panjang isi,
/// dan catatan berprioritas tinggi mendapat sudut kanan atas yang terlipat.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final tone = toneOf(note.tone);
    final tinggi = note.priority >= 2;

    return Material(
      color: tone.bg,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: tinggi ? 18 : 0),
                    child: Text(
                      note.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: nootText(20, weight: FontWeight.w700, height: 1.18),
                    ),
                  ),
                  if (note.content.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      note.content,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: nootText(15.5, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    '${note.category} · ${tanggalRingkas(note.createdAt, DateTime.now())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: nootText(14, style: FontStyle.italic),
                  ),
                ],
              ),
            ),
            if (tinggi)
              Positioned(
                top: 0,
                right: 0,
                child: Semantics(
                  label: 'Prioritas tinggi',
                  child: CustomPaint(
                    size: const Size(24, 24),
                    painter: _SudutTerlipat(tone.fold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Sudut kanan atas yang terlipat ke dalam. Bagian yang terpotong memakai warna
/// latar halaman, jadi Beranda harus berlatar NootColors.ground.
class _SudutTerlipat extends CustomPainter {
  _SudutTerlipat(this.fold);

  final Color fold;

  @override
  void paint(Canvas canvas, Size size) {
    final potong = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(potong, Paint()..color = NootColors.ground);

    final lipat = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(lipat, Paint()..color = fold);
  }

  @override
  bool shouldRepaint(covariant _SudutTerlipat oldDelegate) =>
      oldDelegate.fold != fold;
}
