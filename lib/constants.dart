import 'package:flutter/material.dart';

/// Logo aplikasi. File ini juga menjadi sumber ikon PWA di folder web/icons.
const String kLogoAsset = 'assets/noot app logo.png';

const List<String> kKategori = [
  'Penting',
  'Pribadi',
  'Kerja',
  'Kuliah',
  'Belanja',
];

const String kKategoriAwal = 'Pribadi';

const List<String> kPrioritasNama = ['Rendah', 'Sedang', 'Tinggi'];

/// Warna kartu catatan. Semuanya diambil dari bagian pensil di logo:
/// badan pensil (kuning), penghapus (merah muda), ujung kayu, dan pita logam.
/// [fold] adalah warna sisi gelap, dipakai untuk sudut terlipat.
class NoteTone {
  const NoteTone(this.name, this.bg, this.fold);

  final String name;
  final Color bg;
  final Color fold;
}

const List<NoteTone> kTones = [
  NoteTone('Kuning', Color(0xFFF6C948), Color(0xFFE4A621)),
  NoteTone('Merah muda', Color(0xFFF4929F), Color(0xFFDB6E85)),
  NoteTone('Biru', Color(0xFF9FCDF5), Color(0xFF6FAEE6)),
  NoteTone('Kayu', Color(0xFFF4D5A6), Color(0xFFE3B982)),
  NoteTone('Abu', Color(0xFFCBD1DF), Color(0xFFA9B3C7)),
];

NoteTone toneOf(int index) =>
    kTones[index < 0 || index >= kTones.length ? 0 : index];
