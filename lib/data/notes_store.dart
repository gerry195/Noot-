import 'package:flutter/foundation.dart';

import '../models/note.dart';

/// Nama untuk sapaan di Beranda.
const String kNamaPengguna = 'Gerry';

/// Penyimpanan sementara di memori, hanya untuk tahap UI.
/// Saat database ditambahkan, cukup ganti isi class ini; layar tidak perlu diubah.
class NotesStore extends ChangeNotifier {
  NotesStore._();
  static final NotesStore instance = NotesStore._();

  // Data contoh agar tampilan terlihat utuh. Hapus saat database sudah terpasang.
  final List<Note> _notes = [
    Note(
      id: 's1',
      title: 'Ide Aplikasi',
      content:
          'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas. Aplikasi ini digunakan untuk mencatat ide, rencana, dan hal penting sehari-hari.',
      category: 'Ide',
      colorIndex: 2,
      priority: Priority.tinggi,
      createdAt: DateTime(2026, 10, 19, 9, 30),
    ),
    Note(
      id: 's2',
      title: 'Rencana Mingguan',
      content: 'Selesaikan tugas Flutter, baca materi perancangan, olahraga dua kali.',
      category: 'Pribadi',
      colorIndex: 1,
      priority: Priority.sedang,
      createdAt: DateTime(2026, 10, 18, 20, 15),
    ),
    Note(
      id: 's3',
      title: 'Catatan Kuliah',
      content: 'Fase perancangan: wireframe, mockup, lalu prototipe. Tiap tahap diuji dulu sebelum lanjut.',
      category: 'Kuliah',
      colorIndex: 4,
      priority: Priority.tinggi,
      createdAt: DateTime(2026, 10, 17, 13, 0),
    ),
    Note(
      id: 's4',
      title: 'Hal yang Perlu Dibeli',
      content: 'Buku catatan, pulpen, kabel charger cadangan.',
      category: 'Pribadi',
      colorIndex: 3,
      priority: Priority.rendah,
      createdAt: DateTime(2026, 10, 16, 8, 45),
    ),
    Note(
      id: 's5',
      title: 'Jurnal Harian',
      content: 'Hari ini mulai merancang tampilan aplikasi catatan. Warna biru dipilih karena terasa tenang.',
      category: 'Pribadi',
      colorIndex: 0,
      priority: Priority.sedang,
      createdAt: DateTime(2026, 10, 15, 21, 30),
    ),
  ];

  List<Note> get notes => List.unmodifiable(_notes);

  Note? byId(String id) {
    for (final n in _notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  void add({
    required String title,
    required String content,
    required String category,
    required int colorIndex,
    required Priority priority,
  }) {
    _notes.insert(
      0,
      Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        content: content,
        category: category,
        colorIndex: colorIndex,
        priority: priority,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void update(
    Note note, {
    required String title,
    required String content,
    required String category,
    required int colorIndex,
    required Priority priority,
  }) {
    note
      ..title = title
      ..content = content
      ..category = category
      ..colorIndex = colorIndex
      ..priority = priority;
    notifyListeners();
  }

  void remove(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
