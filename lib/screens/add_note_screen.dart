import 'package:flutter/material.dart';

import '../data/notes_store.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/noot_widgets.dart';

/// Halaman 4: tambah catatan. Dipakai juga untuk mengedit bila [note] diisi.
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});
  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  String? _category;
  late int _colorIndex;
  late Priority _priority;

  bool get _editing => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _title = TextEditingController(text: n?.title ?? '');
    _content = TextEditingController(text: n?.content ?? '');
    _category = n?.category;
    _colorIndex = n?.colorIndex ?? 0;
    _priority = n?.priority ?? Priority.sedang;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final store = NotesStore.instance;
    final title = _title.text.trim();
    final content = _content.text.trim();
    final category = _category!;
    if (_editing) {
      store.update(
        widget.note!,
        title: title,
        content: content,
        category: category,
        colorIndex: _colorIndex,
        priority: _priority,
      );
    } else {
      store.add(
        title: title,
        content: content,
        category: category,
        colorIndex: _colorIndex,
        priority: _priority,
      );
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(_editing ? 'Perubahan disimpan' : 'Catatan disimpan')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Ubah Catatan' : 'Tambah Catatan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Label('Judul catatan'),
                TextFormField(
                  controller: _title,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'Masukkan judul catatan'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Judul tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                const _Label('Isi catatan'),
                TextFormField(
                  controller: _content,
                  minLines: 5,
                  maxLines: 9,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(hintText: 'Tulis catatan Anda di sini...'),
                ),
                const SizedBox(height: 20),
                const _Label('Kategori'),
                DropdownButtonFormField<String>(
                  value: _category,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(14),
                  dropdownColor: NootColors.surface,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  hint: const Text('Pilih kategori'),
                  items: [
                    for (final c in noteCategories)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) => v == null ? 'Pilih satu kategori' : null,
                ),
                const SizedBox(height: 20),
                const _Label('Warna'),
                Row(
                  children: [
                    for (var i = 0; i < noteSwatches.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _SwatchDot(
                          swatch: noteSwatches[i],
                          selected: i == _colorIndex,
                          onTap: () => setState(() => _colorIndex = i),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const _Label('Prioritas'),
                _PrioritySelector(
                  value: _priority,
                  onChanged: (p) => setState(() => _priority = p),
                ),
                const SizedBox(height: 32),
                PrimaryButton(label: 'Simpan', onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      );
}

class _SwatchDot extends StatelessWidget {
  const _SwatchDot({required this.swatch, required this.selected, required this.onTap});
  final NoteSwatch swatch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: 'Warna ${swatch.name}',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: swatch.solid,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? NootColors.ink : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : null,
          ),
        ),
      );
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.value, required this.onChanged});
  final Priority value;
  final ValueChanged<Priority> onChanged;

  @override
  Widget build(BuildContext context) {
    // Urutan tampil mengikuti rancangan: Rendah, Sedang, Tinggi.
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NootColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final p in Priority.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: p == value ? NootColors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: p == value ? Colors.white : NootColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
