import 'package:flutter/material.dart';

import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_users.dart';
import '../../core/dummy/dummy_tickets.dart';
import 'check_in_page.dart';
import 'daftar_peserta_page.dart';

class BerandaPenyelenggaraPage extends StatelessWidget {
  final DummyUser pengguna;

  const BerandaPenyelenggaraPage({
    super.key,
    required this.pengguna,
  });

  @override
  Widget build(BuildContext konteks) {
    List<DummyEvent> daftarEventSaya = [];

    for (int nomor = 0; nomor < dummyEvents.length; nomor++) {
      if (dummyEvents[nomor].organizerId == pengguna.id) {
        daftarEventSaya.add(dummyEvents[nomor]);
      }
    }

    List<DummyEvent> daftarEventAktif = [];

    for (int nomor = 0; nomor < daftarEventSaya.length; nomor++) {
      if (daftarEventSaya[nomor].eventStatus == 'dipublikasikan') {
        daftarEventAktif.add(daftarEventSaya[nomor]);
      }
    }

    DummyEvent? eventTerdekat;

    for (int nomor = 0; nomor < daftarEventAktif.length; nomor++) {
      DummyEvent acara = daftarEventAktif[nomor];

      if (acara.eventDate.isAfter(DateTime.now())) {
        if (eventTerdekat == null) {
          eventTerdekat = acara;
        } else if (acara.eventDate.isBefore(eventTerdekat.eventDate)) {
          eventTerdekat = acara;
        }
      }
    }

    String namaEventTerdekat = 'Belum ada event mendatang';

    if (eventTerdekat != null) {
      namaEventTerdekat = eventTerdekat.title;
    }

    List<Widget> daftarKartuEvent = [];

    for (int nomor = 0; nomor < daftarEventAktif.length; nomor++) {
      DummyEvent acara = daftarEventAktif[nomor];
      int jumlahPeserta = 0;

      for (int urutan = 0; urutan < dummyRegistrations.length; urutan++) {
        DummyRegistration pendaftaran = dummyRegistrations[urutan];

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
              jumlahPeserta.toString() +
                  ' dari ' +
                  acara.ticketQuota.toString() +
                  ' peserta',
            ),
          ),
        ),
      );
    }

    Widget bagianKuota;

    if (daftarKartuEvent.isEmpty) {
      bagianKuota = const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Belum ada event aktif.'),
        ),
      );
    } else {
      bagianKuota = Column(
        children: daftarKartuEvent,
      );
    }

    Widget tombolCheckIn = const SizedBox.shrink();
    final DummyEvent? acaraUntukCheckIn = eventTerdekat;

    if (acaraUntukCheckIn != null) {
      tombolCheckIn = OutlinedButton.icon(
        onPressed: () {
          Navigator.push(
            konteks,
            MaterialPageRoute(
              builder: (konteks) {
                return CheckInPage(acara: acaraUntukCheckIn);
              },
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Buka check-in'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Penyelenggara'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Halo, ' + pengguna.name),
          const SizedBox(height: 8),
          const Text('Berikut ringkasan event kamu.'),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Event aktif'),
              subtitle: Text(
                daftarEventAktif.length.toString() + ' event',
              ),
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
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(konteks).showSnackBar(
                const SnackBar(
                  content: Text('Form tambah event belum tersedia.'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Event'),
          ),
          const SizedBox(height: 16),
          const Text('Kuota terisi'),
          bagianKuota,
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                konteks,
                MaterialPageRoute(
                  builder: (konteks) {
                    return DaftarPesertaPage(pengguna: pengguna);
                  },
                ),
              );
            },
            icon: const Icon(Icons.people),
            label: const Text('Lihat daftar peserta'),
          ),
          tombolCheckIn,
        ],
      ),
    );
  }
}
