import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../models/note.dart';
import '../services/note_store.dart';
import '../theme.dart';

/// Form catatan. Dipakai untuk menambah, dan untuk mengubah bila [note] diisi.
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _isi;
  String? _kategori;
  bool _kategoriGalat = false;
  int _warna = 0;
  int _prioritas = 1;

  bool get _mengubah => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _judul = TextEditingController(text: n?.title ?? '');
    _isi = TextEditingController(text: n?.content ?? '');
    _kategori = n?.category;
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
    final valid = _form.currentState!.validate();
    setState(() => _kategoriGalat = _kategori == null);
    if (!valid || _kategori == null) return;

    final sekarang = DateTime.now();
    final lama = widget.note;
    final note = Note(
      id: lama?.id ?? sekarang.microsecondsSinceEpoch.toString(),
      title: _judul.text.trim(),
      content: _isi.text.trim(),
      category: _kategori!,
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
    return Scaffold(
      appBar: AppBar(title: Text(_mengubah ? 'Ubah Catatan' : 'Tambah Catatan')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label('Judul Catatan'),
                      TextFormField(
                        controller: _judul,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(60)],
                        decoration: nootInput('Masukkan judul catatan'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Judul wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      const _Label('Isi Catatan'),
                      TextFormField(
                        controller: _isi,
                        minLines: 5,
                        maxLines: 8,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: nootInput('Tulis catatanmu di sini...'),
                      ),
                      const SizedBox(height: 20),
                      const _Label('Kategori'),
                      _PilihKategori(
                        nilai: _kategori,
                        galat: _kategoriGalat,
                        onChanged: (v) => setState(() {
                          _kategori = v;
                          _kategoriGalat = false;
                        }),
                      ),
                      if (_kategoriGalat)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            'Pilih satu kategori',
                            style: TextStyle(
                              color: NootColors.danger,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const _Label('Warna'),
                      Wrap(
                        spacing: 14,
                        children: [
                          for (var i = 0; i < kTones.length; i++)
                            _TitikWarna(
                              tone: kTones[i],
                              terpilih: i == _warna,
                              onTap: () => setState(() => _warna = i),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _Label('Prioritas'),
                      Row(
                        children: [
                          for (var i = 0; i < kPrioritasNama.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            Expanded(
                              child: _PilihPrioritas(
                                label: kPrioritasNama[i],
                                terpilih: i == _prioritas,
                                onTap: () => setState(() => _prioritas = i),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: FilledButton(
                onPressed: _simpan,
                child: Text(_mengubah ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        teks,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PilihKategori extends StatelessWidget {
  const _PilihKategori({
    required this.nilai,
    required this.galat,
    required this.onChanged,
  });

  final String? nilai;
  final bool galat;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: galat ? NootColors.danger : NootColors.line,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: nilai,
          isExpanded: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          hint: const Text(
            'Pilih kategori',
            style: TextStyle(color: NootColors.muted),
          ),
          items: [
            for (final k in kKategori)
              DropdownMenuItem(
                value: k,
                child: Row(
                  children: [
                    Icon(kIkonKategori[k], size: 20, color: NootColors.primary),
                    const SizedBox(width: 10),
                    Text(k),
                  ],
                ),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TitikWarna extends StatelessWidget {
  const _TitikWarna({
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(tone.bg, tone.accent, 0.35),
            border: Border.all(
              color: terpilih ? tone.accent : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: terpilih
              ? Icon(Icons.check_rounded, color: tone.accent, size: 22)
              : null,
        ),
      ),
    );
  }
}

class _PilihPrioritas extends StatelessWidget {
  const _PilihPrioritas({
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: terpilih ? NootColors.primary : NootColors.line,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: terpilih ? Colors.white : NootColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
