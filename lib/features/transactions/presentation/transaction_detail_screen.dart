import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/date_formatter.dart';
import 'package:uts_pab/core/widgets/amount_text.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';
import 'package:uts_pab/features/transactions/presentation/add_transaction_screen.dart';

/// Detail satu transaksi yang dikirim dari halaman daftar.
///
/// [onUpdate] dan [onDelete] memberi tahu halaman utama agar daftar
/// transaksinya ikut berubah.
class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({
    super.key,
    required this.transaction,
    required this.onUpdate,
    required this.onDelete,
  });

  final TransactionModel transaction;
  final ValueChanged<TransactionModel> onUpdate;
  final ValueChanged<TransactionModel> onDelete;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionModel _transaction = widget.transaction;

  /// true setelah tombol Hapus ditekan sekali: tombol berubah menjadi
  /// konfirmasi agar transaksi tidak terhapus tanpa sengaja.
  var _confirmingDelete = false;

  Future<void> _edit() async {
    final edited = await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(initial: _transaction),
      ),
    );
    if (edited == null) return;
    widget.onUpdate(edited);
    setState(() => _transaction = edited);
  }

  void _delete() {
    widget.onDelete(_transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = _transaction;
    final note = t.note;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(t.category.illustration),
                ),
                const SizedBox(height: 16),
                Text(
                  t.title,
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                AmountText(
                  t.amount,
                  style: AppTextStyles.display.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.category_outlined,
                    label: 'Kategori',
                    value: t.category.label,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Tanggal',
                    value: formatFullDate(t.date),
                  ),
                  _DetailRow(
                    icon: Icons.schedule_rounded,
                    label: 'Jam',
                    value: formatTime(t.date),
                  ),
                  _DetailRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Metode Pembayaran',
                    value: t.paymentMethod,
                  ),
                  _DetailRow(
                    icon: Icons.notes_rounded,
                    label: 'Catatan',
                    value: note ?? 'Tidak ada catatan',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_confirmingDelete) ...[
            Text(
              'Hapus transaksi ini? Data yang dihapus tidak bisa dikembalikan.',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _delete,
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Ya, Hapus'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => setState(() => _confirmingDelete = false),
              child: const Text('Batal'),
            ),
          ] else ...[
            FilledButton.icon(
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Ubah Transaksi'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => setState(() => _confirmingDelete = true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus Transaksi'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTextStyles.caption),
      subtitle: Text(value, style: AppTextStyles.bodyStrong),
    );
  }
}
