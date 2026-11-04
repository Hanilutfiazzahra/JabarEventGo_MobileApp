import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';
import 'auth_data.dart';

/// Halaman Registrasi. Kalau berhasil, kembali ke halaman Login.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String _role = 'peserta'; // peran yang dipilih

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _daftar() {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthData.register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      role: _role,
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar')),
      );
      return;
    }

    // Berhasil: tampilkan pesan lalu kembali ke halaman Login.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil, silakan masuk')),
    );
    Navigator.pop(context, user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/Logo EventGo.png', height: 100),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirm,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Konfirmasi password'),
                validator: (value) =>
                    Validators.confirmPassword(value, _password.text),
              ),
              const SizedBox(height: 16),
              const Text('Daftar sebagai'),
              DropdownButton<String>(
                value: _role,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'peserta', child: Text('Peserta')),
                  DropdownMenuItem(
                    value: 'penyelenggara',
                    child: Text('Penyelenggara'),
                  ),
                ],
                onChanged: (nilai) => setState(() => _role = nilai!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF019DA0),
                  foregroundColor: Colors.white,
                ),
                onPressed: _daftar,
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
