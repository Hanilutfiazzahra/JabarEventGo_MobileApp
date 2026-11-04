import 'package:flutter/material.dart';

import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_users.dart';
import '../../core/dummy/dummy_tickets.dart';
import 'check_in_page.dart';
import 'daftar_peserta_page.dart';

class BerandaPenyelenggaraPage extends StatelessWidget {
  final DummyUser pengguna;

  // Fungsi pembuka form dikirim dari MainShell.
  final VoidCallback onTambahEvent;

  const BerandaPenyelenggaraPage({
    super.key,
    required this.pengguna,
    required this.onTambahEvent,
  });

  @override
  Widget build(BuildContext konteks) {
    // Ambil event yang dimiliki penyelenggara ini.
    final List<DummyEvent> daftarEventSaya = [];

    for (final acara in dummyEvents) {
      if (acara.organizerId == pengguna.id) {
        daftarEventSaya.add(acara);
      }
    }

    // Ambil event yang dipublikasikan.
    final List<DummyEvent> daftarEventAktif = [];

    for (final acara in daftarEventSaya) {
      if (acara.eventStatus == 'dipublikasikan') {
        daftarEventAktif.add(acara);
      }
    }

    // Cari event mendatang dengan tanggal terdekat.
    DummyEvent? eventTerdekat;
    final sekarang = DateTime.now();

    for (final acara in daftarEventAktif) {
      if (acara.eventDate.isAfter(sekarang)) {
        if (eventTerdekat == null) {
          eventTerdekat = acara;
        } else if (acara.eventDate.isBefore(eventTerdekat.eventDate)) {
          eventTerdekat = acara;
        }
      }
    }

    final namaEventTerdekat =
        eventTerdekat?.title ?? 'Belum ada event mendatang';

    // Buat kartu kuota untuk setiap event aktif.
    final List<Widget> daftarKartuEvent = [];

    for (final acara in daftarEventAktif) {
      int jumlahPeserta = 0;

      for (final pendaftaran in dummyRegistrations) {
        if (pendaftaran.eventId == acara.id &&
            pendaftaran.registrationStatus != 'dibatalkan') {
          jumlahPeserta++;
        }
      }

      daftarKartuEvent.add(
        Card(
          child: ListTile(
            title: Text(acara.title),
            subtitle: Text(
              '$jumlahPeserta dari ${acara.ticketQuota} peserta',
            ),
          ),
        ),
      );
    }

    // Variabel lokal agar bisa digunakan oleh tombol check-in.
    final DummyEvent? acaraUntukCheckIn = eventTerdekat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Penyelenggara'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Halo, ${pengguna.name}'),
          const SizedBox(height: 8),
          const Text('Berikut ringkasan event kamu.'),
          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Event aktif'),
              subtitle: Text('${daftarEventAktif.length} event'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.upcoming),
              title: const Text('Event terdekat'),
              subtitle: Text(namaEventTerdekat),
            ),
          ),

          const SizedBox(height: 12),

          // Jalankan fungsi pembuka form dari MainShell.
          ElevatedButton.icon(
            onPressed: onTambahEvent,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Event'),
          ),

          const SizedBox(height: 16),
          const Text('Kuota terisi'),

          if (daftarKartuEvent.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Belum ada event aktif.'),
              ),
            )
          else
            Column(
              children: daftarKartuEvent,
            ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                konteks,
                MaterialPageRoute(
                  builder: (context) => DaftarPesertaPage(
                    pengguna: pengguna,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.people),
            label: const Text('Lihat daftar peserta'),
          ),

          if (acaraUntukCheckIn != null)
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  konteks,
                  MaterialPageRoute(
                    builder: (context) => CheckInPage(
                      acara: acaraUntukCheckIn,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Buka check-in'),
            ),
        ],
      ),
    );
  }
}
