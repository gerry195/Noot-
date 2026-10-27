import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// Penyimpanan catatan di perangkat. Di web, data tersimpan di localStorage browser.
class NoteStore extends ChangeNotifier {
  NoteStore._();

  static final NoteStore instance = NoteStore._();
  static const _key = 'noot.notes.v1';

  late SharedPreferences _prefs;
  List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  Note? byId(String id) {
    for (final n in _notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_key);
    if (raw == null) {
      _notes = _contoh();
      await _simpan();
      return;
    }
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      _notes = data
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _notes = [];
    }
    _urutkan();
  }

  Future<void> add(Note note) async {
    _notes = [..._notes, note];
    await _simpanDanBeritahu();
  }

  Future<void> update(Note note) async {
    _notes = [for (final n in _notes) n.id == note.id ? note : n];
    await _simpanDanBeritahu();
  }

  Future<void> remove(String id) async {
    _notes = _notes.where((n) => n.id != id).toList();
    await _simpanDanBeritahu();
  }

  void _urutkan() {
    _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _simpan() async {
    _urutkan();
    final raw = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await _prefs.setString(_key, raw);
  }

  Future<void> _simpanDanBeritahu() async {
    await _simpan();
    notifyListeners();
  }

  /// Catatan awal yang muncul saat aplikasi dibuka pertama kali. Panjangnya sengaja
  /// berbeda-beda supaya susunan kartu di Beranda terlihat seperti pemakaian nyata.
  /// Indeks warna mengikuti `kTones`: 0 Kuning, 1 Merah muda, 2 Biru, 3 Kayu, 4 Abu.
  List<Note> _contoh() {
    final sekarang = DateTime.now();

    Note buat(
      int hariLalu,
      String id,
      String judul,
      String isi,
      String kategori,
      int warna,
      int prioritas,
    ) {
      return Note(
        id: id,
        title: judul,
        content: isi,
        category: kategori,
        tone: warna,
        priority: prioritas,
        createdAt: sekarang.subtract(Duration(days: hariLalu)),
      );
    }

    return [
      buat(
        0,
        'contoh-1',
        'Ide Aplikasi',
        'Membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas. '
            'Dipakai untuk mencatat ide, rencana, dan hal penting sehari-hari.',
        'Penting',
        0,
        2,
      ),
      buat(
        1,
        'contoh-2',
        'Rencana Minggu Ini',
        'Senin: kumpulkan tugas.\nRabu: latihan presentasi.\nJumat: rapikan catatan kuliah.',
        'Kerja',
        2,
        1,
      ),
      buat(
        2,
        'contoh-3',
        'Catatan Kuliah: Fase Perancangan',
        'Buat wireframe dulu, baru tentukan warna dan huruf. Setiap layar harus punya satu '
            'tujuan yang jelas. Kerjakan layar yang paling sering dipakai lebih dulu, '
            'lalu samakan jarak, ukuran huruf, dan bentuk tombol di semua layar.',
        'Kuliah',
        1,
        1,
      ),
      buat(
        3,
        'contoh-4',
        'Belanja Mingguan',
        'Beras, telur, sayur, sabun cuci, baterai remote.',
        'Belanja',
        3,
        0,
      ),
      buat(
        4,
        'contoh-5',
        'Jurnal Harian',
        'Hari ini selesai mengerjakan bagian login. Besok lanjut ke halaman tambah catatan.',
        'Pribadi',
        4,
        0,
      ),
    ];
  }
}
