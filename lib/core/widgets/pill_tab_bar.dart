import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';

/// TabBar berbentuk pil: tab yang aktif berlatar putih. Memakai
/// DefaultTabController dari widget di atasnya.
class PillTabBar extends StatelessWidget {
  const PillTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  static const _radius = BorderRadius.all(Radius.circular(999));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: _radius,
      ),
      child: TabBar(
        tabs: tabs,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashBorderRadius: _radius,
        indicator: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: _radius,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.bodyBold,
        unselectedLabelStyle: AppTextStyles.bodyStrong,
      ),
    );
  }
}
