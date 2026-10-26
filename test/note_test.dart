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

  test('formatJam memakai dua digit dan titik', () {
    expect(formatJam(DateTime(2026, 10, 19, 9, 5)), '09.05');
  });

  test('salam mengikuti jam', () {
    expect(salam(DateTime(2026, 1, 1, 8)), 'Selamat pagi');
    expect(salam(DateTime(2026, 1, 1, 13)), 'Selamat siang');
    expect(salam(DateTime(2026, 1, 1, 16)), 'Selamat sore');
    expect(salam(DateTime(2026, 1, 1, 20)), 'Selamat malam');
  });
}
