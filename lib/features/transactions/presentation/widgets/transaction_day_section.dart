import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/date_formatter.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/widgets/transaction_list_card.dart';

/// Satu hari di tab Riwayat: tanggal, total hari itu, dan transaksinya.
class TransactionDaySection extends StatelessWidget {
  const TransactionDaySection({
    super.key,
    required this.day,
    required this.now,
    required this.onTransactionTap,
  });

  final TransactionDay day;
  final DateTime now;
  final ValueChanged<TransactionModel> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatDayLabel(day.date, now).toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              AmountText(
                day.total,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        TransactionListCard(
          transactions: day.transactions,
          now: now,
          showDate: false,
          onTap: onTransactionTap,
        ),
      ],
    );
  }
}
