import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_text_styles.dart';

/// Gambar, judul, dan pesan untuk daftar yang masih kosong.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.image,
    required this.title,
    this.message,
    this.action,
  });

  /// Path gambar di folder aset, misalnya dari Illustrations.
  final String image;
  final String title;
  final String? message;

  /// Tombol opsional di bawah pesan, misalnya "Hapus filter".
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    final action = this.action;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(image, width: 72, height: 72),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.bodyStrong,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action],
        ],
      ),
    );
  }
}
