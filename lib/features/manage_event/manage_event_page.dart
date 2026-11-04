import 'package:flutter/material.dart';
import '../../core/dummy/dummy_users.dart';
import 'event_data.dart';
import 'event_form_page.dart';
import 'organizer_event_detail_page.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, required this.user, required this.data});
  final DummyUser user;
  final EventData data;
  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.user.role != 'penyelenggara') {
      return const Scaffold(body: Center(child: Text('Khusus penyelenggara')));
    }
    final events = widget.data.events
        .where((e) => e.organizerId == widget.user.id)
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Event')),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Tambah Event'),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EventFormPage(
                        owner: widget.user.id, data: widget.data)));
            if (mounted) setState(() {});
          }),
      body: events.isEmpty
          ? const Center(
              child: Text('Belum ada event. Yuk buat event pertamamu!'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: events.length,
              itemBuilder: (_, i) {
                final e = events[i];
                return Card(
                    child: ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(e.title),
                        subtitle: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${e.date.toString().split(' ').first} • ${e.city}\n',
                              ),

                              // Status menjadi merah jika event batal
                              TextSpan(
                                text: e.status,
                                style: TextStyle(
                                  color: e.status == 'dibatalkan'
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' • ${widget.data.registered(e.id)}/${e.quota} peserta',
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrganizerEventDetailPage(
                                      event: e,
                                      owner: widget.user.id,
                                      data: widget.data)));
                          if (mounted) setState(() {});
                        }));
              }),
    );
  }
}
