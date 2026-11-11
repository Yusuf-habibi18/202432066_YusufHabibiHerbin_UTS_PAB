import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/currency_formatter.dart';
import 'package:uts_pab/core/utils/date_formatter.dart';
import 'package:uts_pab/features/dashboard/data/dashboard_summary.dart';

/// Grafik batang sederhana pengeluaran 6 bulan terakhir, dibuat dari
/// Container yang tingginya sebanding dengan totalnya.
class MonthlySpendingCard extends StatelessWidget {
  const MonthlySpendingCard({
    super.key,
    required this.monthly,
    required this.selectedMonth,
  });

  /// Dari yang terlama sampai bulan terpilih.
  final List<MonthlyTotal> monthly;
  final DateTime selectedMonth;

  static const _maxBarHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    final highest = monthly.fold(
      0,
      (max, m) => m.amount > max ? m.amount : max,
    );
    final average =
        monthly.fold(0, (sum, m) => sum + m.amount) ~/ monthly.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final m in monthly)
                  Expanded(
                    child: _Bar(
                      label: formatShortMonth(m.month),
                      amount: m.amount,
                      height: highest == 0
                          ? 4
                          : 4 + (_maxBarHeight - 4) * m.amount / highest,
                      selected: m.month == selectedMonth,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Rata-rata ${formatRupiah(average)} per bulan',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.amount,
    required this.height,
    required this.selected,
  });

  final String label;
  final int amount;
  final double height;

  /// Bulan terpilih diberi warna utama.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatRupiahCompact(amount).replaceFirst('Rp', ''),
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceTintStrong,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
