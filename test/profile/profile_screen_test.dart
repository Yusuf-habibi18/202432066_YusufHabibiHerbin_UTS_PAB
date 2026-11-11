import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/features/profile/profile_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('foto profil dari internet dan ringkasan transaksi', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: ProfileScreen(
            userName: 'Yusuf',
            transactions: [
              tx('A', 30000, DateTime(2026, 11, 1)),
              tx(
                'B',
                50000,
                DateTime(2026, 11, 2),
                category: TransactionCategory.transportation,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final avatar = tester.widget<Image>(
      find.descendant(
        of: find.byType(CircleAvatar),
        matching: find.byType(Image),
      ),
    );
    expect(avatar.image, isA<NetworkImage>());
    // Test tidak punya internet, jadi inisial yang tampil.
    expect(find.text('Y'), findsOneWidget);

    expect(find.text('2 transaksi tercatat'), findsOneWidget);
    expect(find.text('Rp80.000'), findsOneWidget);
    expect(find.text('Transportasi'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}
