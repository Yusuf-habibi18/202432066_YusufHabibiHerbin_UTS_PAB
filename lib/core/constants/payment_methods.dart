import 'package:flutter/material.dart';

/// Metode pembayaran yang bisa dipilih untuk transaksi manual. Label
/// disimpan apa adanya di kolom metode pembayaran.
const paymentMethods = [
  (label: 'Tunai', icon: Icons.payments_outlined),
  (label: 'QRIS', icon: Icons.qr_code_2_rounded),
  (label: 'Transfer', icon: Icons.account_balance_outlined),
  (label: 'E-Wallet', icon: Icons.account_balance_wallet_outlined),
  (label: 'Kartu Debit', icon: Icons.credit_card_rounded),
];
