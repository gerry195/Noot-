import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../theme.dart';
import '../utils/format.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tone = toneOf(note.tone);
    final prioritas = note.priority.clamp(0, 2).toInt();

    return Material(
      color: tone.bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  kIkonKategori[note.category] ?? Icons.notes_rounded,
                  color: tone.accent,
                ),
              ),
              const SizedBox(width: 12),
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            formatTanggal(note.createdAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: NootColors.muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: kPrioritasWarna[prioritas],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          kPrioritasNama[prioritas],
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: NootColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Menu catatan',
                icon: const Icon(Icons.more_vert_rounded, color: NootColors.muted),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'ubah') onEdit();
                  if (value == 'hapus') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'ubah', child: Text('Ubah')),
                  PopupMenuItem(
                    value: 'hapus',
                    child: Text(
                      'Hapus',
                      style: TextStyle(color: NootColors.danger),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
