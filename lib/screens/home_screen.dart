import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';
import '../utils/format.dart';
import '../widgets/choice_tab.dart';
import '../widgets/dialogs.dart';
import '../widgets/noot_logo.dart';
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

  bool get _menyaring => _kategori != 'Semua' || _cari.text.trim().isNotEmpty;

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

  void _reset() {
    setState(() {
      _cari.clear();
      _kategori = 'Semua';
    });
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

  Future<void> _menu(Note note) async {
    final aksi = await tampilMenuCatatan(context, note.title);
    if (!mounted) return;
    if (aksi == AksiCatatan.ubah) _ubah(note);
    if (aksi == AksiCatatan.hapus) _hapus(note);
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
            onPressed: () => _store.add(note),
          ),
        ),
      );
  }

  /// Membagi kartu ke dua kolom. Setiap kartu masuk ke kolom yang lebih pendek,
  /// dengan tinggi diperkirakan dari panjang judul dan isinya.
  Widget _susunan(List<Note> daftar) {
    final kiri = <Widget>[];
    final kanan = <Widget>[];
    var tinggiKiri = 0.0;
    var tinggiKanan = 0.0;

    for (final note in daftar) {
      final taksiran = 84 +
          (note.title.length > 22 ? 24 : 0) +
          (note.content.length > 220 ? 220 : note.content.length) * 0.55;
      final kartu = Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: NoteCard(
          note: note,
          onTap: () => _buka(note),
          onLongPress: () => _menu(note),
        ),
      );
      if (tinggiKiri <= tinggiKanan) {
        kiri.add(kartu);
        tinggiKiri += taksiran;
      } else {
        kanan.add(kartu);
        tinggiKanan += taksiran;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: kiri)),
        const SizedBox(width: 12),
        Expanded(child: Column(children: kanan)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final kategori = ['Semua', ...kKategori];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        backgroundColor: NootColors.yellow,
        foregroundColor: NootColors.navy,
        elevation: 2,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: const Icon(Icons.edit_outlined),
        label: Text(
          'Catatan baru',
          style: nootText(17, weight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final daftar = _daftar();
            final total = _store.notes.length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 112),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatHariTanggal(DateTime.now()),
                            style: nootText(
                              15,
                              style: FontStyle.italic,
                              color: NootColors.muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Catatan',
                            style: nootText(
                              42,
                              weight: FontWeight.w700,
                              height: 1.05,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const NootLogo(size: 44, radius: 10),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _cari,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  style: nootText(17),
                  decoration: nootInput(
                    'Cari judul atau isi catatan',
                    prefix: const Icon(
                      Icons.search_rounded,
                      color: NootColors.muted,
                    ),
                    suffix: _cari.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(_cari.clear),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kategori.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => ChoiceTab(
                      label: kategori[i],
                      selected: kategori[i] == _kategori,
                      onTap: () => setState(() => _kategori = kategori[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _menyaring
                            ? '${daftar.length} dari $total catatan'
                            : '$total catatan',
                        style: nootText(
                          15,
                          style: FontStyle.italic,
                          color: NootColors.muted,
                        ),
                      ),
                    ),
                    PopupMenuButton<_Urutan>(
                      tooltip: 'Urutkan catatan',
                      initialValue: _urutan,
                      onSelected: (v) => setState(() => _urutan = v),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _Urutan.terbaru,
                          child: Text('Terbaru', style: nootText(16)),
                        ),
                        PopupMenuItem(
                          value: _Urutan.prioritas,
                          child: Text('Prioritas tertinggi', style: nootText(16)),
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _urutan == _Urutan.terbaru
                                  ? 'Terbaru'
                                  : 'Prioritas',
                              style: nootText(15, weight: FontWeight.w700),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (daftar.isEmpty)
                  _Kosong(adaCatatan: total > 0, onReset: _reset)
                else
                  _susunan(daftar),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong({required this.adaCatatan, required this.onReset});

  final bool adaCatatan;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            adaCatatan ? 'Tidak ada catatan yang cocok' : 'Belum ada catatan',
            style: nootText(26, weight: FontWeight.w700, height: 1.15),
          ),
          const SizedBox(height: 8),
          Text(
            adaCatatan
                ? 'Coba kata kunci lain, atau tampilkan semua kategori.'
                : 'Tekan Catatan baru di kanan bawah untuk menulis yang pertama.',
            style: nootText(17, color: NootColors.muted, height: 1.4),
          ),
          if (adaCatatan) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onReset, child: const Text('Reset pencarian')),
          ],
        ],
      ),
    );
  }
}
