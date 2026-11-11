import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/transactions/presentation/transactions_screen.dart';

import '../helpers.dart';

void main() {
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month, 1);
  final transactions = [
    tx(
      'Kopi Kenangan',
      28000,
      thisMonth.add(const Duration(hours: 8)),
      note: 'Es kopi susu',
    ),
    tx(
      'Indomaret',
      45000,
      thisMonth.add(const Duration(hours: 13)),
      category: TransactionCategory.groceries,
    ),
    tx(
      'Ojek Online',
      15000,
      thisMonth.add(const Duration(hours: 7)),
      category: TransactionCategory.transportation,
    ),
    tx('Kopi Tuku', 30000, thisMonth.subtract(const Duration(days: 3))),
  ];

  Future<void> open(WidgetTester tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: TransactionsScreen(
            transactions: transactions,
            onUpdate: (_) {},
            onDelete: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('riwayat bulan ini beserta totalnya', (tester) async {
    await open(tester);

    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('3 transaksi'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(SummaryBar),
        matching: find.text('Rp88.000'),
      ),
      findsOneWidget,
    );
    expect(find.text('Kopi Kenangan'), findsOneWidget);
    expect(find.text('Kopi Tuku'), findsNothing);

    // Tidak bisa maju ke bulan depan, tetapi bisa mundur.
    final next = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_right_rounded).first,
    );
    expect(next.onPressed, isNull);
    await tester.tap(find.byTooltip('Bulan sebelumnya'));
    await tester.pumpAndSettle();
    expect(find.text('1 transaksi'), findsOneWidget);
    expect(find.text('Kopi Tuku'), findsOneWidget);
  });

  testWidgets('pencarian dan filter kategori', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), 'kopi');
    await tester.pump();
    expect(find.text('1 transaksi'), findsOneWidget);
    expect(find.text('Indomaret'), findsNothing);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(find.text('3 transaksi'), findsOneWidget);

    // Chip kategori digeser ke samping dulu sampai terlihat.
    await tester.scrollUntilVisible(
      find.text('Kebutuhan Harian'),
      100,
      scrollable: horizontalList(),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kebutuhan Harian'));
    await tester.pump();
    expect(find.text('1 transaksi'), findsOneWidget);
    expect(find.text('Kopi Kenangan'), findsNothing);
  });

  testWidgets('hasil kosong menawarkan hapus filter', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), 'tidak ada');
    await tester.pump();
    expect(find.text('Tidak ada transaksi yang cocok'), findsOneWidget);

    await tester.tap(find.text('Hapus filter'));
    await tester.pump();
    expect(find.text('3 transaksi'), findsOneWidget);
  });

  testWidgets('tab Per Kategori mengelompokkan pengeluaran', (tester) async {
    await open(tester);

    await tester.tap(find.text('Per Kategori'));
    await tester.pumpAndSettle();
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.text('3 transaksi'), findsOneWidget);
    expect(find.text('1 transaksi · 51%'), findsOneWidget);
    expect(find.text('1 transaksi · 32%'), findsOneWidget);
    expect(find.text('1 transaksi · 17%'), findsOneWidget);
    // Kategori tanpa pengeluaran tetap tampil.
    expect(find.text('Belum ada pengeluaran'), findsWidgets);

    // Menekan kategori membuka tab Riwayat dengan filter kategori itu.
    await tester.tap(find.text('Makanan & Minuman'));
    await tester.pumpAndSettle();
    expect(find.text('1 transaksi'), findsOneWidget);
    expect(find.text('Kopi Kenangan'), findsOneWidget);
    expect(find.text('Indomaret'), findsNothing);
  });
}
