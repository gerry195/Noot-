# Noot

Aplikasi catatan harian, Tugas Individual02 Pemongraman perangkat bergerak / RPL317 (tahap perancangan). Isi project ini hanya UI, 5 halaman:

1. Splash Screen
2. Login (statis, tanpa autentikasi)
3. Beranda (daftar catatan, pencarian, filter)
4. Tambah Catatan (juga dipakai untuk mengubah)
5. Detail Catatan

Data disimpan sementara di memori (`lib/data/notes_store.dart`). Untuk database, ganti isi file itu saja.

## Menjalankan

Folder platform (android, web, ios) belum dibuat. Dari dalam folder project ini:

```bash
flutter create . --project-name noot --platforms=web,android
flutter pub get
flutter run -d chrome
```

`flutter create .` tidak menimpa `lib/`, `pubspec.yaml`, maupun `test/` yang sudah ada.
