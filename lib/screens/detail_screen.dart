import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';
import 'add_note_screen.dart';

/// Menampilkan isi satu catatan. Menutup halaman dengan catatan yang dihapus
/// sebagai hasil, supaya Beranda bisa menawarkan "Urungkan".
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
          appBar: AppBar(
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
                color: NootColors.danger,
                onPressed: () => _hapus(context, note),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tone.bg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(170),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            kIkonKategori[note.category] ?? Icons.notes_rounded,
                            color: tone.accent,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _Pil(
                                    teks: note.category,
                                    warna: tone.accent,
                                  ),
                                  _Pil(
                                    teks: 'Prioritas ${kPrioritasNama[prioritas]}',
                                    warna: kPrioritasWarna[prioritas],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: NootColors.muted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTanggal(note.createdAt),
                        style: const TextStyle(color: NootColors.muted),
                      ),
                      const SizedBox(width: 18),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 18,
                        color: NootColors.muted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatJam(note.createdAt),
                        style: const TextStyle(color: NootColors.muted),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, color: NootColors.line),
                  ),
                  if (note.content.isEmpty)
                    const Text(
                      'Tidak ada isi catatan.',
                      style: TextStyle(
                        color: NootColors.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    SelectableText(
                      note.content,
                      style: const TextStyle(fontSize: 16, height: 1.6),
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

class _Pil extends StatelessWidget {
  const _Pil({required this.teks, required this.warna});

  final String teks;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(190),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            teks,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
