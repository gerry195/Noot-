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

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

String formatJam(DateTime d) {
  final jam = d.hour.toString().padLeft(2, '0');
  final menit = d.minute.toString().padLeft(2, '0');
  return '$jam.$menit';
}

String salam(DateTime d) {
  if (d.hour < 11) return 'Selamat pagi';
  if (d.hour < 15) return 'Selamat siang';
  if (d.hour < 18) return 'Selamat sore';
  return 'Selamat malam';
}
