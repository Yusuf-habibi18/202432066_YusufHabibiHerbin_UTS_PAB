const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

const _months = [
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

String _twoDigits(int n) => n.toString().padLeft(2, '0');

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// "Senin, 24 Maret 2025"
String formatFullDate(DateTime date) =>
    '${_days[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]} ${date.year}';

/// "Oktober 2026"
String formatMonthYear(DateTime date) =>
    '${_months[date.month - 1]} ${date.year}';

/// "Okt"
String formatShortMonth(DateTime date) =>
    _months[date.month - 1].substring(0, 3);

/// "08:30"
String formatTime(DateTime date) =>
    '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

/// "Hari ini, 3 Nov", "Kemarin, 2 Nov", "28 Okt", atau "28 Des 2025".
String formatDateShort(DateTime date, DateTime now) {
  final dayMonth = '${date.day} ${formatShortMonth(date)}';
  if (_isSameDay(date, now)) return 'Hari ini, $dayMonth';
  if (_isSameDay(date, DateTime(now.year, now.month, now.day - 1))) {
    return 'Kemarin, $dayMonth';
  }
  return date.year == now.year ? dayMonth : '$dayMonth ${date.year}';
}

/// "Hari ini, 08:30", "Kemarin, 19:45", "22 Mar, 14:15",
/// atau "22 Mar 2025, 14:15" jika tahunnya berbeda.
String formatTransactionTime(DateTime date, DateTime now) {
  final time = formatTime(date);
  if (_isSameDay(date, now)) return 'Hari ini, $time';
  if (_isSameDay(date, DateTime(now.year, now.month, now.day - 1))) {
    return 'Kemarin, $time';
  }
  final year = date.year == now.year ? '' : ' ${date.year}';
  return '${date.day} ${formatShortMonth(date)}$year, $time';
}

/// Judul kelompok per hari: "Hari ini — 3 November 2026",
/// "Kemarin — 2 November 2026", atau "1 November 2026".
String formatDayLabel(DateTime date, DateTime now) {
  final full = '${date.day} ${_months[date.month - 1]} ${date.year}';
  if (_isSameDay(date, now)) return 'Hari ini — $full';
  if (_isSameDay(date, DateTime(now.year, now.month, now.day - 1))) {
    return 'Kemarin — $full';
  }
  return full;
}
