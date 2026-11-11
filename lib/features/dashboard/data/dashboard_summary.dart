import 'package:uts_pab/features/transactions/data/transaction_filter.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Total pengeluaran satu bulan.
class MonthlyTotal {
  const MonthlyTotal({required this.month, required this.amount});

  /// Tanggal 1 bulan tersebut.
  final DateTime month;
  final int amount;
}

/// Angka-angka di Beranda untuk satu bulan.
class DashboardSummary {
  const DashboardSummary({
    required this.month,
    required this.total,
    required this.count,
    required this.averagePerDay,
    required this.categories,
    required this.monthly,
    required this.recent,
  });

  factory DashboardSummary.fromTransactions(
    List<TransactionModel> transactions, {
    required DateTime month,
    required DateTime now,
  }) {
    final inMonth = filterTransactions(transactions, month: month);
    final total = totalAmount(inMonth);

    // Bulan berjalan dibagi jumlah hari yang sudah lewat, bulan lain dibagi
    // jumlah hari dalam bulan itu.
    final dayCount = isSameMonth(month, now)
        ? now.day
        : DateTime(month.year, month.month + 1, 0).day;

    return DashboardSummary(
      month: month,
      total: total,
      count: inMonth.length,
      averagePerDay: total ~/ dayCount,
      categories: [
        for (final group in groupByCategory(inMonth))
          if (group.count > 0) group,
      ],
      monthly: [
        for (var i = 5; i >= 0; i--)
          MonthlyTotal(
            month: DateTime(month.year, month.month - i),
            amount: totalAmount(
              filterTransactions(
                transactions,
                month: DateTime(month.year, month.month - i),
              ),
            ),
          ),
      ],
      recent: filterTransactions(transactions).take(5).toList(),
    );
  }

  /// Tanggal 1 bulan yang dirangkum.
  final DateTime month;
  final int total;
  final int count;
  final int averagePerDay;

  /// Kategori yang ada pengeluarannya di bulan ini, dari yang terbesar.
  final List<CategoryGroup> categories;

  /// 6 bulan terakhir sampai [month], dari yang terlama.
  final List<MonthlyTotal> monthly;

  /// 5 transaksi terbaru dari semua bulan.
  final List<TransactionModel> recent;
}
