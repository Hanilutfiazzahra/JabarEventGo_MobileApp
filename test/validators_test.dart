import 'package:flutter_test/flutter_test.dart';
import 'package:jabar_eventgo/core/dummy/dummy_users.dart';
import 'package:jabar_eventgo/core/utils/validators.dart';
import 'package:jabar_eventgo/features/auth/auth_data.dart';

void main() {
  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('abc@mail'), isNotNull);
      expect(Validators.email('budi@mail.com'), isNull);
    });

    test('password minimal 6 karakter', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });

    test('nama minimal 3 huruf', () {
      expect(Validators.name('ab'), isNotNull);
      expect(Validators.name('Abi'), isNull);
    });

    test('konfirmasi password harus sama', () {
      expect(Validators.confirmPassword('abcdef', 'abcdeg'), isNotNull);
      expect(Validators.confirmPassword('abcdef', 'abcdef'), isNull);
    });
  });

  group('AuthData', () {
    test('login gagal dan berhasil', () {
      expect(AuthData.login('budi@mail.com', 'salah'), isNull);
      expect(AuthData.login('budi@mail.com', 'peserta123'), isNotNull);
    });

    test('penyelenggara dikenali dari role', () {
      final user = AuthData.login('penyelenggara@mail.com', 'panitia123');
      expect(user?.role, 'penyelenggara');
    });

    test('registrasi menolak email yang sudah ada', () {
      final user = AuthData.register(
        name: 'Budi Lain',
        email: dummyUsers.first.email,
        password: '123456',
        role: 'peserta',
      );
      expect(user, isNull);
    });
  });
}
