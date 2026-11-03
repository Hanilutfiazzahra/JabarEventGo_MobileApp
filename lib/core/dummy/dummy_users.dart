// lib/core/dummy/dummy_users.dart
//
// Data dummy BERSAMA untuk akun pengguna (pemilik: Anggota A).
// Dipakai A (login), C (nama peserta di tiket), E (daftar peserta), D/E (penyelenggara).
// Nama field mengikuti PRD bagian 12 (users). Password hanya untuk tes, jangan dipakai di backend.
// Setelah backend jadi, file ini tidak dipakai lagi.

/// role: 'peserta' | 'penyelenggara'
class DummyUser {
  final int id;
  final String name;
  final String email;
  final String password; // HANYA untuk tes login dummy
  final String role;

  const DummyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

const List<DummyUser> dummyUsers = [
  // Peserta (id 101-104 dipakai di dummy_tickets.dart)
  DummyUser(id: 101, name: 'Budi Santoso', email: 'budi@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 102, name: 'Sinta Rahma', email: 'sinta@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 103, name: 'Rina Lestari', email: 'rina@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 104, name: 'Dodi Pratama', email: 'dodi@mail.com', password: 'peserta123', role: 'peserta'),
  // Penyelenggara (id 201 dipakai sebagai organizerId di dummy_events.dart)
  DummyUser(id: 201, name: 'Komunitas Jabar Kreatif', email: 'penyelenggara@mail.com', password: 'panitia123', role: 'penyelenggara'),
];

DummyUser? userById(int id) {
  for (final u in dummyUsers) {
    if (u.id == id) return u;
  }
  return null;
}
