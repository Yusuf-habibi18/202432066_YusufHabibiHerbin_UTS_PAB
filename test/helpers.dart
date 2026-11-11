import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/core/theme/app_theme.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Transaksi untuk test. [title] sekaligus dipakai sebagai id.
TransactionModel tx(
  String title,
  int amount,
  DateTime date, {
  TransactionCategory category = TransactionCategory.foodBeverage,
  String paymentMethod = 'Tunai',
  String? note,
}) => TransactionModel(
  id: title,
  title: title,
  amount: amount,
  category: category,
  date: date,
  paymentMethod: paymentMethod,
  note: note,
);

/// Layar HP 360 × [height] dp.
void usePhoneScreen(WidgetTester tester, {double height = 780}) {
  tester.view.physicalSize = Size(1080, height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Widget testApp(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

/// Daftar yang digulir ke bawah. TabBarView juga Scrollable (ke samping),
/// jadi find.byType(Scrollable) saja bisa menemukan TabBarView.
Finder verticalList() => find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .first;

/// Daftar yang digeser ke samping, misalnya chip kategori. Yang terakhir
/// dipilih karena TabBarView berada di atasnya.
Finder horizontalList() => find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
    )
    .last;
