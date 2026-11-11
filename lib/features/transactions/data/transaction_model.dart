import 'package:uts_pab/core/constants/categories.dart';

/// Satu catatan pengeluaran.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    this.note,
  });

  final String id;

  /// Nama pengeluaran atau tempatnya, misalnya "Kopi Kenangan".
  final String title;

  /// Nominal dalam rupiah, selalu lebih dari 0.
  final int amount;
  final TransactionCategory category;

  /// Tanggal dan jam transaksi.
  final DateTime date;

  /// Salah satu label dari paymentMethods, misalnya "Tunai".
  final String paymentMethod;

  /// Catatan tambahan, null jika tidak diisi.
  final String? note;
}
