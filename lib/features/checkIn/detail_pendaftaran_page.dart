import 'package:flutter/material.dart';
import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_tickets.dart';
import 'check_in_page.dart';

class DetailPendaftaranPage extends StatelessWidget {
  final DummyEvent acara;
  final DummyTicket tiket;

  const DetailPendaftaranPage({
    super.key,
    required this.acara,
    required this.tiket,
  });

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

  String formatTanggal(DateTime tanggal) {
    return tanggal.day.toString() +
        '/' +
        tanggal.month.toString() +
        '/' +
        tanggal.year.toString();
  }

  @override
  Widget build(BuildContext konteks) {
    DummyRegistration? pendaftaran = registrationOf(tiket);

    if (pendaftaran == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pendaftaran')),
        body: const Center(
          child: Text('Data pendaftaran tidak ditemukan.'),
        ),
      );
    }

    Widget tombolCheckIn = const SizedBox.shrink();

    if (tiket.ticketStatus == 'aktif') {
      tombolCheckIn = ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            konteks,
            MaterialPageRoute(
              builder: (konteks) {
                return CheckInPage(
                  acara: acara,
                  kodeAwal: tiket.ticketCode,
                );
              },
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Check-in tiket ini'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pendaftaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            acara.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ' + pendaftaran.namaPeserta),
                  const SizedBox(height: 8),
                  Text('Email: ' + pendaftaran.emailPeserta),
                  const SizedBox(height: 8),
                  Text(
                    'Tanggal daftar: ' +
                        formatTanggal(pendaftaran.registrationDate),
                  ),
                  const SizedBox(height: 8),
                  Text('Kode tiket: ' + tiket.ticketCode),
                  const SizedBox(height: 8),
                  Text(
                    'Status tiket: ' + labelStatus(tiket.ticketStatus),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          tombolCheckIn,
        ],
      ),
    );
  }
}
