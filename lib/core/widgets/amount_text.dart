import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/currency_formatter.dart';

/// Nominal rupiah dengan angka berlebar sama.
class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    super.key,
    this.style = AppTextStyles.amount,
    this.compact = false,
  });

  final int amount;
  final TextStyle style;

  /// true → "Rp115rb", false → "Rp115.000".
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      compact ? formatRupiahCompact(amount) : formatRupiah(amount),
      style: style.copyWith(fontFeatures: AppTextStyles.tabularFigures),
      maxLines: 1,
    );
  }
}
