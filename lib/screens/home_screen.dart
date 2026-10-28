import 'package:flutter/material.dart';

import '../data/notes_store.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/noot_widgets.dart';
import 'add_note_screen.dart';
import 'note_detail_screen.dart';

/// Halaman 3: beranda, daftar catatan.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _filters = ['Semua', 'Penting', 'Pribadi', 'Kerja'];

  final _store = NotesStore.instance;
  final _search = TextEditingController();
  String _filter = 'Semua';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Note> _visible() {
    final q = _search.text.trim().toLowerCase();
    return _store.notes.where((n) {
      final okFilter = switch (_filter) {
        'Semua' => true,
        'Penting' => n.priority == Priority.tinggi,
        _ => n.category == _filter,
      };
      final okQuery = q.isEmpty ||
          n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q);
      return okFilter && okQuery;
    }).toList();
  }

  void _openAdd() => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddNoteScreen()),
      );

  void _openDetail(Note n) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NoteDetailScreen(noteId: n.id)),
      );

  void _comingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Halaman ini belum tersedia di versi ini.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        tooltip: 'Tambah catatan',
        backgroundColor: NootColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      bottomNavigationBar: _BottomBar(onOther: _comingSoon),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final all = _store.notes;
            final shown = _visible();
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
              children: [
                Row(
                  children: const [
                    NootLogo(size: 34),
                    SizedBox(width: 10),
                    Text(
                      'Noot',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Halo, $kNamaPengguna',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: NootColors.muted,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Apa yang ingin kamu catat hari ini?',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari catatan',
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => setState(_search.clear),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _FilterChip(
                      label: _filters[i],
                      selected: _filters[i] == _filter,
                      onTap: () => setState(() => _filter = _filters[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _SummaryCard(notes: all),
                const SizedBox(height: 26),
                Row(
                  children: [
                    const Text(
                      'Catatan terbaru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      '${shown.length} catatan',
                      style: const TextStyle(color: NootColors.muted, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (shown.isEmpty)
                  _EmptyState(
                    searching: _search.text.trim().isNotEmpty,
                    filter: _filter,
                    onAdd: _openAdd,
                  )
                else
                  for (var i = 0; i < shown.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(shown[i].id),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 280 + i * 60),
                        curve: Curves.easeOutCubic,
                        builder: (context, t, child) => Opacity(
                          opacity: t,
                          child: Transform.translate(
                            offset: Offset(0, 14 * (1 - t)),
                            child: child,
                          ),
                        ),
                        child: NoteCard(
                          note: shown[i],
                          onTap: () => _openDetail(shown[i]),
                        ),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: selected ? NootColors.blue : NootColors.surface,
        borderRadius: BorderRadius.circular(99),
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : NootColors.muted,
                ),
              ),
            ),
          ),
        ),
      );
}

/// Ringkasan dihitung dari daftar catatan yang ada, bukan angka tetap.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.notes});
  final List<Note> notes;

  int _count(Priority p) => notes.where((n) => n.priority == p).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: NootColors.blue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Semua catatanmu',
            style: TextStyle(color: Color(0xFFD5E1FF), fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            '${notes.length} catatan',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Stat(count: _count(Priority.tinggi), label: 'Tinggi'),
              _Stat(count: _count(Priority.sedang), label: 'Sedang'),
              _Stat(count: _count(Priority.rendah), label: 'Rendah'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Prioritas ${label.toLowerCase()}',
              style: const TextStyle(color: Color(0xFFD5E1FF), fontSize: 12.5),
            ),
          ],
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.searching,
    required this.filter,
    required this.onAdd,
  });
  final bool searching;
  final String filter;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final title = searching
        ? 'Tidak ada catatan yang cocok'
        : 'Belum ada catatan di "$filter"';
    final body = searching
        ? 'Coba kata kunci lain, atau ganti kategori di atas.'
        : 'Tulis catatan pertamamu, nanti muncul di sini.';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: NootColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: NootColors.muted, height: 1.45)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: NootColors.blue,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            child: const Text('Buat catatan'),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onOther});
  final VoidCallback onOther;

  @override
  Widget build(BuildContext context) => Container(
        color: NootColors.surface,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                const _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Beranda',
                  active: true,
                ),
                _NavItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Arsip',
                  onTap: onOther,
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  onTap: onOther,
                ),
              ],
            ),
          ),
        ),
      );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? NootColors.blue : const Color(0xFF7D8BA3);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
