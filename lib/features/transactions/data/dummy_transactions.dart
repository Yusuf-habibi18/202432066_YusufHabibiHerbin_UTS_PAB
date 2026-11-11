import 'dart:math';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/core/constants/payment_methods.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Data awal (dummy data): transaksi contoh selama 6 bulan terakhir sampai
/// [now], 0–2 transaksi per hari. Angka acaknya selalu sama (seed 42), jadi
/// datanya sama setiap aplikasi dibuka.
List<TransactionModel> generateDummyTransactions(DateTime now) {
  final random = Random(42);
  final pool = [
    for (final sample in _samples)
      for (var i = 0; i < sample.weight; i++) sample,
  ];
  final transactions = <TransactionModel>[];

  final firstMonth = DateTime(now.year, now.month - 5);
  for (
    var day = firstMonth;
    !day.isAfter(now);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    final perDay = const [0, 1, 1, 2, 2][random.nextInt(5)];
    for (var i = 0; i < perDay; i++) {
      final sample = pool[random.nextInt(pool.length)];
      final date = DateTime(
        day.year,
        day.month,
        day.day,
        7 + random.nextInt(15),
        random.nextInt(60),
      );
      if (date.isAfter(now)) continue;

      final amount =
          (sample.min + random.nextInt(sample.max - sample.min + 1)) ~/
          500 *
          500;
      transactions.add(
        TransactionModel(
          id: 'dummy-${transactions.length}',
          title: sample.title,
          amount: amount,
          category: sample.category,
          date: date,
          paymentMethod:
              paymentMethods[random.nextInt(paymentMethods.length)].label,
        ),
      );
    }
  }
  return transactions;
}

class _DummySample {
  const _DummySample(
    this.title,
    this.category,
    this.min,
    this.max, [
    this.weight = 1,
  ]);

  final String title;
  final TransactionCategory category;
  final int min;
  final int max;
  final int weight;
}

const _samples = [
  _DummySample(
    'Kopi Kenangan',
    TransactionCategory.foodBeverage,
    18000,
    35000,
    3,
  ),
  _DummySample(
    'Warung Nasi Padang',
    TransactionCategory.foodBeverage,
    20000,
    40000,
    3,
  ),
  _DummySample('Mie Gacoan', TransactionCategory.foodBeverage, 15000, 35000, 2),
  _DummySample(
    'Bakso Pak Kumis',
    TransactionCategory.foodBeverage,
    15000,
    25000,
    2,
  ),
  _DummySample(
    'Indomaret Point',
    TransactionCategory.groceries,
    15000,
    120000,
    3,
  ),
  _DummySample('Alfamart', TransactionCategory.groceries, 10000, 90000, 2),
  _DummySample('Superindo', TransactionCategory.groceries, 80000, 250000),
  _DummySample(
    'SPBU Pertamina',
    TransactionCategory.transportation,
    30000,
    100000,
    2,
  ),
  _DummySample(
    'Parkir Mall',
    TransactionCategory.transportation,
    5000,
    10000,
    2,
  ),
  _DummySample(
    'KRL Commuter Line',
    TransactionCategory.transportation,
    3000,
    10000,
    2,
  ),
  _DummySample('Tokopedia', TransactionCategory.shopping, 50000, 350000),
  _DummySample('Shopee', TransactionCategory.shopping, 40000, 250000),
  _DummySample('CGV Cinemas', TransactionCategory.entertainment, 40000, 90000),
  _DummySample(
    'Token Listrik PLN',
    TransactionCategory.billsUtilities,
    100000,
    200000,
  ),
  _DummySample(
    'Pulsa Telkomsel',
    TransactionCategory.billsUtilities,
    25000,
    100000,
  ),
  _DummySample('Apotek K-24', TransactionCategory.health, 20000, 120000),
  _DummySample(
    'Fotokopi Kampus',
    TransactionCategory.education,
    2000,
    20000,
    2,
  ),
  _DummySample('Laundry Kilat', TransactionCategory.others, 20000, 50000),
];
