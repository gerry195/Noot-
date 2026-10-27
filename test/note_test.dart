import 'package:flutter_test/flutter_test.dart';
import 'package:noot/models/note.dart';
import 'package:noot/utils/format.dart';

void main() {
  test('Note bisa diubah ke JSON dan dibaca kembali', () {
    final asli = Note(
      id: '1',
      title: 'Ide Aplikasi',
      content: 'Isi catatan',
      category: 'Penting',
      tone: 2,
      priority: 2,
      createdAt: DateTime(2026, 10, 19, 9, 30),
    );

    final salinan = Note.fromJson(asli.toJson());

    expect(salinan.id, asli.id);
    expect(salinan.title, asli.title);
    expect(salinan.content, asli.content);
    expect(salinan.category, asli.category);
    expect(salinan.tone, asli.tone);
    expect(salinan.priority, asli.priority);
    expect(salinan.createdAt, asli.createdAt);
  });

  test('formatTanggal memakai nama bulan bahasa Indonesia', () {
    expect(formatTanggal(DateTime(2026, 10, 19)), '19 Oktober 2026');
  });

  test('formatHariTanggal menambahkan nama hari', () {
    // 27 Oktober 2026 jatuh pada hari Selasa.
    expect(formatHariTanggal(DateTime(2026, 10, 27)), 'Selasa, 27 Oktober 2026');
  });

  test('formatJam memakai dua digit dan titik', () {
    expect(formatJam(DateTime(2026, 10, 19, 9, 5)), '09.05');
  });

  test('tanggalRingkas memakai Hari ini, Kemarin, lalu tanggal singkat', () {
    final sekarang = DateTime(2026, 10, 27, 10, 0);

    expect(tanggalRingkas(DateTime(2026, 10, 27, 0, 5), sekarang), 'Hari ini');
    expect(tanggalRingkas(DateTime(2026, 10, 26, 23, 59), sekarang), 'Kemarin');
    expect(tanggalRingkas(DateTime(2026, 10, 19, 9, 30), sekarang), '19 Okt');
    expect(tanggalRingkas(DateTime(2025, 12, 31), sekarang), '31 Des 2025');
  });
}
