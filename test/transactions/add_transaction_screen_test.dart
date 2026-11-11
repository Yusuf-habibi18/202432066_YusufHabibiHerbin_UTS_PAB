import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/add_transaction_screen.dart';

import '../helpers.dart';

/// Membuka formulir dari halaman lain dan mencatat data yang dikirim balik
/// lewat Navigator.pop.
class _Opener {
  TransactionModel? result;
  var closed = false;

  Future<void> open(WidgetTester tester, {TransactionModel? initial}) async {
    // Layar tinggi agar seluruh formulir terlihat tanpa digulir.
    usePhoneScreen(tester, height: 1400);
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  result = await Navigator.push<TransactionModel>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTransactionScreen(initial: initial),
                    ),
                  );
                  closed = true;
                },
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
}

Finder _field(String hint) => find.widgetWithText(TextField, hint);

void main() {
  testWidgets('menolak isian kosong', (tester) async {
    final opener = _Opener();
    await opener.open(tester);
    expect(find.text('Tambah Transaksi'), findsOneWidget);

    await tester.tap(find.text('Simpan Transaksi'));
    await tester.pumpAndSettle();
    expect(find.text('Nominal wajib diisi'), findsOneWidget);
    expect(find.text('Nama pengeluaran wajib diisi'), findsOneWidget);
    expect(opener.closed, isFalse);

    await tester.enterText(_field('0'), '0');
    await tester.pump();
    expect(find.text('Nominal harus lebih dari 0'), findsOneWidget);
  });

  testWidgets('mengirim transaksi baru lewat Navigator.pop', (tester) async {
    final opener = _Opener();
    await opener.open(tester);

    await tester.enterText(_field('0'), '25.000');
    await tester.pump();
    expect(find.text('Rp25.000'), findsOneWidget);
    await tester.enterText(
      _field('cth. Makan siang, Kopi Kenangan'),
      '  Ojek ke kampus ',
    );
    await tester.tap(find.text('Transportasi'));
    await tester.tap(find.text('QRIS'));
    // Tanggal tidak bisa maju melewati hari ini, tetapi bisa mundur.
    final next = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_right_rounded),
    );
    expect(next.onPressed, isNull);
    await tester.tap(find.byTooltip('Hari sebelumnya'));
    await tester.enterText(_field('Tambahkan catatan pengeluaran…'), 'Hujan');
    await tester.pump();

    await tester.tap(find.text('Simpan Transaksi'));
    await tester.pumpAndSettle();

    expect(opener.closed, isTrue);
    final t = opener.result!;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    expect(t.amount, 25000);
    expect(t.title, 'Ojek ke kampus');
    expect(t.category, TransactionCategory.transportation);
    expect(t.paymentMethod, 'QRIS');
    expect(t.note, 'Hujan');
    expect(t.date.day, yesterday.day);
  });

  testWidgets('mode ubah terisi data lama dan mempertahankan id', (
    tester,
  ) async {
    final initial = tx(
      'Bakso',
      20000,
      DateTime(2026, 10, 5, 12, 30),
      category: TransactionCategory.foodBeverage,
      paymentMethod: 'Transfer',
    );
    final opener = _Opener();
    await opener.open(tester, initial: initial);

    expect(find.text('Ubah Transaksi'), findsOneWidget);
    expect(find.text('Bakso'), findsOneWidget);
    expect(find.text('Senin, 5 Oktober 2026'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '20000'), '22000');
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    final t = opener.result!;
    expect(t.id, 'Bakso');
    expect(t.amount, 22000);
    expect(t.paymentMethod, 'Transfer');
    expect(t.date, DateTime(2026, 10, 5, 12, 30));
  });
}
