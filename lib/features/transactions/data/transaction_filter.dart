import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// Total nominal [transactions].
int totalAmount(Iterable<TransactionModel> transactions) =>
    transactions.fold(0, (sum, t) => sum + t.amount);

/// Transaksi yang cocok dengan semua filter, dari yang terbaru.
///
/// [month] berisi tanggal 1 bulan yang dipilih (null = semua bulan).
/// Pencarian mencocokkan nama dan catatan tanpa membedakan huruf besar.
List<TransactionModel> filterTransactions(
  Iterable<TransactionModel> transactions, {
  DateTime? month,
  String query = '',
  TransactionCategory? category,
}) {
  final keyword = query.trim().toLowerCase();
  final result = [
    for (final t in transactions)
      if ((month == null || isSameMonth(t.date, month)) &&
          (category == null || t.category == category) &&
          (keyword.isEmpty || _matches(t, keyword)))
        t,
  ];
  result.sort((a, b) => b.date.compareTo(a.date));
  return result;
}

bool _matches(TransactionModel t, String keyword) =>
    t.title.toLowerCase().contains(keyword) ||
    (t.note?.toLowerCase().contains(keyword) ?? false);

/// Transaksi dalam satu hari.
class TransactionDay {
  TransactionDay(this.date, this.transactions);

  /// Tanggal tanpa jam.
  final DateTime date;
  final List<TransactionModel> transactions;

  int get total => totalAmount(transactions);
}

/// Mengelompokkan [transactions] yang sudah diurutkan per tanggal, tanpa
/// mengubah urutannya.
List<TransactionDay> groupByDay(List<TransactionModel> transactions) {
  final days = <TransactionDay>[];
  for (final t in transactions) {
    final date = DateTime(t.date.year, t.date.month, t.date.day);
    if (days.isNotEmpty && days.last.date == date) {
      days.last.transactions.add(t);
    } else {
      days.add(TransactionDay(date, [t]));
    }
  }
  return days;
}

/// Pengeluaran satu kategori.
class CategoryGroup {
  CategoryGroup(this.category, this.transactions);

  final TransactionCategory category;
  final List<TransactionModel> transactions;

  int get total => totalAmount(transactions);
  int get count => transactions.length;
}

/// Semua kategori beserta transaksinya, dari total terbesar. Kategori tanpa
/// pengeluaran tetap ada di urutan bawah, agar daftarnya lengkap.
List<CategoryGroup> groupByCategory(Iterable<TransactionModel> transactions) {
  final groups = [
    for (final category in TransactionCategory.values)
      CategoryGroup(category, [
        for (final t in transactions)
          if (t.category == category) t,
      ]),
  ];
  groups.sort((a, b) {
    final byTotal = b.total.compareTo(a.total);
    return byTotal != 0 ? byTotal : a.category.index - b.category.index;
  });
  return groups;
}
