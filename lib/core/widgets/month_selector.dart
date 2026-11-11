import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/date_formatter.dart';

/// Nama bulan dengan tombol ‹ dan › untuk pindah ke bulan sebelum atau
/// sesudahnya. Tidak bisa maju melewati bulan [now].
class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.month,
    required this.now,
    required this.onChanged,
  });

  /// Tanggal 1 bulan yang dipilih.
  final DateTime month;
  final DateTime now;
  final ValueChanged<DateTime> onChanged;

  bool get _isCurrentMonth =>
      month.year == now.year && month.month == now.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Bulan sebelumnya',
            onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppColors.primary,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(formatMonthYear(month), style: AppTextStyles.bodyStrong),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Bulan berikutnya',
            onPressed: _isCurrentMonth
                ? null
                : () => onChanged(DateTime(month.year, month.month + 1)),
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
