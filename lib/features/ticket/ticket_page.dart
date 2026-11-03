import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/dummy/dummy_users.dart';
import 'ticket_provider.dart';

class TicketPage extends StatelessWidget {
  final DummyUser user;

  const TicketPage({
    super.key,
    required this.user,
  });

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'active':
        return 'Aktif';
      case 'sudah_checkin':
        return 'Sudah Check-in';
      case 'dibatalkan':
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'active':
        return Colors.green;
      case 'sudah_checkin':
        return Colors.blue;
      case 'dibatalkan':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> cancelTicket(
    BuildContext context,
    TicketProvider provider,
    int ticketId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan Tiket?'),
        content: const Text(
          'Apakah kamu yakin ingin membatalkan tiket ini? '
          'Kuota akan dikembalikan setelah pembatalan berhasil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = provider.cancelTicket(ticketId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Tiket berhasil dibatalkan. Kuota telah dikembalikan.'
              : 'Tiket tidak dapat dibatalkan.',
        ),
      ),
    );
  }

  void showTicketDetail(
    BuildContext context,
    TicketProvider provider,
    dynamic ticket,
    dynamic registration,
    dynamic event,
  ) {
    final isActive =
        ticket.ticketStatus == 'aktif' || ticket.ticketStatus == 'active';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Detail Tiket'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Divider(height: 24),
              Text('Nama Peserta: ${registration.namaPeserta}'),
              const SizedBox(height: 8),
              Text('Email: ${registration.emailPeserta}'),
              const SizedBox(height: 8),
              Text('Tanggal Event: ${formatDate(event.eventDate)}'),
              const SizedBox(height: 8),
              Text('Waktu: ${event.startTime} - ${event.endTime} WIB'),
              const SizedBox(height: 8),
              Text(
                  'Harga: ${event.ticketPrice == 0 ? "Gratis" : "Rp ${event.ticketPrice}"}'),
              const SizedBox(height: 8),
              Text('Kode Tiket: ${ticket.ticketCode}'),
              const SizedBox(height: 8),
              Text(
                'Status: ${statusLabel(ticket.ticketStatus)}',
                style: TextStyle(
                  color: statusColor(ticket.ticketStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isActive) ...[
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'QR Code Tiket',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: QrImageView(
                      data: ticket.ticketCode,
                      version: QrVersions.auto,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Tunjukkan QR Code ini saat check-in.'),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (isActive)
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await cancelTicket(context, provider, ticket.id);
              },
              child: const Text(
                'Batalkan Tiket',
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketProvider>();
    final tickets = provider.getTicketsByUser(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Saya'),
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kamu Belum Memiliki Tiket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Yuk, temukan event menarik di Jawa Barat '
                      'dan daftarkan dirimu!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final registration = provider.getRegistrationById(
                  ticket.registrationId,
                );
                final event = provider.getEventById(ticket.eventId);

                if (registration == null || event == null) {
                  return const SizedBox.shrink();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.confirmation_number,
                      color: Colors.deepOrange,
                      size: 32,
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kode: ${ticket.ticketCode}'),
                          const SizedBox(height: 5),
                          Text(
                            'Status: ${statusLabel(ticket.ticketStatus)}',
                            style: TextStyle(
                              color: statusColor(ticket.ticketStatus),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ketuk untuk melihat detail dan QR Code',
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showTicketDetail(
                      context,
                      provider,
                      ticket,
                      registration,
                      event,
                    ),
                  ),
                );
              },
            ),
    );
  }
}