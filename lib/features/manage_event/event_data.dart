import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_tickets.dart';

class ManagedEvent {
  int id, organizerId, quota, price;
  String title, description, category, start, end, status, poster;
  String venue, address, city;
  DateTime date;
  double? latitude, longitude;
  ManagedEvent({required this.id, required this.organizerId,
    required this.title, required this.description, required this.category,
    required this.date, required this.start, required this.end,
    required this.quota, required this.price, required this.status,
    required this.poster, required this.venue, required this.address,
    required this.city, this.latitude, this.longitude});
}

class EventData {
  final List<ManagedEvent> events = [];

  EventData() {
    for (final event in dummyEvents) {
      final venue = venueOf(event);
      if (venue == null) continue;

      events.add(ManagedEvent(
        id: event.id,
        organizerId: event.organizerId,
        title: event.title,
        description: event.description,
        category: event.category,
        date: event.eventDate,
        start: event.startTime,
        end: event.endTime,
        quota: event.ticketQuota,
        price: event.ticketPrice,
        status: event.eventStatus,
        poster: event.posterUrl,
        venue: venue.name,
        address: venue.address,
        city: venue.regency,
        latitude: venue.latitude,
        longitude: venue.longitude,
      ));
    }
  }

  int get nextId {
    int biggestId = 0;
    for (final event in events) {
      if (event.id > biggestId) biggestId = event.id;
    }
    return biggestId + 1;
  }

  int registered(int eventId) {
    int total = 0;
    for (final registration in dummyRegistrations) {
      if (registration.eventId == eventId &&
          registration.registrationStatus == 'terdaftar') {
        total++;
      }
    }
    return total;
  }

  void save(ManagedEvent event, int owner) {
    if (event.organizerId != owner) throw StateError('Bukan event milikmu');
    final index = events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      if (events[index].organizerId != owner) throw StateError('Bukan event milikmu');
      events[index] = event;
    } else {
      events.add(event);
    }
  }
  void cancel(ManagedEvent event, int owner) {
    if (event.organizerId != owner) throw StateError('Bukan event milikmu');
    event.status = 'dibatalkan';
    for (final r in dummyRegistrations.where((r) => r.eventId == event.id)) {
      r.registrationStatus = 'dibatalkan';
    }
    for (final t in dummyTickets.where((t) => t.eventId == event.id)) {
      t.ticketStatus = 'dibatalkan';
    }
  }
}
