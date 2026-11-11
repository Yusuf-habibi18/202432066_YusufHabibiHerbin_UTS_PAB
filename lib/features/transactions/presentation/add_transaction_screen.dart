import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/categories.dart';
import 'package:uts_pab/core/constants/payment_methods.dart';
import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';
import 'package:uts_pab/core/utils/currency_formatter.dart';
import 'package:uts_pab/core/utils/date_formatter.dart';
import 'package:uts_pab/features/transactions/data/transaction_model.dart';

/// Formulir tambah transaksi. Jika [initial] diisi, formulir dipakai untuk
/// mengubah transaksi tersebut.
///
/// Setelah disimpan, transaksi dikirim kembali ke halaman sebelumnya lewat
/// `Navigator.pop(context, transaksi)`.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.initial});

  final TransactionModel? initial;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  var _category = TransactionCategory.foodBeverage;
  var _paymentMethod = paymentMethods.first.label;
  late DateTime _date;

  /// Pesan error baru ditampilkan setelah tombol Simpan ditekan.
  var _submitted = false;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);

    final initial = widget.initial;
    if (initial != null) {
      _amountController.text = initial.amount.toString();
      _titleController.text = initial.title;
      _noteController.text = initial.note ?? '';
      _category = initial.category;
      _paymentMethod = initial.paymentMethod;
      _date = DateTime(initial.date.year, initial.date.month, initial.date.day);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// Nominal dari kolom input, boleh ditulis dengan titik ("25.000").
  int? get _amount =>
      int.tryParse(_amountController.text.replaceAll('.', '').trim());

  String? get _amountError {
    final amount = _amount;
    if (_amountController.text.trim().isEmpty) return 'Nominal wajib diisi';
    if (amount == null) return 'Nominal hanya boleh berisi angka';
    if (amount <= 0) return 'Nominal harus lebih dari 0';
    return null;
  }

  String? get _titleError => _titleController.text.trim().isEmpty
      ? 'Nama pengeluaran wajib diisi'
      : null;

  bool get _isToday {
    final now = DateTime.now();
    return _date.year == now.year &&
        _date.month == now.month &&
        _date.day == now.day;
  }

  void _changeDate(int days) {
    setState(() {
      _date = DateTime(_date.year, _date.month, _date.day + days);
    });
  }

  void _save() {
    if (_amountError != null || _titleError != null) {
      setState(() => _submitted = true);
      return;
    }

    // Jam transaksi: jam sekarang untuk transaksi baru, jam lama untuk
    // transaksi yang diubah.
    final time = widget.initial?.date ?? DateTime.now();
    final note = _noteController.text.trim();
    final transaction = TransactionModel(
      id: widget.initial?.id ?? 'trx-${DateTime.now().microsecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: _amount!,
      category: _category,
      date: DateTime(
        _date.year,
        _date.month,
        _date.day,
        time.hour,
        time.minute,
      ),
      paymentMethod: _paymentMethod,
      note: note.isEmpty ? null : note,
    );
    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    final amount = _amount;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Ubah Transaksi' : 'Tambah Transaksi'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _Label('Nominal'),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.title,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixText: 'Rp ',
              hintText: '0',
              errorText: _submitted ? _amountError : null,
              // Nominal ditampilkan ulang dengan pemisah ribuan.
              helperText: amount != null && amount > 0
                  ? formatRupiah(amount)
                  : null,
            ),
          ),
          const _Label('Nama Pengeluaran'),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'cth. Makan siang, Kopi Kenangan',
              errorText: _submitted ? _titleError : null,
            ),
          ),
          const _Label('Kategori'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in TransactionCategory.values)
                _OptionChip(
                  label: category.label,
                  avatar: Image.asset(category.illustration, width: 20),
                  selected: category == _category,
                  onSelected: () => setState(() => _category = category),
                ),
            ],
          ),
          const _Label('Tanggal'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Hari sebelumnya',
                  onPressed: () => _changeDate(-1),
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Text(
                    formatFullDate(_date),
                    style: AppTextStyles.bodyStrong,
                    textAlign: TextAlign.center,
                  ),
                ),
                // Transaksi tidak boleh di masa depan.
                IconButton(
                  tooltip: 'Hari berikutnya',
                  onPressed: _isToday ? null : () => _changeDate(1),
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const _Label('Metode Pembayaran'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final method in paymentMethods)
                _OptionChip(
                  label: method.label,
                  avatar: Icon(
                    method.icon,
                    size: 18,
                    color: method.label == _paymentMethod
                        ? Colors.white
                        : AppColors.primary,
                  ),
                  selected: method.label == _paymentMethod,
                  onSelected: () =>
                      setState(() => _paymentMethod = method.label),
                ),
            ],
          ),
          const _Label('Catatan (opsional)'),
          TextField(
            controller: _noteController,
            maxLines: 3,
            maxLength: 120,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Tambahkan catatan pengeluaran…',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded),
            label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Transaksi'),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: AppTextStyles.bodyStrong),
    );
  }
}

/// Pilihan berbentuk chip: berwarna utama saat dipilih.
class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.avatar,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final Widget avatar;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      avatar: avatar,
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: AppTextStyles.body.copyWith(
        color: selected ? Colors.white : AppColors.textPrimary,
      ),
    );
  }
}
