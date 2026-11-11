import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/illustrations.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/currency_formatter.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/features/dashboard/data/dashboard_summary.dart';

/// Kartu total pengeluaran bulan terpilih, jumlah transaksi, dan rata-rata
/// per hari.
class TotalCard extends StatelessWidget {
  const TotalCard({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(Illustrations.coin, width: 48, height: 48),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL PENGELUARAN',
                style: AppTextStyles.overline.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              AmountText(
                summary.total,
                style: AppTextStyles.display.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.receipt_long_rounded,
                    label: '${summary.count} transaksi',
                  ),
                  _InfoChip(
                    icon: Icons.today_rounded,
                    label:
                        'Rata-rata ${formatRupiah(summary.averagePerDay)}/hari',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          // Nominal yang panjang dipotong agar tidak melewati tepi kartu.
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
