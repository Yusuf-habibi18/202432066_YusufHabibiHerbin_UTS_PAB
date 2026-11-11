import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/utils/date_formatter.dart';

void main() {
  final now = DateTime(2026, 11, 3, 12);

  test('tanggal lengkap memakai nama hari dan bulan Indonesia', () {
    expect(formatFullDate(DateTime(2025, 3, 24)), 'Senin, 24 Maret 2025');
    expect(formatMonthYear(DateTime(2026, 11)), 'November 2026');
  });

  test('waktu transaksi relatif terhadap hari ini', () {
    expect(
      formatTransactionTime(DateTime(2026, 11, 3, 8, 30), now),
      'Hari ini, 08:30',
    );
    expect(
      formatTransactionTime(DateTime(2026, 11, 2, 19, 45), now),
      'Kemarin, 19:45',
    );
    expect(
      formatTransactionTime(DateTime(2026, 10, 22, 14, 15), now),
      '22 Okt, 14:15',
    );
    expect(
      formatTransactionTime(DateTime(2025, 3, 22, 14, 15), now),
      '22 Mar 2025, 14:15',
    );
  });

  test('"Kemarin" tetap benar saat berganti bulan', () {
    expect(
      formatTransactionTime(DateTime(2026, 10, 31, 20), DateTime(2026, 11, 1)),
      'Kemarin, 20:00',
    );
  });

  test('tanggal singkat untuk form', () {
    expect(formatDateShort(DateTime(2026, 11, 3, 8), now), 'Hari ini, 3 Nov');
    expect(formatDateShort(DateTime(2026, 11, 2), now), 'Kemarin, 2 Nov');
    expect(formatDateShort(DateTime(2026, 10, 28), now), '28 Okt');
    expect(formatDateShort(DateTime(2025, 12, 28), now), '28 Des 2025');
  });

  test('judul kelompok per hari', () {
    expect(
      formatDayLabel(DateTime(2026, 11, 3, 8), now),
      'Hari ini — 3 November 2026',
    );
    expect(
      formatDayLabel(DateTime(2026, 11, 2), now),
      'Kemarin — 2 November 2026',
    );
    expect(formatDayLabel(DateTime(2026, 10, 30), now), '30 Oktober 2026');
  });
}
