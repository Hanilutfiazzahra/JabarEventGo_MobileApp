import 'package:flutter/material.dart';

import '../../core/dummy/dummy_users.dart';
import '../../core/widgets/placeholder_page.dart';
import '../auth/profile_page.dart';

/// Halaman utama dengan menu di bawah (bottom navigation).
/// Menu berbeda untuk peserta dan penyelenggara (sesuai PRD 11.3).
///
/// Anggota lain: ganti PlaceholderPage di bawah dengan halaman kalian.
/// Halaman tambahan (detail, form) dibuka dengan Navigator.push biasa.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.user});

  /// User yang sedang login (dikirim dari halaman Login).
  final DummyUser user;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0; // nomor tab yang sedang dibuka

  @override
  Widget build(BuildContext context) {
    // Dua daftar yang urutannya harus sama:
    //   halaman = isi layar, menu = tombol di bawah.
    List<Widget> halaman;
    List<BottomNavigationBarItem> menu;

    if (widget.user.role == 'penyelenggara') {
      halaman = [
        const PlaceholderPage(title: 'Beranda Penyelenggara'),
        const PlaceholderPage(title: 'Kelola Event'),
        const PlaceholderPage(title: 'Peserta'),
        ProfilePage(user: widget.user),
      ];
      menu = const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kelola Event'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Peserta'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    } else {
      halaman = [
        const PlaceholderPage(title: 'Beranda'),
        const PlaceholderPage(title: 'Tiket Saya'),
        ProfilePage(user: widget.user),
      ];
      menu = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Tiket Saya'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    }

    return Scaffold(
      body: halaman[_index], // tampilkan halaman sesuai nomor tab
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        items: menu,
        // Saat tab ditekan, simpan nomornya lalu tampilkan ulang.
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
      ),
    );
  }
}
