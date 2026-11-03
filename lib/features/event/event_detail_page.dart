import 'package:flutter/material.dart';
import '../../../core/dummy/dummy_events.dart';

class EventDetailPage extends StatelessWidget {
  final DummyEvent event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final venue = venueOf(event);

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              event.posterUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.blue.shade100,
                child: const Icon(Icons.image, size: 60),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Kategori: ${event.category} | Waktu: ${event.startTime} - ${event.endTime} WIB'),
          Text('Tanggal: ${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}'),
          Text('Harga: ${event.ticketPrice == 0 ? "Gratis" : "Rp ${event.ticketPrice}"}'),
          Text('Sisa Kuota: ${event.ticketQuota} tiket'),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: const TextStyle(color: Colors.black87),
          ),
          const Divider(height: 32),
          const Text('Lokasi & Venue Acara:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('${venue?.name ?? "-"}, ${venue?.address ?? "-"}, ${venue?.regency ?? "-"}'),
          const SizedBox(height: 8),
          // Preview Peta Koordinat
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    'Titik Koordinat Peta:\nLat: ${venue?.latitude ?? 0.0}, Lng: ${venue?.longitude ?? 0.0}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('pendaftaran tiket')),
              );
            },
            child: const Text('Daftar Tiket Event'),
          ),
        ],
      ),
    );
  }
}