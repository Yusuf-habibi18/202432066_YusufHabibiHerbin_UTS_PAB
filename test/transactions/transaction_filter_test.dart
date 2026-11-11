import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';

import '../helpers.dart';

void main() {
  final transactions = [
    tx('Kopi Kenangan', 28000, DateTime(2026, 11, 3, 8, 30), note: 'Es kopi'),
    tx(
      'Indomaret',
      45000,
      DateTime(2026, 11, 3, 13, 15),
      category: TransactionCategory.groceries,
    ),
    tx('Bakso', 20000, DateTime(2026, 11, 1, 12)),
    tx('Kopi Tuku', 30000, DateTime(2026, 10, 31, 20)),
  ];

  test('filter bulan, kategori, dan kata kunci, terbaru dulu', () {
    final november = filterTransactions(
      transactions,
      month: DateTime(2026, 11),
    );
    expect(november.map((t) => t.title), [
      'Indomaret',
      'Kopi Kenangan',
      'Bakso',
    ]);

    expect(
      filterTransactions(
        transactions,
        category: TransactionCategory.groceries,
      ).map((t) => t.title),
      ['Indomaret'],
    );

    // Kata kunci mencari di nama dan catatan, tanpa membedakan huruf besar.
    expect(
      filterTransactions(transactions, query: 'KOPI').map((t) => t.title),
      ['Kopi Kenangan', 'Kopi Tuku'],
    );
    expect(
      filterTransactions(transactions, query: 'es kopi').map((t) => t.title),
      ['Kopi Kenangan'],
    );
  });

  test('total nominal', () {
    expect(totalAmount(transactions), 123000);
    expect(totalAmount([]), 0);
  });

  test('kelompok per hari tanpa mengubah urutan', () {
    final days = groupByDay(
      filterTransactions(transactions, month: DateTime(2026, 11)),
    );
    expect(days.map((d) => d.date), [
      DateTime(2026, 11, 3),
      DateTime(2026, 11, 1),
    ]);
    expect(days.first.transactions.length, 2);
    expect(days.first.total, 73000);
  });

  test('kelompok per kategori lengkap, terbesar dulu', () {
    final groups = groupByCategory(transactions);
    expect(groups.length, TransactionCategory.values.length);
    expect(groups.first.category, TransactionCategory.foodBeverage);
    expect(groups.first.total, 78000);
    expect(groups.first.count, 3);
    expect(groups[1].category, TransactionCategory.groceries);
    // Kategori kosong di bawah, urut sesuai daftar kategori.
    expect(groups[2].category, TransactionCategory.transportation);
    expect(groups[2].count, 0);
  });
}
