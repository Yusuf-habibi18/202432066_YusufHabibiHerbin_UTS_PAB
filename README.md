# Personal Finance Tracker

Aplikasi pencatatan keuangan pribadi untuk UTS Praktikum Pemrograman Aplikasi
Bergerak 2026/2027 (Studi Kasus 1). Aplikasi ini dibuat dengan Flutter dan
membantu mahasiswa mencatat pengeluaran, melihat totalnya, dan menelusuri
riwayat transaksi per kategori.

- **Nama:** Yusuf Habibi Herbin
- **NIM:** 202432066

## Fitur

| Rekomendasi fitur (Kasus 1) | Implementasi |
|---|---|
| Daftar transaksi pengeluaran | Tab **Transaksi → Riwayat**: transaksi per hari, bisa dicari dan difilter per kategori dan bulan |
| Informasi total pengeluaran | Kartu total di **Beranda** dan ringkasan total di tab Transaksi |
| Kategori beserta gambar/ikon | 9 kategori, masing-masing dengan gambar 3D (`assets/images/icons3d`) |
| Tambah transaksi lewat formulir | Tombol **Tambah** membuka formulir: nominal, nama, kategori, tanggal, metode bayar, catatan |
| Detail transaksi | Menekan transaksi membuka **Detail Transaksi**, yang juga bisa mengubah atau menghapus transaksi |
| Pengelompokan per kategori | Tab **Transaksi → Per Kategori** dan bagian "Pengeluaran per Kategori" di Beranda |

Halaman: **Beranda**, **Transaksi** (tab Riwayat dan Per Kategori), **Profil**,
**Tambah/Ubah Transaksi**, dan **Detail Transaksi**.

## Penerapan materi praktikum

Aplikasi hanya memakai materi yang dipelajari selama praktikum.

| Materi | Lokasi di kode |
|---|---|
| Widget dan Layout | Seluruh `lib/` (`Scaffold`, `Column`, `Row`, `Card`, `Container`, `Wrap`, `ListTile`, dll.) |
| Input data | `TextField` nominal, nama, dan catatan di [add_transaction_screen.dart](lib/features/transactions/presentation/add_transaction_screen.dart); kolom pencarian di [transactions_screen.dart](lib/features/transactions/presentation/transactions_screen.dart) |
| Button | `FloatingActionButton` (Tambah), `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton` |
| `Navigator.push` / `Navigator.pop` dan pengiriman data | [home_screen.dart](lib/features/home/home_screen.dart) membuka formulir dan menerima transaksi baru dari `Navigator.pop(context, transaksi)`. Detail menerima transaksi lewat konstruktor, dan formulir ubah mengembalikan hasilnya lewat `pop`. |
| `ListView.builder` | Daftar per hari di tab Riwayat, [transactions_screen.dart](lib/features/transactions/presentation/transactions_screen.dart) |
| `ListView.separated` | Daftar transaksi dengan garis pemisah, [transaction_list_card.dart](lib/features/transactions/presentation/widgets/transaction_list_card.dart); daftar kategori, [category_group_list.dart](lib/features/transactions/presentation/widgets/category_group_list.dart) |
| `TabBar` dan `TabBarView` | Tab bawah Beranda/Transaksi/Profil di [home_screen.dart](lib/features/home/home_screen.dart); tab Riwayat/Per Kategori di [transactions_screen.dart](lib/features/transactions/presentation/transactions_screen.dart) |
| `Image.asset` | Gambar kategori, [category_icon.dart](lib/core/widgets/category_icon.dart), dan gambar di kartu atau keadaan kosong |
| `Image.network` | Foto profil di Beranda dan Profil, [profile_avatar.dart](lib/core/widgets/profile_avatar.dart) |

## Data

- Data awal berupa dummy data yang dibuat di program
  ([dummy_transactions.dart](lib/features/transactions/data/dummy_transactions.dart)).
- Semua transaksi disimpan di sebuah `List` di
  [home_screen.dart](lib/features/home/home_screen.dart) dan diperbarui dengan
  `setState`. Tidak memakai database, jadi data hilang saat aplikasi ditutup.
- Foto profil diambil dari internet. Jika HP offline, avatar menampilkan
  inisial nama.

## Menjalankan

Membutuhkan Flutter SDK (Dart ^3.13) dan perangkat Android atau emulator.

```bash
flutter pub get
flutter run
```

Test dan analisis kode:

```bash
flutter analyze
flutter test
```

Build APK:

```bash
flutter build apk --release
```

## Struktur folder

```
lib/
  main.dart, app.dart
  core/          tema, warna, format rupiah/tanggal, kategori, widget bersama
  features/
    home/          halaman utama: tab bawah, list transaksi, tombol Tambah
    dashboard/     Beranda: total, per kategori, 6 bulan terakhir, transaksi terbaru
    transactions/  Riwayat, Per Kategori, formulir tambah/ubah, detail transaksi
    profile/       Profil dan informasi aplikasi
test/            unit test dan widget test
assets/          font dan gambar 3D kategori
```

## Lisensi aset

- Font Outfit dan Manrope: SIL Open Font License 1.1 (`assets/fonts/OFL-*.txt`)
- Gambar 3D Fluent Emoji (Microsoft), termasuk foto profil: MIT
  (`assets/images/icons3d/LICENSE-fluentui-emoji.txt`)
