class DummyUser {
  final int id;
  final String name;
  final String email;
  final String password; 
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
  DummyUser(id: 101, name: 'Budi Santoso', email: 'budi@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 102, name: 'Sinta Rahma', email: 'sinta@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 103, name: 'Rina Lestari', email: 'rina@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 104, name: 'Dodi Pratama', email: 'dodi@mail.com', password: 'peserta123', role: 'peserta'),
  DummyUser(id: 201, name: 'Komunitas Jabar Kreatif', email: 'penyelenggara@mail.com', password: 'panitia123', role: 'penyelenggara'),
];

DummyUser? userById(int id) {
  for (final u in dummyUsers) {
    if (u.id == id) return u;
  }
  return null;
}
