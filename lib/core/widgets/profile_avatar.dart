import 'package:flutter/material.dart';

import 'package:uts_pab/core/config/app_info.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';

/// Foto profil yang diambil dari internet dengan Image.network. Selama foto
/// dimuat, atau jika HP sedang offline, yang tampil inisial [name].
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.name, this.radius = 24});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = Text(
      name.isEmpty ? '?' : name[0].toUpperCase(),
      style: AppTextStyles.title.copyWith(
        color: AppColors.primary,
        fontSize: radius * 0.8,
      ),
    );

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceTint,
      child: Image.network(
        AppInfo.avatarUrl,
        width: radius * 1.4,
        height: radius * 1.4,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
            frame == null ? initial : child,
        errorBuilder: (context, error, stackTrace) => initial,
      ),
    );
  }
}
