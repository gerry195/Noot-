import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';
import 'detail_screen.dart';

enum _Urutan { terbaru, prioritas }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = NoteStore.instance;
  final _cari = TextEditingController();
  String _kategori = 'Semua';
  _Urutan _urutan = _Urutan.terbaru;

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  List<Note> _daftar() {
    final kata = _cari.text.trim().toLowerCase();
    final hasil = _store.notes.where((n) {
      final cocokKategori = _kategori == 'Semua' || n.category == _kategori;
      final cocokKata = kata.isEmpty ||
          n.title.toLowerCase().contains(kata) ||
          n.content.toLowerCase().contains(kata);
      return cocokKategori && cocokKata;
    }).toList();

    if (_urutan == _Urutan.prioritas) {
      hasil.sort((a, b) {
        final p = b.priority.compareTo(a.priority);
        return p != 0 ? p : b.createdAt.compareTo(a.createdAt);
      });
    }
    return hasil;
  }

  Future<void> _tambah() async {
    final messenger = ScaffoldMessenger.of(context);
    final tersimpan = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (tersimpan != null) _pesan(messenger, 'Catatan disimpan');
  }

  Future<void> _ubah(Note note) async {
    final messenger = ScaffoldMessenger.of(context);
    final tersimpan = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
    );
    if (tersimpan != null) _pesan(messenger, 'Perubahan disimpan');
  }

  Future<void> _buka(Note note) async {
    final messenger = ScaffoldMessenger.of(context);
    final dihapus = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => DetailScreen(noteId: note.id)),
    );
    if (dihapus != null) _pesanHapus(messenger, dihapus);
  }

  Future<void> _hapus(Note note) async {
    final yakin = await konfirmasiHapus(context, note.title);
    if (yakin != true || !mounted) return;
    await _store.remove(note.id);
    if (!mounted) return;
    _pesanHapus(ScaffoldMessenger.of(context), note);
  }

  void _pesan(ScaffoldMessengerState messenger, String teks) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(teks)));
  }

  void _pesanHapus(ScaffoldMessengerState messenger, Note note) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${note.title}" dihapus'),
          action: SnackBarAction(
            label: 'Urungkan',
            textColor: const Color(0xFF9CC2FF),
            onPressed: () => _store.add(note),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final kategori = ['Semua', ...kKategori];

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final daftar = _daftar();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Sapaan(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cari,
                          onChanged: (_) => setState(() {}),
                          decoration: nootInput(
                            'Cari catatan...',
                            prefix: const Icon(Icons.search_rounded),
                            suffix: _cari.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Hapus pencarian',
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () =>
                                        setState(() => _cari.clear()),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      PopupMenuButton<_Urutan>(
                        tooltip: 'Urutkan catatan',
                        color: Colors.white,
                        onSelected: (v) => setState(() => _urutan = v),
                        itemBuilder: (_) => [
                          CheckedPopupMenuItem(
                            value: _Urutan.terbaru,
                            checked: _urutan == _Urutan.terbaru,
                            child: const Text('Terbaru'),
                          ),
                          CheckedPopupMenuItem(
                            value: _Urutan.prioritas,
                            checked: _urutan == _Urutan.prioritas,
                            child: const Text('Prioritas tertinggi'),
                          ),
                        ],
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: NootColors.line),
                          ),
                          child: const Icon(Icons.tune_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: kategori.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _Chip(
                      label: kategori[i],
                      terpilih: kategori[i] == _kategori,
                      onTap: () => setState(() => _kategori = kategori[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: daftar.isEmpty
                      ? _Kosong(adaCatatan: _store.notes.isNotEmpty)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: daftar.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final note = daftar[i];
                            return NoteCard(
                              note: note,
                              onTap: () => _buka(note),
                              onEdit: () => _ubah(note),
                              onDelete: () => _hapus(note),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        tooltip: 'Tambah catatan',
        backgroundColor: NootColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE9FF),
        onDestinationSelected: (i) {
          if (i == 0) return;
          _pesan(
            ScaffoldMessenger.of(context),
            i == 1
                ? 'Arsip belum tersedia di versi ini'
                : 'Profil belum tersedia di versi ini',
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Arsip',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _Sapaan extends StatelessWidget {
  const _Sapaan();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${salam(DateTime.now())},',
                      style: const TextStyle(
                        fontSize: 15,
                        color: NootColors.muted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.waving_hand_rounded,
                      size: 16,
                      color: Color(0xFFE0A100),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  kUserName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Apa yang mau kamu catat hari ini?',
                  style: TextStyle(fontSize: 13.5, color: NootColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFDCE9FF),
            child: Text(
              kUserName.isEmpty ? 'N' : kUserName[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: NootColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.terpilih,
    required this.onTap,
  });

  final String label;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: terpilih ? NootColors.primary : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: terpilih ? NootColors.primary : NootColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: terpilih ? Colors.white : NootColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong({required this.adaCatatan});

  final bool adaCatatan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              adaCatatan ? Icons.search_off_rounded : Icons.edit_note_rounded,
              size: 72,
              color: NootColors.primary.withAlpha(110),
            ),
            const SizedBox(height: 12),
            Text(
              adaCatatan ? 'Catatan tidak ditemukan' : 'Belum ada catatan',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              adaCatatan
                  ? 'Coba kata kunci atau kategori lain.'
                  : 'Ketuk tombol + untuk mulai mencatat.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: NootColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
