const List<String> _bulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> _bulanPendek = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

// DateTime.weekday: 1 = Senin ... 7 = Minggu.
const List<String> _hari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

String formatHariTanggal(DateTime d) =>
    '${_hari[d.weekday - 1]}, ${formatTanggal(d)}';

String formatJam(DateTime d) {
  final jam = d.hour.toString().padLeft(2, '0');
  final menit = d.minute.toString().padLeft(2, '0');
  return '$jam.$menit';
}

/// Tanggal singkat untuk kartu: "Hari ini", "Kemarin", "19 Okt", atau "19 Okt 2025".
String tanggalRingkas(DateTime d, DateTime sekarang) {
  final hariCatatan = DateTime(d.year, d.month, d.day);
  final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
  final selisih = hariIni.difference(hariCatatan).inDays;
  if (selisih == 0) return 'Hari ini';
  if (selisih == 1) return 'Kemarin';
  final bulan = _bulanPendek[d.month - 1];
  return d.year == sekarang.year
      ? '${d.day} $bulan'
      : '${d.day} $bulan ${d.year}';
}
