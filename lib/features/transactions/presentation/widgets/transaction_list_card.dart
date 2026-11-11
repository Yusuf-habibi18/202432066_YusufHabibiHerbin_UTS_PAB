import 'package:flutter/material.dart';

import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/widgets/transaction_tile.dart';

/// Kartu berisi daftar transaksi dengan garis pemisah (ListView.separated).
///
/// Daftar ini berada di dalam daftar lain yang sudah bisa digulir, jadi
/// tingginya mengikuti isi (shrinkWrap) dan tidak digulir sendiri.
class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    super.key,
    required this.transactions,
    required this.now,
    required this.onTap,
    this.showDate = true,
  });

  final List<TransactionModel> transactions;
  final DateTime now;
  final ValueChanged<TransactionModel> onTap;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(indent: 76),
        itemBuilder: (context, index) => TransactionTile(
          transaction: transactions[index],
          now: now,
          showDate: showDate,
          onTap: () => onTap(transactions[index]),
        ),
      ),
    );
  }
}
