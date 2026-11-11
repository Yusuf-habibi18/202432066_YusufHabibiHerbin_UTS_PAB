import 'package:flutter/material.dart';

import 'package:uts_pab/core/config/app_info.dart';
import 'package:uts_pab/core/constants/illustrations.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/currency_formatter.dart';
import 'package:uts_pab/core/widgets/profile_avatar.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Profil pengguna (foto dari internet), ringkasan semua transaksi, dan
/// informasi aplikasi.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.userName,
    required this.transactions,
  });

  final String userName;
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    final groups = groupByCategory(transactions);
    final top = groups.first.count > 0 ? groups.first : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        const Text('Profil', style: AppTextStyles.headline),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              ProfileAvatar(name: userName, radius: 40),
              const SizedBox(height: 12),
              Text(
                userName,
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '${transactions.length} transaksi tercatat',
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                image: Illustrations.coin,
                label: 'Total Pengeluaran',
                value: formatRupiah(totalAmount(transactions)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                image: top?.category.illustration ?? Illustrations.trophy,
                label: 'Kategori Terbesar',
                value: top?.category.label ?? '-',
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 8),
          child: Text('Tentang Aplikasi', style: AppTextStyles.title),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Image.asset(Illustrations.receipt, width: 36),
                title: const Text(AppInfo.name),
                subtitle: const Text('Versi ${AppInfo.version}'),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text('Kegunaan'),
                subtitle: Text(
                  'Mencatat pengeluaran harian, melihat totalnya, dan '
                  'menelusuri riwayat transaksi per kategori.',
                ),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.save_outlined),
                title: Text('Penyimpanan data'),
                subtitle: Text(
                  'Data disimpan sementara selama aplikasi berjalan dan '
                  'hilang saat aplikasi ditutup.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.image,
    required this.label,
    required this.value,
  });

  final String image;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image, width: 32, height: 32),
            const SizedBox(height: 12),
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            // Nama kategori yang panjang boleh turun ke baris kedua.
            Text(
              value,
              style: AppTextStyles.bodyBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
