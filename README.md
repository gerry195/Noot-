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

Login hanya tampilan. Tombol Masuk dan Lanjut dengan Google langsung membuka Beranda.

Halaman Tambah Catatan juga dipakai untuk mengubah catatan, jadi jumlah halaman tetap lima.

## Fitur

- Catatan tersimpan di perangkat (`shared_preferences`, di web memakai localStorage).
- Cari catatan, filter kategori, urutkan berdasarkan terbaru atau prioritas.
- Tambah, ubah, hapus catatan, dengan tombol Urungkan setelah hapus. Tekan lama sebuah kartu untuk menu Ubah dan Hapus.
- Lima warna kartu dan tiga tingkat prioritas. Catatan berprioritas tinggi diberi sudut kanan atas yang terlipat.
- Kotak judul dan isi di form berubah warna saat Warna dipilih, jadi tampilannya sama dengan kartu di Beranda.
- Bisa diinstal dan tetap terbuka tanpa internet setelah kunjungan pertama.

## Desain

- **Logo**: `assets/noot app logo.png`. Ikon PWA di `web/icons` dan `web/favicon.png` dibuat dari gambar yang sama.
- **Palet**: semua warna diambil dari logo. Navy `#0C3962` untuk teks dan latar splash, kuning pensil `#F6C948` untuk tombol utama, dan warna kartu dari badan pensil, penghapus, ujung kayu, serta pita logam.
- **Huruf**: satu keluarga, TeX Gyre Pagella (`assets/fonts`). Lisensinya GUST Font License, salinannya ada di folder yang sama.
- **Splash**: latar navy sama persis dengan latar logo. Garis kuning di bawah nama tergambar dari kiri ke kanan.
- Aplikasi tidak memakai navigasi bawah, karena hanya ada lima halaman dan tidak ada tujuan untuk tab tambahan.

## Langkah pertama

Jalankan sekali di folder project ini. Perintah ini membuat folder platform yang belum ada dan tidak menimpa file yang sudah ada.

```bash
flutter create . --platforms=web --project-name noot
flutter pub get
```

Tambahkan `android` ke `--platforms` bila kamu juga ingin menjalankannya di emulator Android.

## Menjalankan

```bash
flutter run -d chrome
```

Untuk tangkapan layar versi ponsel, buka DevTools Chrome (F12) dan aktifkan mode perangkat, atau jalankan di emulator Android.

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

- Warna aplikasi: `NootColors` di `lib/theme.dart`.
- Warna kartu: `kTones` di `lib/constants.dart`.
- Kategori: `kKategori` di `lib/constants.dart`.
- Mengganti logo: timpa `assets/noot app logo.png`, lalu ganti juga file di `web/icons` dan `web/favicon.png`. Latar logo sebaiknya tetap navy `#0C3962` supaya menyatu dengan splash.

## Struktur

```
lib/
  main.dart            titik masuk
  constants.dart       logo, kategori, warna kartu, prioritas
  theme.dart           palet, huruf, tema
  models/note.dart     model catatan
  services/            penyimpanan lokal
  screens/             lima halaman
  widgets/             logo, kartu catatan, pilihan, dialog
  utils/format.dart    format tanggal dan jam
assets/                logo dan font
web/                   index.html, manifest, ikon PWA
test/                  uji model, format, dan alur splash ke login
```

Jalankan uji dengan `flutter test`.
