import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/transaction_detail_screen.dart';

import '../helpers.dart';

void main() {
  final transaction = tx(
    'Apotek K-24',
    45000,
    DateTime(2026, 11, 2, 19, 5),
    category: TransactionCategory.health,
    paymentMethod: 'QRIS',
    note: 'Obat flu',
  );

  late List<TransactionModel> updated;
  late List<TransactionModel> deleted;

  Future<void> open(WidgetTester tester) async {
    updated = [];
    deleted = [];
    usePhoneScreen(tester, height: 1400);
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailScreen(
                      transaction: transaction,
                      onUpdate: updated.add,
                      onDelete: deleted.add,
                    ),
                  ),
                ),
                child: const Text('Buka'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
  }

  testWidgets('menampilkan data yang dikirim', (tester) async {
    await open(tester);

    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Apotek K-24'), findsOneWidget);
    expect(find.text('Rp45.000'), findsOneWidget);
    expect(find.text('Kesehatan'), findsOneWidget);
    expect(find.text('Senin, 2 November 2026'), findsOneWidget);
    expect(find.text('19:05'), findsOneWidget);
    expect(find.text('QRIS'), findsOneWidget);
    expect(find.text('Obat flu'), findsOneWidget);
  });

  testWidgets('mengubah transaksi lewat formulir', (tester) async {
    await open(tester);

    await tester.tap(find.text('Ubah Transaksi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, '45000'), '50000');
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Rp50.000'), findsOneWidget);
    expect(updated.single.amount, 50000);
    expect(updated.single.id, transaction.id);
  });

  testWidgets('hapus perlu dikonfirmasi', (tester) async {
    await open(tester);

    await tester.tap(find.text('Hapus Transaksi'));
    await tester.pump();
    expect(find.text('Ya, Hapus'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pump();
    expect(find.text('Ya, Hapus'), findsNothing);
    expect(deleted, isEmpty);

    await tester.tap(find.text('Hapus Transaksi'));
    await tester.pump();
    await tester.tap(find.text('Ya, Hapus'));
    await tester.pumpAndSettle();
    expect(deleted.single.id, transaction.id);
    expect(find.text('Detail Transaksi'), findsNothing);
  });
}
