import 'package:flutter/material.dart';

import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_tickets.dart';
import '../../core/dummy/dummy_users.dart';
import 'detail_pendaftaran_page.dart';

class DaftarPesertaPage extends StatefulWidget {
  final DummyUser pengguna;

  const DaftarPesertaPage({
    super.key,
    required this.pengguna,
  });

  @override
  State<DaftarPesertaPage> createState() {
    return DaftarPesertaPageState();
  }
}

class DaftarPesertaPageState extends State<DaftarPesertaPage> {
  int? idEventDipilih;

  String labelStatus(String status) {
    if (status == 'aktif') {
      return 'Aktif';
    }

    if (status == 'sudah_checkin') {
      return 'Sudah check-in';
    }

    if (status == 'dibatalkan') {
      return 'Dibatalkan';
    }

    return status;
  }

  @override
  Widget build(BuildContext konteks) {
    List<DummyEvent> daftarEventSaya = [];

    for (int nomor = 0; nomor < dummyEvents.length; nomor++) {
      if (dummyEvents[nomor].organizerId == widget.pengguna.id) {
        daftarEventSaya.add(dummyEvents[nomor]);
      }
    }

    if (daftarEventSaya.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daftar Peserta')),
        body: const Center(
          child: Text('Belum ada event untuk ditampilkan.'),
        ),
      );
    }

    int idEvent = daftarEventSaya[0].id;

    for (int nomor = 0; nomor < daftarEventSaya.length; nomor++) {
      if (daftarEventSaya[nomor].id == idEventDipilih) {
        idEvent = daftarEventSaya[nomor].id;
        break;
      }
    }

    DummyEvent eventTerpilih = daftarEventSaya[0];

    for (int nomor = 0; nomor < daftarEventSaya.length; nomor++) {
      if (daftarEventSaya[nomor].id == idEvent) {
        eventTerpilih = daftarEventSaya[nomor];
        break;
      }
    }

    List<DropdownMenuItem<int>> pilihanEvent = [];

    for (int nomor = 0; nomor < daftarEventSaya.length; nomor++) {
      pilihanEvent.add(
        DropdownMenuItem<int>(
          value: daftarEventSaya[nomor].id,
          child: Text(daftarEventSaya[nomor].title),
        ),
      );
    }

    List<DummyTicket> daftarTiket = [];

    for (int nomor = 0; nomor < dummyTickets.length; nomor++) {
      if (dummyTickets[nomor].eventId == idEvent) {
        daftarTiket.add(dummyTickets[nomor]);
      }
    }

    Widget daftarPeserta;

    if (daftarTiket.isEmpty) {
      daftarPeserta = const Center(
        child: Text('Belum ada peserta yang mendaftar.'),
      );
    } else {
      daftarPeserta = ListView.builder(
        itemCount: daftarTiket.length,
        itemBuilder: (konteks, nomor) {
          DummyTicket tiket = daftarTiket[nomor];
          DummyRegistration? pendaftaran = registrationOf(tiket);

          if (pendaftaran == null) {
            return const SizedBox.shrink();
          }

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 5,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(pendaftaran.namaPeserta),
              subtitle: Text(
                pendaftaran.emailPeserta +
                    '\n' +
                    tiket.ticketCode +
                    ' - ' +
                    labelStatus(tiket.ticketStatus),
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  konteks,
                  MaterialPageRoute(
                    builder: (konteks) {
                      return DetailPendaftaranPage(
                        acara: eventTerpilih,
                        tiket: tiket,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peserta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<int>(
              value: idEvent,
              decoration: const InputDecoration(
                labelText: 'Pilih event',
                border: OutlineInputBorder(),
              ),
              items: pilihanEvent,
              onChanged: (int? idEventBaru) {
                if (idEventBaru != null) {
                  setState(() {
                    idEventDipilih = idEventBaru;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Peserta: ' + daftarTiket.length.toString(),
              ),
            ),
          ),
          Expanded(
            child: daftarPeserta,
          ),
        ],
      ),
    );
  }
}
