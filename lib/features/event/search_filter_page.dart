
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/dummy/dummy_events.dart';
import '../../../core/dummy/dummy_users.dart';
import 'event_provider.dart';
import 'event_detail_page.dart';

class SearchFilterPage extends StatelessWidget {
  final DummyUser user;

  const SearchFilterPage({
    super.key,
    required this.user,
  });

  final List<String> cities = const [
    'Semua',
    'Kota Bandung',
    'Kota Bogor',
    'Kota Cirebon',
  ];

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final events = eventProvider.filteredEvents;

    return Scaffold(
      appBar: AppBar(title: const Text('Cari & Filter Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul event...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                context.read<EventProvider>().searchEvents(text);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Wilayah: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: eventProvider.selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<EventProvider>().filterByCity(val);
                    }
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<EventProvider>().resetFilter();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: events.isEmpty
                  ? const Center(
                      child: Text('Event tidak ditemukan.'),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final venue = venueOf(event);

                        return ListTile(
                          title: Text(event.title),
                          subtitle: Text(
                            '${venue?.regency ?? '-'} • ${event.category}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailPage(
                                  event: event,
                                  user: user,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}