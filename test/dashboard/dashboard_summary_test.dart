import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/dashboard/data/dashboard_summary.dart';

import '../helpers.dart';

void main() {
  final now = DateTime(2026, 11, 4, 12);
  final transactions = [
    tx('A', 30000, DateTime(2026, 11, 1, 9)),
    tx(
      'B',
      50000,
      DateTime(2026, 11, 2, 9),
      category: TransactionCategory.transportation,
    ),
    tx('C', 20000, DateTime(2026, 11, 3, 9)),
    tx('D', 60000, DateTime(2026, 10, 15, 9)),
    tx('E', 10000, DateTime(2026, 6, 15, 9)),
  ];

  test('ringkasan bulan berjalan', () {
    final summary = DashboardSummary.fromTransactions(
      transactions,
      month: DateTime(2026, 11),
      now: now,
    );

    expect(summary.total, 100000);
    expect(summary.count, 3);
    // Bulan berjalan dibagi 4 hari yang sudah lewat.
    expect(summary.averagePerDay, 25000);
    expect(summary.categories.map((c) => c.category), [
      TransactionCategory.foodBeverage,
      TransactionCategory.transportation,
    ]);
    expect(summary.recent.map((t) => t.title), ['C', 'B', 'A', 'D', 'E']);
  });

  test('6 bulan terakhir, dari yang terlama', () {
    final summary = DashboardSummary.fromTransactions(
      transactions,
      month: DateTime(2026, 11),
      now: now,
    );

    expect(summary.monthly.map((m) => m.month), [
      DateTime(2026, 6),
      DateTime(2026, 7),
      DateTime(2026, 8),
      DateTime(2026, 9),
      DateTime(2026, 10),
      DateTime(2026, 11),
    ]);
    expect(summary.monthly.map((m) => m.amount), [
      10000,
      0,
      0,
      0,
      60000,
      100000,
    ]);
  });

  test('bulan lalu dibagi jumlah hari penuh', () {
    final summary = DashboardSummary.fromTransactions(
      transactions,
      month: DateTime(2026, 10),
      now: now,
    );
    expect(summary.total, 60000);
    expect(summary.averagePerDay, 60000 ~/ 31);
  });
}
