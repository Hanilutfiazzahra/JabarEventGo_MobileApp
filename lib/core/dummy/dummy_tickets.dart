// lib/core/dummy/dummy_tickets.dart
//
// Data dummy BERSAMA untuk Anggota C (pendaftaran & tiket) dan Anggota E (check-in).
// Satu file ini dipakai berdua. Jangan buat versi sendiri-sendiri.
// Nama field mengikuti PRD bagian 12 (registrations, tickets).
// Setelah backend jadi, file ini tidak dipakai lagi.

/// Status pendaftaran: 'terdaftar' | 'dibatalkan'
class DummyRegistration {
  final int id;
  final int userId;
  final int eventId;
  final String namaPeserta; // nanti diambil dari tabel users
  final String emailPeserta; // nanti diambil dari tabel users
  final DateTime registrationDate;
  String registrationStatus;

  DummyRegistration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.namaPeserta,
    required this.emailPeserta,
    required this.registrationDate,
    required this.registrationStatus,
  });
}

/// Status tiket: 'aktif' | 'sudah_checkin' | 'dibatalkan'
/// Format kode tiket: "JEG-" + 6 huruf besar/angka. Kode ini juga isi QR.
class DummyTicket {
  final int id;
  final int registrationId;
  final int eventId; // memudahkan pengecekan "tiket untuk event ini atau bukan"
  final String ticketCode;
  String ticketStatus;
  final DateTime issuedAt;

  DummyTicket({
    required this.id,
    required this.registrationId,
    required this.eventId,
    required this.ticketCode,
    required this.ticketStatus,
    required this.issuedAt,
  });
}

// event_id 1 dan 2 harus sama dengan data awal event milik Anggota D.
final List<DummyRegistration> dummyRegistrations = [
  DummyRegistration(id: 1, userId: 101, eventId: 1, namaPeserta: 'Budi Santoso', emailPeserta: 'budi@mail.com', registrationDate: DateTime(2026, 11, 10), registrationStatus: 'terdaftar'),
  DummyRegistration(id: 2, userId: 102, eventId: 1, namaPeserta: 'Sinta Rahma', emailPeserta: 'sinta@mail.com', registrationDate: DateTime(2026, 11, 11), registrationStatus: 'terdaftar'),
  DummyRegistration(id: 3, userId: 103, eventId: 2, namaPeserta: 'Rina Lestari', emailPeserta: 'rina@mail.com', registrationDate: DateTime(2026, 11, 12), registrationStatus: 'terdaftar'),
  DummyRegistration(id: 4, userId: 104, eventId: 1, namaPeserta: 'Dodi Pratama', emailPeserta: 'dodi@mail.com', registrationDate: DateTime(2026, 11, 12), registrationStatus: 'dibatalkan'),
];

final List<DummyTicket> dummyTickets = [
  // Kasus 1: tiket aktif di event 1 -> scan di event 1 = "Check-in berhasil"
  DummyTicket(id: 1, registrationId: 1, eventId: 1, ticketCode: 'JEG-7K3M9Q', ticketStatus: 'aktif', issuedAt: DateTime(2026, 11, 10)),
  // Kasus 2: sudah check-in -> "Tiket sudah digunakan"
  DummyTicket(id: 2, registrationId: 2, eventId: 1, ticketCode: 'JEG-A1B2C3', ticketStatus: 'sudah_checkin', issuedAt: DateTime(2026, 11, 11)),
  // Kasus 3: tiket untuk event 2 -> scan di event 1 = "Tiket tidak valid"
  DummyTicket(id: 3, registrationId: 3, eventId: 2, ticketCode: 'JEG-Z9Y8X7', ticketStatus: 'aktif', issuedAt: DateTime(2026, 11, 12)),
  // Kasus 4: tiket dibatalkan -> "Tiket tidak valid"
  DummyTicket(id: 4, registrationId: 4, eventId: 1, ticketCode: 'JEG-Q4W5E6', ticketStatus: 'dibatalkan', issuedAt: DateTime(2026, 11, 12)),
];
// Kasus 5: kode asal (misalnya JEG-XXXXXX) tidak ada di list -> "Tiket tidak valid"

/// Mencari pendaftaran milik sebuah tiket (dipakai E untuk Daftar Peserta & Detail Pendaftaran).
DummyRegistration? registrationOf(DummyTicket ticket) {
  for (final r in dummyRegistrations) {
    if (r.id == ticket.registrationId) return r;
  }
  return null;
}
