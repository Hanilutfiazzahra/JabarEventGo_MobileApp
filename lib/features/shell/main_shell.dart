import 'package:flutter/material.dart';

import '../../core/dummy/dummy_users.dart';
import '../auth/profile_page.dart';
import '../event/home_page.dart';
import '../ticket/ticket_page.dart';
import '../manage_event/event_data.dart';
import '../manage_event/manage_event_page.dart';
import '../checkin/beranda_penyelenggara_page.dart';
import '../checkin/daftar_peserta_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.user});

  final DummyUser user;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final EventData _manageEventData = EventData();

  @override
  void initState() {
    super.initState();
    if (widget.user.role == 'penyelenggara') {
      _index = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MAIN SHELL BERJALAN');
    debugPrint('ROLE USER: ${widget.user.role}');

    List<Widget> halaman;
    List<BottomNavigationBarItem> menu;

    if (widget.user.role == 'penyelenggara') {
      halaman = [
        BerandaPenyelenggaraPage(pengguna: widget.user),
        ManageEventPage(
          user: widget.user,
          data: _manageEventData,
        ),
        DaftarPesertaPage(pengguna: widget.user),
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
        HomePage(user: widget.user),
        TicketPage(user: widget.user),
        ProfilePage(user: widget.user),
      ];

      menu = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Tiket Saya',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    }

    return Scaffold(
      body: halaman[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        items: menu,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
      ),
    );
  }
}
