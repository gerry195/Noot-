import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';
import '../widgets/choice_tab.dart';

/// Form catatan. Dipakai untuk menambah, dan untuk mengubah bila [note] diisi.
/// Kotak judul dan isi langsung berwarna sesuai pilihan Warna, jadi yang tampak
/// saat menulis sama dengan kartu di Beranda.
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late final TextEditingController _judul;
  late final TextEditingController _isi;
  String _kategori = kKategoriAwal;
  int _warna = 0;
  int _prioritas = 1;
  bool _judulGalat = false;

  bool get _mengubah => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _judul = TextEditingController(text: n?.title ?? '');
    _isi = TextEditingController(text: n?.content ?? '');
    _kategori = n?.category ?? kKategoriAwal;
    _warna = n?.tone ?? 0;
    _prioritas = n?.priority ?? 1;
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final judul = _judul.text.trim();
    if (judul.isEmpty) {
      setState(() => _judulGalat = true);
      return;
    }

    final sekarang = DateTime.now();
    final lama = widget.note;
    final note = Note(
      id: lama?.id ?? sekarang.microsecondsSinceEpoch.toString(),
      title: judul,
      content: _isi.text.trim(),
      category: _kategori,
      tone: _warna,
      priority: _prioritas,
      createdAt: lama?.createdAt ?? sekarang,
    );

    if (lama == null) {
      await NoteStore.instance.add(note);
    } else {
      await NoteStore.instance.update(note);
    }
    if (!mounted) return;
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final tone = toneOf(_warna);

    return Scaffold(
      appBar: AppBar(title: Text(_mengubah ? 'Ubah Catatan' : 'Tambah Catatan')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        color: tone.bg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Judul catatan',
                            style: nootText(14.5, style: FontStyle.italic),
                          ),
                          TextField(
                            controller: _judul,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(60),
                            ],
                            onChanged: (_) {
                              if (_judulGalat) {
                                setState(() => _judulGalat = false);
                              }
                            },
                            style: nootText(
                              26,
                              weight: FontWeight.w700,
                              height: 1.2,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              hintText: 'Masukkan judul catatan',
                              hintStyle: nootText(
                                26,
                                weight: FontWeight.w700,
                                height: 1.2,
                                color: NootColors.hint,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Isi catatan',
                            style: nootText(14.5, style: FontStyle.italic),
                          ),
                          TextField(
                            controller: _isi,
                            minLines: 7,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            style: nootText(18, height: 1.5),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              hintText: 'Tulis catatanmu di sini',
                              hintStyle: nootText(
                                18,
                                height: 1.5,
                                color: NootColors.hint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_judulGalat)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Judul wajib diisi.',
                          style: nootText(15, color: NootColors.danger),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const _Judul('Kategori'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final k in kKategori)
                          ChoiceTab(
                            label: k,
                            selected: k == _kategori,
                            onTap: () => setState(() => _kategori = k),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _Judul('Warna'),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (var i = 0; i < kTones.length; i++)
                          _Swatch(
                            tone: kTones[i],
                            terpilih: i == _warna,
                            onTap: () => setState(() => _warna = i),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _Judul('Prioritas'),
                    Row(
                      children: [
                        for (var i = 0; i < kPrioritasNama.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceTab(
                              label: kPrioritasNama[i],
                              selected: i == _prioritas,
                              onTap: () => setState(() => _prioritas = i),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Prioritas tinggi diberi sudut terlipat di daftar.',
                      style: nootText(
                        14.5,
                        style: FontStyle.italic,
                        color: NootColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: FilledButton(
                onPressed: _simpan,
                child: Text(_mengubah ? 'Simpan perubahan' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Judul extends StatelessWidget {
  const _Judul(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(teks, style: nootText(17, weight: FontWeight.w700)),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.tone,
    required this.terpilih,
    required this.onTap,
  });

  final NoteTone tone;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: terpilih,
      label: 'Warna ${tone.name}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: tone.bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: terpilih ? NootColors.navy : NootColors.line,
              width: terpilih ? 2.5 : 1,
            ),
          ),
          child: terpilih
              ? const Icon(Icons.check_rounded, color: NootColors.navy, size: 24)
              : null,
        ),
      ),
    );
  }
}
