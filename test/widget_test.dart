import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/app.dart';

import 'helpers.dart';

void main() {
  testWidgets('alur utama: tambah transaksi lalu lihat di semua tab', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Beranda.
    expect(find.text('TOTAL PENGELUARAN'), findsOneWidget);
    expect(find.text('Pengeluaran per Kategori'), findsOneWidget);

    // Tombol Tambah membuka formulir; data baru dikirim balik ke list.
    await tester.tap(find.byTooltip('Tambah transaksi'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Transaksi'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, '0'), '123456');
    await tester.enterText(
      find.widgetWithText(TextField, 'cth. Makan siang, Kopi Kenangan'),
      'Buku Praktikum',
    );
    await tester.scrollUntilVisible(
      find.text('Simpan Transaksi'),
      300,
      scrollable: verticalList(),
    );
    await tester.tap(find.text('Simpan Transaksi'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Transaksi'), findsNothing);

    // Transaksi baru menjadi yang terbaru di Beranda.
    await tester.scrollUntilVisible(
      find.text('Buku Praktikum'),
      300,
      scrollable: verticalList(),
    );
    expect(find.text('Buku Praktikum'), findsOneWidget);

    // "Lihat Semua" pindah ke tab Transaksi.
    // Digulir ke atas layar agar tidak tertutup tombol Tambah.
    await tester.ensureVisible(find.text('Lihat Semua'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lihat Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Buku Praktikum'), findsOneWidget);

    // Detail transaksi lalu kembali.
    await tester.tap(find.text('Buku Praktikum'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(find.text('Rp123.456'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Per Kategori'));
    await tester.pumpAndSettle();
    expect(find.text('Belanja'), findsWidgets);

    await tester.tap(find.widgetWithText(Tab, 'Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}
