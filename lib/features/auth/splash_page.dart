import 'package:flutter/material.dart';

import 'login_page.dart';

/// Halaman pembuka: tampilkan logo 2 detik, lalu pindah ke halaman Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      // pushReplacement = pindah halaman dan buang Splash (tidak bisa kembali ke sini).
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Logo versi gelap punya latar hitam, jadi latar halaman dibuat hitam.
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/Logo EventGo.png', width: 280),
            const SizedBox(height: 8),
            const Text(
              'Jabar EventGo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover Events. Explore West Java.',
              style: TextStyle(color: Color(0xFF1D5B8D)),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Color(0xFF019DA0)),
          ],
        ),
      ),
    );
  }
}
