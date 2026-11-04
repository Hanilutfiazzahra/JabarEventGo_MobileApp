import 'package:flutter/material.dart';

import '../../core/dummy/dummy_users.dart';
import '../auth/profile_page.dart';
import '../event/home_page.dart';
import '../ticket/ticket_page.dart';

import '../manage_event/event_data.dart';
import '../manage_event/manage_event_page.dart';
import '../manage_event/event_form_page.dart';

import '../checkIn/beranda_penyelenggara_page.dart';
import '../checkIn/daftar_peserta_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.user,
  });

  final DummyUser user;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Indeks 0 adalah Beranda, untuk peserta dan penyelenggara.
  int _index = 0;

  // Data yang sama dipakai oleh form dan halaman Kelola Event.
  final EventData _manageEventData = EventData();

  // Membuka halaman form tambah event.
  Future<void> _bukaFormTambahEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventFormPage(
          owner: widget.user.id,
          data: _manageEventData,
        ),
      ),
    );

    // Perbarui tampilan setelah kembali dari form.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> halaman;
    final List<BottomNavigationBarItem> menu;

    if (widget.user.role == 'penyelenggara') {
      halaman = [
        // Indeks 0: Beranda.
        BerandaPenyelenggaraPage(
          pengguna: widget.user,
          onTambahEvent: _bukaFormTambahEvent,
        ),

        // Indeks 1: Kelola Event.
        ManageEventPage(
          user: widget.user,
          data: _manageEventData,
        ),

        // Indeks 2: Peserta.
        DaftarPesertaPage(
          pengguna: widget.user,
        ),

        // Indeks 3: Profil.
        ProfilePage(
          user: widget.user,
        ),
      ];

      menu = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Kelola Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Peserta',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    } else {
      halaman = [
        HomePage(
          user: widget.user,
        ),
        TicketPage(
          user: widget.user,
        ),
        ProfilePage(
          user: widget.user,
        ),
      ];

      menu = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Tiket Saya',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ];
    }

    return Scaffold(
      body: halaman[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        items: menu,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
