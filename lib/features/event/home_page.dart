import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/dummy/dummy_events.dart';
import '../../../core/dummy/dummy_users.dart';

import 'event_provider.dart';
import 'search_filter_page.dart';
import 'event_detail_page.dart';

import '../ticket/ticket_provider.dart';

class HomePage extends StatelessWidget {
  final DummyUser user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Membaca state dari EventProvider
    final eventProvider = context.watch<EventProvider>();
    final ticketProvider = context.watch<TicketProvider>();
    final events = eventProvider.filteredEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jabar EventGo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchFilterPage(user: user)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Halaman Notifikasi')),
              );
            },
          ),
        ],
      ),
      body: events.isEmpty
          ? const Center(child: Text('Tidak ada event yang ditemukan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final venue = venueOf(event);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        event.posterUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.event, size: 40),
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year} • ${venue?.regency ?? '-'}\n'
                      'Sisa Kuota: ${ticketProvider.getRemainingQuota(event.id)}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      event.ticketPrice == 0
                          ? 'GRATIS'
                          : 'Rp ${event.ticketPrice}',
                      style: TextStyle(
                        color: event.ticketPrice == 0
                            ? Colors.green
                            : Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EventDetailPage(event: event, user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}