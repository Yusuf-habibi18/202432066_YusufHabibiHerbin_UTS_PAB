import 'package:flutter/material.dart';

import 'package:uts_pab/core/utils/date_formatter.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/core/widgets/category_icon.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Satu baris transaksi: gambar kategori, nama, waktu dan metode bayar, serta
/// nominalnya.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.now,
    required this.onTap,
    this.showDate = true,
  });

  final TransactionModel transaction;
  final DateTime now;
  final VoidCallback onTap;

  /// false untuk daftar yang sudah dikelompokkan per hari: cukup jamnya.
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final time = showDate
        ? formatTransactionTime(t.date, now)
        : formatTime(t.date);

    return ListTile(
      onTap: onTap,
      leading: CategoryIcon(category: t.category),
      title: Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '$time · ${t.paymentMethod}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AmountText(t.amount),
    );
  }
}
