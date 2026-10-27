import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';
import 'add_note_screen.dart';

/// Menampilkan isi satu catatan di atas bidang warna catatan itu. Saat catatan
/// dihapus, halaman menutup dengan catatan tersebut sebagai hasil, supaya
/// Beranda bisa menawarkan "Urungkan".
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.noteId});

  final String noteId;

  Future<void> _ubah(BuildContext context, Note note) async {
    final messenger = ScaffoldMessenger.of(context);
    final tersimpan = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
    );
    if (tersimpan != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Perubahan disimpan')));
    }
  }

  Future<void> _hapus(BuildContext context, Note note) async {
    final yakin = await konfirmasiHapus(context, note.title);
    if (yakin != true || !context.mounted) return;
    await NoteStore.instance.remove(note.id);
    if (!context.mounted) return;
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NoteStore.instance,
      builder: (context, _) {
        final note = NoteStore.instance.byId(noteId);
        if (note == null) return const Scaffold();

        final tone = toneOf(note.tone);
        final prioritas = note.priority.clamp(0, 2).toInt();

        return Scaffold(
          backgroundColor: tone.bg,
          appBar: AppBar(
            backgroundColor: tone.bg,
            title: const Text('Detail Catatan'),
            actions: [
              IconButton(
                tooltip: 'Ubah catatan',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _ubah(context, note),
              ),
              IconButton(
                tooltip: 'Hapus catatan',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => _hapus(context, note),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: nootText(
                      36,
                      weight: FontWeight.w700,
                      height: 1.12,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${note.category} · Prioritas ${kPrioritasNama[prioritas].toLowerCase()}',
                    style: nootText(17, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatTanggal(note.createdAt)}, ${formatJam(note.createdAt)}',
                    style: nootText(16, style: FontStyle.italic),
                  ),
                  const SizedBox(height: 28),
                  if (note.content.isEmpty) ...[
                    Text(
                      'Catatan ini belum punya isi.',
                      style: nootText(18, style: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _ubah(context, note),
                      child: const Text('Tulis isi catatan'),
                    ),
                  ] else
                    SelectableText(
                      note.content,
                      style: nootText(19, height: 1.65),
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
