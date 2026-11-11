import 'package:flutter/material.dart';

import 'package:uts_pab/core/constants/illustrations.dart';

/// Sembilan kategori pengeluaran dari proposal. Warna, ikon, dan gambar 3D
/// tiap kategori dipakai sama di grafik, daftar, dan filter.
enum TransactionCategory {
  foodBeverage(
    'Makanan & Minuman',
    'Makanan',
    Icons.restaurant_rounded,
    Color(0xFFF97316),
    Illustrations.food,
  ),
  transportation(
    'Transportasi',
    'Transport',
    Icons.two_wheeler_rounded,
    Color(0xFF3B82F6),
    Illustrations.transport,
  ),
  shopping(
    'Belanja',
    'Belanja',
    Icons.shopping_bag_rounded,
    Color(0xFFA855F7),
    Illustrations.shopping,
  ),
  entertainment(
    'Hiburan',
    'Hiburan',
    Icons.movie_rounded,
    Color(0xFFEC4899),
    Illustrations.entertainment,
  ),
  groceries(
    'Kebutuhan Harian',
    'Harian',
    Icons.shopping_cart_rounded,
    Color(0xFF22C55E),
    Illustrations.groceries,
  ),
  billsUtilities(
    'Tagihan & Utilitas',
    'Tagihan',
    Icons.lightbulb_rounded,
    Color(0xFFF59E0B),
    Illustrations.bills,
  ),
  health(
    'Kesehatan',
    'Kesehatan',
    Icons.medical_services_rounded,
    Color(0xFF14B8A6),
    Illustrations.health,
  ),
  education(
    'Pendidikan',
    'Pendidikan',
    Icons.school_rounded,
    Color(0xFF6366F1),
    Illustrations.education,
  ),
  others(
    'Lainnya',
    'Lainnya',
    Icons.category_rounded,
    Color(0xFF94A3B8),
    Illustrations.others,
  );

  const TransactionCategory(
    this.label,
    this.shortLabel,
    this.icon,
    this.color,
    this.illustration,
  );

  final String label;

  /// Label pendek untuk ruang sempit, misalnya statistik "Terbesar".
  final String shortLabel;

  /// Ikon datar untuk tempat kecil seperti chip.
  final IconData icon;
  final Color color;

  /// Gambar 3D untuk ikon kategori di daftar, grid, dan detail.
  final String illustration;
}
