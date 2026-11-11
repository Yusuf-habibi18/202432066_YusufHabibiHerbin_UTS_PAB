/// Nama dan versi aplikasi untuk Pengaturan dan halaman lisensi.
abstract final class AppInfo {
  static const name = 'Finance Tracker';

  /// Samakan dengan `version` di pubspec.yaml.
  static const version = '1.0.0';

  /// Foto profil dari internet (Image.network): ikon 3D "Student" dari
  /// Fluent Emoji, lisensi MIT. Jika HP offline, avatar menampilkan inisial.
  static const avatarUrl =
      'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/'
      'assets/Student/Default/3D/student_3d_default.png';
}
