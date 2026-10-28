import 'package:flutter/material.dart';

import '../data/notes_store.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/noot_widgets.dart';
import 'add_note_screen.dart';

/// Halaman 5: detail catatan.
class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.noteId});
  final String noteId;

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NootColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus catatan?'),
        content: Text('"${note.title}" akan dihapus dan tidak bisa dikembalikan.'),
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
    if (ok == true && context.mounted) {
      NotesStore.instance.remove(note.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NotesStore.instance,
      builder: (context, _) {
        final note = NotesStore.instance.byId(noteId);
        if (note == null) return const Scaffold();
        final swatch = noteSwatches[note.colorIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Catatan'),
            actions: [
              IconButton(
                tooltip: 'Ubah catatan',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
                ),
              ),
              IconButton(
                tooltip: 'Hapus catatan',
                icon: const Icon(Icons.delete_outline_rounded, color: NootColors.danger),
                onPressed: () => _confirmDelete(context, note),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: swatch.tint,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: swatch.solid,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              note.category,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: NootColors.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            PriorityPill(note.priority),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 15, color: NootColors.muted),
                            const SizedBox(width: 6),
                            Text(
                              '${formatTanggal(note.createdAt)}  ·  ${formatJam(note.createdAt)}',
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: NootColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (note.content.isEmpty)
                    const Text(
                      'Catatan ini belum memiliki isi. Ketuk ikon pensil untuk menulis.',
                      style: TextStyle(color: NootColors.muted, fontSize: 15, height: 1.5),
                    )
                  else
                    Text(
                      note.content,
                      style: const TextStyle(fontSize: 16.5, height: 1.65),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
