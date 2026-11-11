import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/categories.dart';

/// Gambar 3D kategori di atas kotak sudut-membulat berwarna kategori yang
/// dipudarkan.
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 44,
    this.circle = false,
  });

  final TransactionCategory category;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.color.withValues(alpha: 0.10),
            category.color.withValues(alpha: 0.22),
          ],
        ),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.32),
      ),
      child: Image.asset(
        category.illustration,
        width: size * 0.62,
        height: size * 0.62,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
