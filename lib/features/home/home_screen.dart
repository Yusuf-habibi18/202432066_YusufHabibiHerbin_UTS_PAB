import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/features/dashboard/presentation/dashboard_screen.dart';
import 'package:uts_pab/features/profile/profile_screen.dart';
import 'package:uts_pab/features/transactions/data/dummy_transactions.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/add_transaction_screen.dart';
import 'package:uts_pab/features/transactions/presentation/transactions_screen.dart';

/// Halaman utama dengan tiga tab di bawah (TabBar + TabBarView): Beranda,
/// Transaksi, dan Profil.
///
/// Semua transaksi disimpan di list [_transactions] selama aplikasi berjalan.
/// Data awalnya dummy data, lalu bertambah dari formulir Tambah Transaksi.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _userName = 'Yusuf';

  final List<TransactionModel> _transactions = generateDummyTransactions(
    DateTime.now(),
  );

  /// Membuka formulir, lalu menambahkan transaksi yang dikirim balik lewat
  /// Navigator.pop.
  Future<void> _openAddForm() async {
    final transaction = await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );
    if (transaction == null) return;
    setState(() => _transactions.add(transaction));
  }

  void _update(TransactionModel transaction) {
    setState(() {
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) _transactions[index] = transaction;
    });
  }

  void _delete(TransactionModel transaction) {
    setState(() => _transactions.removeWhere((t) => t.id == transaction.id));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            // Pindah tab hanya dengan menekan tab di bawah, agar tidak
            // bentrok dengan geser tab di halaman Transaksi.
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardScreen(
                userName: _userName,
                transactions: _transactions,
                onUpdate: _update,
                onDelete: _delete,
              ),
              TransactionsScreen(
                transactions: _transactions,
                onUpdate: _update,
                onDelete: _delete,
              ),
              ProfileScreen(userName: _userName, transactions: _transactions),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddForm,
          tooltip: 'Tambah transaksi',
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah'),
        ),
        bottomNavigationBar: const _BottomTabBar(),
      ),
    );
  }
}

/// Tab di bagian bawah layar.
class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          indicator: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(16),
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: AppTextStyles.caption,
          tabs: const [
            Tab(icon: Icon(Icons.space_dashboard_rounded), text: 'Beranda'),
            Tab(icon: Icon(Icons.receipt_long_rounded), text: 'Transaksi'),
            Tab(icon: Icon(Icons.person_rounded), text: 'Profil'),
          ],
        ),
      ),
    );
  }
}
