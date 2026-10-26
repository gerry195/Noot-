# Noot

Aplikasi catatan harian berbasis Flutter yang berjalan sebagai PWA. Dibuat untuk Tugas Individu 02, Uji Pemahaman Fase 2 (Perancangan/Design).

"Noot" berarti catatan dalam bahasa Afrikaans.

## Halaman

| No | Halaman | File |
|----|---------|------|
| 1 | Splash Screen | `lib/screens/splash_screen.dart` |
| 2 | Login Statis | `lib/screens/login_screen.dart` |
| 3 | Beranda | `lib/screens/home_screen.dart` |
| 4 | Tambah Catatan | `lib/screens/add_note_screen.dart` |
| 5 | Detail Catatan | `lib/screens/detail_screen.dart` |

Login hanya tampilan. Tombol Masuk dan Masuk dengan Google langsung membuka Beranda.

Halaman Tambah Catatan juga dipakai untuk mengubah catatan, jadi jumlah halaman tetap lima. Tab Arsip dan Profil di navigasi bawah hanya elemen tampilan dan menampilkan pesan singkat saat diketuk.

## Fitur

- Catatan tersimpan di perangkat (`shared_preferences`, di web memakai localStorage).
- Cari catatan, filter kategori, urutkan berdasarkan terbaru atau prioritas.
- Tambah, ubah, hapus catatan, dengan tombol Urungkan setelah hapus.
- Lima warna kartu dan tiga tingkat prioritas.
- Bisa diinstal dan tetap terbuka tanpa internet setelah kunjungan pertama.

## Langkah pertama

Jalankan sekali di folder project ini. Perintah ini membuat folder platform yang belum ada dan tidak menimpa file yang sudah ada.

```bash
flutter create . --platforms=web,android --project-name noot
flutter pub get
```

## Menjalankan

```bash
flutter run -d chrome
```

Untuk tangkapan layar versi ponsel, jalankan di emulator Android (`flutter run`) atau buka DevTools Chrome (F12) dan aktifkan mode perangkat.

## Build PWA

```bash
flutter build web --release
```

Hasil build ada di `build/web`. Folder itu sudah berisi `manifest.json` dan service worker.

## Deploy ke GitHub Pages

1. Buat repository baru di GitHub, misalnya `noot`.
2. Unggah seluruh isi folder ini ke branch `main`.
3. Buka **Settings → Pages**, lalu pilih **Source: GitHub Actions**.
4. Workflow `.github/workflows/deploy.yml` berjalan otomatis setiap push ke `main`.
5. Alamat aplikasi: `https://USERNAME.github.io/noot/`

Nama repository dipakai sebagai `--base-href`, jadi workflow ini bekerja untuk nama repository apa pun.

## Cara menginstal

- **Chrome atau Edge di komputer**: klik ikon instal di kanan address bar.
- **Android (Chrome)**: menu ⋮ → **Instal aplikasi**.
- **iPhone (Safari)**: tombol Bagikan → **Tambah ke Layar Utama**.

PWA hanya bisa diinstal lewat HTTPS. `localhost` juga diizinkan untuk uji lokal.

## Menyesuaikan

- Nama di sapaan Beranda: ubah `kUserName` di `lib/constants.dart`.
- Warna: `lib/theme.dart` (`NootColors`) dan `lib/constants.dart` (`kTones`).
- Kategori: `kKategori` dan `kIkonKategori` di `lib/constants.dart`.

## Struktur

```
lib/
  main.dart            titik masuk
  constants.dart       kategori, warna kartu, prioritas
  theme.dart           tema dan gaya input
  models/note.dart     model catatan
  services/            penyimpanan lokal
  screens/             lima halaman
  widgets/             logo, kartu catatan, dialog
  utils/format.dart    format tanggal dan jam
web/                   index.html, manifest, ikon PWA
test/                  uji model dan format
```

Jalankan uji dengan `flutter test`.
