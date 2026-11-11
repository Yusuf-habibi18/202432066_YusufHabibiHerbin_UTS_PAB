import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/utils/currency_formatter.dart';

void main() {
  group('formatRupiah', () {
    test('memberi titik pemisah ribuan tanpa desimal', () {
      expect(formatRupiah(0), 'Rp0');
      expect(formatRupiah(500), 'Rp500');
      expect(formatRupiah(25000), 'Rp25.000');
      expect(formatRupiah(3450000), 'Rp3.450.000');
      expect(formatRupiah(1000000000), 'Rp1.000.000.000');
    });
  });

  test('formatThousands tanpa awalan Rp', () {
    expect(formatThousands(0), '0');
    expect(formatThousands(999), '999');
    expect(formatThousands(25000), '25.000');
    expect(formatThousands(9999999999), '9.999.999.999');
  });

  group('formatRupiahCompact', () {
    test('memakai rb dan jt', () {
      expect(formatRupiahCompact(999), 'Rp999');
      expect(formatRupiahCompact(115000), 'Rp115rb');
      expect(formatRupiahCompact(3450000), 'Rp3,5jt');
      expect(formatRupiahCompact(2000000), 'Rp2jt');
    });

    test('pindah ke jt saat pembulatan ribuan mencapai 1000', () {
      expect(formatRupiahCompact(999600), 'Rp1jt');
    });
  });
}
