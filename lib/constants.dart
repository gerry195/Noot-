import 'package:flutter/material.dart';

/// Nama yang tampil di sapaan Beranda. Ganti sesuai namamu.
const String kUserName = 'Sobat Noot';

const List<String> kKategori = [
  'Penting',
  'Pribadi',
  'Kerja',
  'Kuliah',
  'Belanja',
];

const Map<String, IconData> kIkonKategori = {
  'Penting': Icons.star_rounded,
  'Pribadi': Icons.favorite_rounded,
  'Kerja': Icons.work_rounded,
  'Kuliah': Icons.menu_book_rounded,
  'Belanja': Icons.shopping_bag_rounded,
};

const List<String> kPrioritasNama = ['Rendah', 'Sedang', 'Tinggi'];

const List<Color> kPrioritasWarna = [
  Color(0xFF12A37C),
  Color(0xFFE0A100),
  Color(0xFFE5484D),
];

class NoteTone {
  const NoteTone(this.name, this.bg, this.accent);

  final String name;
  final Color bg;
  final Color accent;
}

const List<NoteTone> kTones = [
  NoteTone('Langit', Color(0xFFE3F0FF), Color(0xFF3B82F6)),
  NoteTone('Mint', Color(0xFFDDF5EC), Color(0xFF12A37C)),
  NoteTone('Kuning', Color(0xFFFFF3CD), Color(0xFFE0A100)),
  NoteTone('Merah muda', Color(0xFFFFE3EC), Color(0xFFE5487A)),
  NoteTone('Ungu', Color(0xFFEBE4FF), Color(0xFF7C5CE0)),
];

NoteTone toneOf(int index) =>
    kTones[index < 0 || index >= kTones.length ? 0 : index];
