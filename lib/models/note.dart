import 'package:flutter/material.dart';

enum Priority {
  rendah('Rendah', Color(0xFF17794F), Color(0xFFDDF4E8)),
  sedang('Sedang', Color(0xFF8A5A00), Color(0xFFFFEFC7)),
  tinggi('Tinggi', Color(0xFFB4232C), Color(0xFFFFE0E2));

  const Priority(this.label, this.fg, this.bg);
  final String label;
  final Color fg;
  final Color bg;
}

const noteCategories = <String>['Pribadi', 'Kerja', 'Kuliah', 'Ide'];

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.colorIndex,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  String title;
  String content;
  String category;
  int colorIndex;
  Priority priority;
  final DateTime createdAt;
}

const _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

String formatJam(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';
