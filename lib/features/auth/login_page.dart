import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';
import '../shell/main_shell.dart';
import 'auth_data.dart';
import 'register_page.dart';

/// Halaman Login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _masuk() {
    // Cek semua isian. Kalau ada yang salah, pesan tampil di bawah field.
    if (!_formKey.currentState!.validate()) return;

    final user = AuthData.login(_email.text, _password.text);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah')),
      );
      return;
    }

    // Berhasil: pindah ke halaman utama dan buang halaman Login.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainShell(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text(
                'Jabar EventGo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true, // tampil sebagai titik-titik
                decoration: const InputDecoration(labelText: 'Password'),
                validator: Validators.password,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF019DA0),
                  foregroundColor: Colors.white,
                ),
                onPressed: _masuk,
                child: const Text('Masuk'),
              ),
              TextButton(
                onPressed: () async {
                  final emailTerdaftar = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );

                  debugPrint('EMAIL DITERIMA LOGIN: $emailTerdaftar');

                  if (!mounted) return;

                  if (emailTerdaftar != null && emailTerdaftar.isNotEmpty) {
                    _email.value = TextEditingValue(
                      text: emailTerdaftar,
                      selection: TextSelection.collapsed(
                        offset: emailTerdaftar.length,
                      ),
                    );
                  }
                },
                child: const Text('Belum punya akun? Daftar'),
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}