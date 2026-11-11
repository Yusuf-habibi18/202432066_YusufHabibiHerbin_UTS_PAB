/// 25000 → "Rp25.000"
String formatRupiah(int amount) =>
    '${amount < 0 ? '-' : ''}Rp${formatThousands(amount.abs())}';

/// Angka dengan titik pemisah ribuan, tanpa "Rp": 25000 → "25.000".
/// [value] tidak negatif.
String formatThousands(int value) {
  final digits = value.toString();
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write('.');
    grouped.write(digits[i]);
  }
  return grouped.toString();
}

/// Versi ringkas untuk ruang sempit, [amount] tidak negatif:
/// 115000 → "Rp115rb", 3450000 → "Rp3,5jt".
String formatRupiahCompact(int amount) {
  if (amount < 1000) return formatRupiah(amount);

  final thousands = (amount / 1000).round();
  if (thousands < 1000) return 'Rp${thousands}rb';

  final tenthsOfMillion = (amount / 100000).round();
  final whole = tenthsOfMillion ~/ 10;
  final fraction = tenthsOfMillion % 10;
  return fraction == 0 ? 'Rp${whole}jt' : 'Rp$whole,${fraction}jt';
}
