class DummyVenue {
  final int id;
  final String name;
  final String address;
  final String regency; 
  final String province;
  final double latitude;
  final double longitude;

  const DummyVenue({
    required this.id,
    required this.name,
    required this.address,
    required this.regency,
    this.province = 'Jawa Barat',
    required this.latitude,
    required this.longitude,
  });
}

class DummyEvent {
  final int id;
  final int organizerId; 
  final String title;
  final String description;
  final String category; 
  final DateTime eventDate;
  final String startTime;
  final String endTime;
  final int venueId; 
  final int ticketPrice; 
  final int ticketQuota;
  String eventStatus;
  final String posterUrl; 

  DummyEvent({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.description,
    required this.category,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.venueId,
    required this.ticketPrice,
    required this.ticketQuota,
    required this.eventStatus,
    required this.posterUrl,
  });
}

const List<DummyVenue> dummyVenues = [
  DummyVenue(id: 1, name: 'Gedung Sate', address: 'Jl. Diponegoro No.22', regency: 'Kota Bandung', latitude: -6.9025, longitude: 107.6188),
  DummyVenue(id: 2, name: 'Alun-Alun Kota Bogor', address: 'Jl. Dewi Sartika', regency: 'Kota Bogor', latitude: -6.5944, longitude: 106.7916),
  DummyVenue(id: 3, name: 'Gedung Kesenian Cirebon', address: 'Jl. Siliwangi', regency: 'Kota Cirebon', latitude: -6.7063, longitude: 108.5570),
];

final List<DummyEvent> dummyEvents = [
  DummyEvent(
    id: 1, organizerId: 201,
    title: 'Seminar Teknologi Jabar 2026',
    description: 'Seminar tentang perkembangan teknologi digital untuk mahasiswa dan umum di Jawa Barat.',
    category: 'seminar', eventDate: DateTime(2026, 12, 5), startTime: '09:00', endTime: '12:00',
    venueId: 1, ticketPrice: 0, ticketQuota: 100, eventStatus: 'dipublikasikan',
    posterUrl: 'https://picsum.photos/seed/jeg1/600/400',
  ),

  DummyEvent(
    id: 2, organizerId: 201,
    title: 'Festival Musik Bogor',
    description: 'Festival musik komunitas dengan penampilan band lokal se-Jawa Barat.',
    category: 'musik', eventDate: DateTime(2026, 12, 12), startTime: '15:00', endTime: '22:00',
    venueId: 2, ticketPrice: 0, ticketQuota: 200, eventStatus: 'dipublikasikan',
    posterUrl: 'https://picsum.photos/seed/jeg2/600/400',
  ),

  DummyEvent(
    id: 3, organizerId: 201,
    title: 'Workshop Batik Cirebon',
    description: 'Workshop membatik motif mega mendung untuk pemula.',
    category: 'budaya', eventDate: DateTime(2026, 12, 20), startTime: '10:00', endTime: '14:00',
    venueId: 3, ticketPrice: 0, ticketQuota: 1, eventStatus: 'dipublikasikan',
    posterUrl: 'https://picsum.photos/seed/jeg3/600/400',
  ),

  DummyEvent(
    id: 4, organizerId: 201,
    title: 'Fun Run Bandung',
    description: 'Lari santai 5K keliling pusat Kota Bandung.',
    category: 'olahraga', eventDate: DateTime(2027, 1, 10), startTime: '06:00', endTime: '09:00',
    venueId: 1, ticketPrice: 0, ticketQuota: 300, eventStatus: 'draft',
    posterUrl: 'https://picsum.photos/seed/jeg4/600/400',
  ),
];

DummyVenue? venueOf(DummyEvent event) {
  for (final v in dummyVenues) {
    if (v.id == event.venueId) return v;
  }
  return null;
}
