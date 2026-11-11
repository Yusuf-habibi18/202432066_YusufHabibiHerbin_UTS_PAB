import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/core/widgets/category_icon.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';

/// Tab "Per Kategori": semua kategori dengan gambar, jumlah transaksi, total,
/// dan porsinya, dipisah garis (ListView.separated). Menekan kategori
/// membuka riwayat kategori itu.
class CategoryGroupList extends StatelessWidget {
  const CategoryGroupList({
    super.key,
    required this.groups,
    required this.onCategoryTap,
  });

  final List<CategoryGroup> groups;
  final ValueChanged<TransactionCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final total = groups.fold(0, (sum, g) => sum + g.total);

    return Card(
      child: ListView.separated(
        // Berada di dalam daftar tab yang sudah bisa digulir.
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: groups.length,
        separatorBuilder: (context, index) => const Divider(indent: 68),
        itemBuilder: (context, index) {
          final group = groups[index];
          final empty = group.count == 0;
          final percent = total == 0 ? 0 : (group.total * 100 / total).round();

          return ListTile(
            // Kategori tanpa pengeluaran dibuat pudar dan tidak bisa ditekan.
            enabled: !empty,
            onTap: () => onCategoryTap(group.category),
            horizontalTitleGap: 12,
            leading: Opacity(
              opacity: empty ? 0.5 : 1,
              child: CategoryIcon(category: group.category, size: 40),
            ),
            title: Text(
              group.category.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              empty
                  ? 'Belum ada pengeluaran'
                  : '${group.count} transaksi · $percent%',
            ),
            trailing: AmountText(
              group.total,
              style: AppTextStyles.amount.copyWith(
                color: empty ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}
