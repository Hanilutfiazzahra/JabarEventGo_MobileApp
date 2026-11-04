import 'package:flutter/material.dart';
import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_tickets.dart';

class CheckInPage extends StatefulWidget {
  final DummyEvent acara;
  final String? kodeAwal;

  const CheckInPage({
    super.key,
    required this.acara,
    this.kodeAwal,
  });

  @override
  State<CheckInPage> createState() {
    return CheckInPageState();
  }
}

class CheckInPageState extends State<CheckInPage> {
  late TextEditingController pengendaliKode;

  String pesanHasil = '';
  bool checkInBerhasil = false;

  @override
  void initState() {
    super.initState();

    String kodeAwal = '';

    if (widget.kodeAwal != null) {
      kodeAwal = widget.kodeAwal.toString();
    }

    pengendaliKode = TextEditingController(text: kodeAwal);
  }

  @override
  void dispose() {
    pengendaliKode.dispose();
    super.dispose();
  }

  void periksaTiket() {
    String kodeTiket = pengendaliKode.text.trim().toUpperCase();

    if (kodeTiket.isEmpty) {
      tampilkanHasil('Kode tiket wajib diisi.', false);
      return;
    }

    bool formatBenar = true;

    if (kodeTiket.startsWith('JEG-') == false || kodeTiket.length != 10) {
      formatBenar = false;
    } else {
      for (int nomor = 4; nomor < kodeTiket.length; nomor++) {
        String karakter = kodeTiket[nomor];

        bool karakterAngka =
            karakter.compareTo('0') >= 0 && karakter.compareTo('9') <= 0;

        bool karakterHuruf =
            karakter.compareTo('A') >= 0 && karakter.compareTo('Z') <= 0;

        if (karakterAngka == false && karakterHuruf == false) {
          formatBenar = false;
        }
      }
    }

    if (formatBenar == false) {
      tampilkanHasil('Format kode tiket tidak valid.', false);
      return;
    }

    DummyTicket? tiketDitemukan;

    for (int nomor = 0; nomor < dummyTickets.length; nomor++) {
      if (dummyTickets[nomor].ticketCode.toUpperCase() == kodeTiket) {
        tiketDitemukan = dummyTickets[nomor];
        break;
      }
    }

    if (tiketDitemukan == null) {
      tampilkanHasil('Tiket tidak valid.', false);
      return;
    }

    DummyTicket tiket = tiketDitemukan;

    if (tiket.eventId != widget.acara.id) {
      tampilkanHasil('Tiket tidak valid untuk event ini.', false);
      return;
    }

    if (tiket.ticketStatus == 'sudah_checkin') {
      tampilkanHasil('Tiket sudah digunakan.', false);
      return;
    }

    if (tiket.ticketStatus != 'aktif') {
      tampilkanHasil('Tiket tidak valid.', false);
      return;
    }

    DummyRegistration? pendaftaran = registrationOf(tiket);

    if (pendaftaran == null) {
      tampilkanHasil('Data pendaftaran tidak ditemukan.', false);
      return;
    }

    if (pendaftaran.registrationStatus == 'dibatalkan') {
      tampilkanHasil('Tiket tidak valid.', false);
      return;
    }

    setState(() {
      tiket.ticketStatus = 'sudah_checkin';
      pesanHasil = 'Check-in berhasil.';
      checkInBerhasil = true;
    });
  }

  void tampilkanHasil(String pesan, bool berhasil) {
    setState(() {
      pesanHasil = pesan;
      checkInBerhasil = berhasil;
    });
  }

  Widget buatKotakHasil() {
    if (pesanHasil == '') {
      return const SizedBox.shrink();
    }

    Color warnaLatar = Colors.red.shade50;
    Color warnaTeks = Colors.red.shade900;

    if (checkInBerhasil == true) {
      warnaLatar = Colors.green.shade50;
      warnaTeks = Colors.green.shade900;
    }

    return Card(
      color: warnaLatar,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          pesanHasil,
          style: TextStyle(
            color: warnaTeks,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext konteks) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.acara.title,
            style: Theme.of(konteks).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 56),
                SizedBox(height: 8),
                Text('Area scan QR'),
                Text('(Kamera akan ditambahkan berikutnya)'),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(konteks).showSnackBar(
                const SnackBar(
                  content: Text('Fitur kamera belum dipasang.'),
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan QR'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: pengendaliKode,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Kode tiket',
              hintText: 'Contoh: JEG-7K3M9Q',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: periksaTiket,
            child: const Text('Periksa tiket'),
          ),
          const SizedBox(height: 12),
          buatKotakHasil(),
        ],
      ),
    );
  }
}
