import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_users.dart';
import 'ticket_provider.dart';

class RegistrationPage extends StatefulWidget {
  final DummyEvent event;
  final DummyUser user;

  const RegistrationPage({
    super.key,
    required this.event,
    required this.user,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Mengisi form secara otomatis dari akun yang sedang login.
    _namaController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatRupiah(dynamic price) {
    return 'Rp ${price.toString()}';
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ticketProvider = context.read<TicketProvider>();

    final result = ticketProvider.registerForEvent(
      userId: widget.user.id,
      eventId: widget.event.id,
      namaPeserta: _namaController.text,
      emailPeserta: _emailController.text,
    );

    if (!mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tampilkan konfirmasi ketika tiket berhasil dibuat.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Pendaftaran Berhasil!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 55,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pendaftaran kamu berhasil. Tiket telah dibuat.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Kode Tiket:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(
                result.ticket!.ticketCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    // Kembali ke halaman detail event.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        final registeredCount =
            ticketProvider.getActiveRegistrationCount(event.id);

        final remainingQuota = event.ticketQuota - registeredCount;

        final alreadyRegistered = ticketProvider.isUserRegistered(
          widget.user.id,
          event.id,
        );

        final isQuotaFull = remainingQuota <= 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Konfirmasi Pendaftaran'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Event',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Tanggal',
                            event.eventDate.toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.access_time,
                            'Waktu',
                            '${event.startTime} - ${event.endTime}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.confirmation_number,
                            'Harga Tiket',
                            _formatRupiah(event.ticketPrice),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.people,
                            'Sisa Kuota',
                            '$remainingQuota / ${event.ticketQuota}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Data Peserta',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Peserta',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama peserta wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Peserta',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email peserta wajib diisi.';
                      }

                      if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+$',
                      ).hasMatch(value.trim())) {
                        return 'Format email tidak valid.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (alreadyRegistered)
                    const Text(
                      'Kamu sudah terdaftar pada event ini.',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (isQuotaFull)
                    const Text(
                      'Maaf, kuota event sudah penuh.',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: alreadyRegistered || isQuotaFull
                          ? null
                          : _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Konfirmasi Pendaftaran',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Text('$label: '),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}