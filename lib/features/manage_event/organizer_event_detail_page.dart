import 'package:flutter/material.dart';
import 'event_data.dart';
import 'event_form_page.dart';
import 'dart:io';

class OrganizerEventDetailPage extends StatefulWidget {
  const OrganizerEventDetailPage({super.key, required this.event, required this.owner,
    required this.data});
  final ManagedEvent event;
  final int owner;
  final EventData data;
  @override
  State<OrganizerEventDetailPage> createState() => _OrganizerEventDetailPageState();
}
class _OrganizerEventDetailPageState extends State<OrganizerEventDetailPage> {

  void showNotReady() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Halaman anggota E belum tersedia.')));
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.data.events.firstWhere((e) => e.id == widget.event.id);
    if (e.organizerId != widget.owner) {
      return const Scaffold(body: Center(child: Text('Bukan event milikmu')));
    }
    return Scaffold(appBar: AppBar(title: const Text('Detail Event Penyelenggara')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        e.poster.startsWith('http')
          ? Image.network(e.poster, height: 180, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80))
          : Image.file(File(e.poster), height: 180, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80)), const SizedBox(height: 16),
        Text(e.title, style: Theme.of(context).textTheme.headlineSmall),
        Text('${e.category} • ${e.status}'),
        const SizedBox(height: 12), Text(e.description),
        Text('\n${e.date.toString().split(' ').first} • ${e.start}–${e.end}'),
        Text('${e.venue}\n${e.address}\n${e.city}'),
        Text('Koordinat: ${e.latitude}, ${e.longitude}'),
        Text(e.price == 0 ? 'Gratis' : 'Rp ${e.price} (pembayaran belum tersedia)'),
        Text('Kuota: ${widget.data.registered(e.id)}/${e.quota}'),
        const SizedBox(height: 16),
        FilledButton(onPressed: e.status == 'dibatalkan' ? null : () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) =>
            EventFormPage(owner: widget.owner, data: widget.data, event: e)));
          if (mounted) setState(() {});
        }, child: const Text('Edit Event')),
        OutlinedButton(onPressed: showNotReady, child: const Text('Lihat Peserta')),
        OutlinedButton(onPressed: e.status != 'dipublikasikan' ? null : showNotReady, child: const Text('Check-in')),
        TextButton(onPressed: e.status == 'dibatalkan' ? null : () async {
          final count = widget.data.registered(e.id);
          final delete = e.status == 'draft' && count == 0;
          final yes = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
            title: Text(delete ? 'Hapus event?' : 'Batalkan event?'),
            content: Text(delete ? 'Draft ini akan dihapus dari daftar.' :
              'Status event, pendaftaran, dan tiket dummy akan dibatalkan.'),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Kembali')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ya'))]));
          if (yes != true || !mounted) return;
          if (delete) {
            widget.data.events.removeWhere((item) => item.id == e.id && item.organizerId == widget.owner);
          } else {
            widget.data.cancel(e, widget.owner);
          }
          if (mounted) Navigator.pop(context);
        }, child: Text(e.status == 'draft' && widget.data.registered(e.id) == 0 ? 'Hapus Draft' : 'Batalkan Event')),
      ]));
  }
}
