import 'package:flutter/material.dart';

import '../../core/dummy/dummy_users.dart';
import '../../core/utils/validators.dart';
import 'auth_data.dart';
import 'login_page.dart';

/// Halaman Profil: info akun, form edit nama/email, dan tombol Logout.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  final DummyUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _email;

  // Data user yang ditampilkan. Berubah setelah edit, jadi pakai setState.
  late DummyUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _name = TextEditingController(text: _user.name);
    _email = TextEditingController(text: _user.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final baru = AuthData.updateProfile(
      id: _user.id,
      name: _name.text,
      email: _email.text,
    );

    if (baru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah dipakai akun lain')),
      );
      return;
    }

    // setState: data berubah, jadi nama dan email di atas ikut diperbarui.
    setState(() {
      _user = baru;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Kembali ke Login dan buang semua halaman sebelumnya.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.account_circle, size: 90),
          const SizedBox(height: 8),
          Text(
            _user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(_user.email, textAlign: TextAlign.center),
          Text(
            _user.role == 'penyelenggara' ? 'Penyelenggara' : 'Peserta',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nama lengkap'),
                  validator: Validators.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: Validators.email,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('Simpan perubahan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
