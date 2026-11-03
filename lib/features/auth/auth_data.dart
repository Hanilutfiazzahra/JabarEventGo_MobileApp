import '../../core/dummy/dummy_users.dart';

/// Data akun sementara (UI + data dummy), diambil dari dummy_users.dart.
/// Nanti kalau backend sudah ada, isi fungsi di sini diganti panggilan API.
///
/// Fungsi mengembalikan DummyUser kalau berhasil, atau null kalau gagal.
class AuthData {
  // Salinan data dummy, supaya akun baru dari registrasi bisa ditambahkan.
  static List<DummyUser> users = List.from(dummyUsers);

  /// Cari akun berdasarkan email. Null kalau tidak ada.
  static DummyUser? cariEmail(String email) {
    for (var u in users) {
      if (u.email.toLowerCase() == email.trim().toLowerCase()) {
        return u;
      }
    }
    return null;
  }

  /// Login: email harus ada dan password harus sama.
  static DummyUser? login(String email, String password) {
    var user = cariEmail(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  /// Daftar: gagal (null) kalau email sudah terdaftar.
  static DummyUser? register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    if (cariEmail(email) != null) return null;

    var baru = DummyUser(
      id: users.last.id + 1, // id terakhir + 1
      name: name.trim(),
      email: email.trim(),
      password: password,
      role: role,
    );
    users.add(baru);
    return baru;
  }

  /// Ubah nama dan email. Gagal (null) kalau email dipakai akun lain.
  static DummyUser? updateProfile({
    required int id,
    required String name,
    required String email,
  }) {
    var pemilik = cariEmail(email);
    if (pemilik != null && pemilik.id != id) return null;

    var index = users.indexWhere((u) => u.id == id);
    var baru = DummyUser(
      id: id,
      name: name.trim(),
      email: email.trim(),
      password: users[index].password,
      role: users[index].role,
    );
    users[index] = baru;
    return baru;
  }
}
