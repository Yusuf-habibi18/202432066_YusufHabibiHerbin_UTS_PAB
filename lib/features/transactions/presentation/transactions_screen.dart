import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/core/constants/illustrations.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/core/widgets/empty_state.dart';
import 'package:uts_pab/core/widgets/month_selector.dart';
import 'package:uts_pab/core/widgets/pill_tab_bar.dart';
import 'package:uts_pab/features/transactions/data/transaction_filter.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:uts_pab/features/transactions/presentation/widgets/category_group_list.dart';
import 'package:uts_pab/features/transactions/presentation/widgets/transaction_day_section.dart';

/// Halaman Transaksi dengan dua tab (TabBar + TabBarView):
/// - Riwayat: transaksi per hari, bisa dicari dan difilter per kategori.
/// - Per Kategori: pengeluaran bulan ini dikelompokkan per kategori.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
    required this.transactions,
    required this.onUpdate,
    required this.onDelete,
  });

  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel> onUpdate;
  final ValueChanged<TransactionModel> onDelete;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  var _month = DateTime(DateTime.now().year, DateTime.now().month);
  var _query = '';
  TransactionCategory? _category;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = null;
    });
  }

  /// Dari tab Per Kategori: pindah ke tab Riwayat dengan filter kategori itu.
  void _showCategory(BuildContext tabContext, TransactionCategory category) {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = category;
    });
    DefaultTabController.of(tabContext).animateTo(0);
  }

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

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text('Transaksi', style: AppTextStyles.headline),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PillTabBar(
              tabs: [
                Tab(text: 'Riwayat'),
                Tab(text: 'Per Kategori'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildHistory(now),
                Builder(
                  builder: (tabContext) => _buildCategories(tabContext, now),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab Riwayat: baris pertama berisi bulan, pencarian, filter, dan total;
  /// baris berikutnya satu per hari (ListView.builder).
  Widget _buildHistory(DateTime now) {
    final filtered = filterTransactions(
      widget.transactions,
      month: _month,
      query: _query,
      category: _category,
    );
    final days = groupByDay(filtered);
    final hasFilters = _query.isNotEmpty || _category != null;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: 1 + (days.isEmpty ? 1 : days.length),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHistoryHeader(now, filtered);
        }
        if (days.isEmpty) {
          return hasFilters
              ? EmptyState(
                  image: Illustrations.magnifier,
                  title: 'Tidak ada transaksi yang cocok',
                  message: 'Coba ubah kata kunci atau kategori.',
                  action: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Hapus filter'),
                  ),
                )
              : const EmptyState(
                  image: Illustrations.receipt,
                  title: 'Belum ada transaksi di bulan ini',
                  message: 'Tekan tombol Tambah untuk mencatat pengeluaran.',
                );
        }
        return TransactionDaySection(
          day: days[index - 1],
          now: now,
          onTransactionTap: _openDetail,
        );
      },
    );
  }

  Widget _buildHistoryHeader(DateTime now, List<TransactionModel> filtered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MonthSelector(
          month: _month,
          now: now,
          onChanged: (month) => setState(() => _month = month),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (query) => setState(() => _query = query),
          decoration: InputDecoration(
            hintText: 'Cari nama atau catatan…',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
        ),
        const SizedBox(height: 12),
        // Chip kategori yang bisa digeser ke samping.
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: TransactionCategory.values.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _CategoryChip(
                  label: 'Semua',
                  selected: _category == null,
                  onSelected: () => setState(() => _category = null),
                );
              }
              final category = TransactionCategory.values[index - 1];
              return _CategoryChip(
                label: category.label,
                image: category.illustration,
                selected: category == _category,
                onSelected: () => setState(() => _category = category),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SummaryBar(
          label: '${filtered.length} transaksi',
          total: totalAmount(filtered),
        ),
      ],
    );
  }

  /// Tab Per Kategori: total bulan ini lalu daftar semua kategori.
  Widget _buildCategories(BuildContext tabContext, DateTime now) {
    final inMonth = filterTransactions(widget.transactions, month: _month);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        MonthSelector(
          month: _month,
          now: now,
          onChanged: (month) => setState(() => _month = month),
        ),
        const SizedBox(height: 16),
        SummaryBar(
          label: '${inMonth.length} transaksi',
          total: totalAmount(inMonth),
        ),
        const SizedBox(height: 16),
        CategoryGroupList(
          groups: groupByCategory(inMonth),
          onCategoryTap: (category) => _showCategory(tabContext, category),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.image,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  /// Gambar kategori, null untuk chip "Semua".
  final String? image;

  @override
  Widget build(BuildContext context) {
    final image = this.image;

    return ChoiceChip(
      label: Text(label),
      avatar: image == null ? null : Image.asset(image, width: 18),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: AppTextStyles.body.copyWith(
        color: selected ? Colors.white : AppColors.textPrimary,
      ),
    );
  }
}

/// Jumlah transaksi dan totalnya, di atas kartu bergradien.
class SummaryBar extends StatelessWidget {
  const SummaryBar({super.key, required this.label, required this.total});

  /// Misalnya "12 transaksi".
  final String label;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(Illustrations.receipt),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyStrong.copyWith(color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
              AmountText(
                total,
                style: AppTextStyles.amount.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
