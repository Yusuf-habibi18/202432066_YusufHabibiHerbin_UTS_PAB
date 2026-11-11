import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/core/widgets/category_icon.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';

/// Pengeluaran per kategori dengan gambar kategori dan batang porsinya
/// (ListView.separated).
class CategorySpendingCard extends StatelessWidget {
  const CategorySpendingCard({
    super.key,
    required this.categories,
    required this.total,
  });

  /// Kategori yang ada pengeluarannya, dari yang terbesar.
  final List<CategoryGroup> categories;

  /// Total semua kategori, untuk menghitung porsi.
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final group = categories[index];
          final share = total == 0 ? 0.0 : group.total / total;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CategoryIcon(category: group.category, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              group.category.label,
                              style: AppTextStyles.bodyStrong,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AmountText(group.total),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _ShareBar(
                              share: share,
                              color: group.category.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '${(share * 100).round()}%',
                              style: AppTextStyles.caption,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Batang porsi: lebar bagian berwarna sebanding dengan [share] (0–1).
class _ShareBar extends StatelessWidget {
  const _ShareBar({required this.share, required this.color});

  final double share;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.track,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: share,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
