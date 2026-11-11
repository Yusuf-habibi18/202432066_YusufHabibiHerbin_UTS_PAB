import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/illustrations.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/widgets/empty_state.dart';
import 'package:uts_pab/core/widgets/month_selector.dart';
import 'package:uts_pab/core/widgets/profile_avatar.dart';
import 'package:uts_pab/features/dashboard/data/dashboard_summary.dart';
import 'package:uts_pab/features/dashboard/presentation/widgets/category_spending_card.dart';
import 'package:uts_pab/features/dashboard/presentation/widgets/monthly_spending_card.dart';
import 'package:uts_pab/features/dashboard/presentation/widgets/total_card.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:uts_pab/features/transactions/presentation/widgets/transaction_list_card.dart';

/// Beranda: total pengeluaran bulan terpilih, pengeluaran per kategori,
/// 6 bulan terakhir, dan transaksi terbaru.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.userName,
    required this.transactions,
    required this.onUpdate,
    required this.onDelete,
  });

  final String userName;
  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel> onUpdate;
  final ValueChanged<TransactionModel> onDelete;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _openDetail(TransactionModel transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(
          transaction: transaction,
          onUpdate: widget.onUpdate,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final summary = DashboardSummary.fromTransactions(
      widget.transactions,
      month: _month,
      now: now,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          children: [
            ProfileAvatar(name: widget.userName),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Halo, ${widget.userName}',
                          style: AppTextStyles.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(Illustrations.wavingHand, width: 22),
                    ],
                  ),
                  const Text(
                    'Yuk, catat pengeluaranmu hari ini.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        MonthSelector(
          month: _month,
          now: now,
          onChanged: (month) => setState(() => _month = month),
        ),
        const SizedBox(height: 12),
        TotalCard(summary: summary),
        const _SectionTitle('Pengeluaran per Kategori'),
        if (summary.categories.isEmpty)
          const Card(
            child: EmptyState(
              image: Illustrations.chart,
              title: 'Belum ada pengeluaran di bulan ini',
              message: 'Tekan tombol Tambah untuk mencatat pengeluaran.',
            ),
          )
        else
          CategorySpendingCard(
            categories: summary.categories,
            total: summary.total,
          ),
        const _SectionTitle('6 Bulan Terakhir'),
        MonthlySpendingCard(monthly: summary.monthly, selectedMonth: _month),
        _SectionTitle(
          'Transaksi Terakhir',
          action: TextButton(
            // Pindah ke tab Transaksi.
            onPressed: () => DefaultTabController.of(context).animateTo(1),
            child: const Text('Lihat Semua'),
          ),
        ),
        if (summary.recent.isEmpty)
          const Card(
            child: EmptyState(
              image: Illustrations.receipt,
              title: 'Belum ada transaksi',
              message: 'Transaksi yang dicatat akan muncul di sini.',
            ),
          )
        else
          TransactionListCard(
            transactions: summary.recent,
            now: now,
            onTap: _openDetail,
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}
