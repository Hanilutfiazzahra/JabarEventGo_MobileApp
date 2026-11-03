import 'package:flutter/material.dart';

/// Halaman sementara untuk modul milik anggota lain.
/// Ganti builder di main_shell.dart dengan halaman aslinya saat sudah siap.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Halaman "$title" belum dikerjakan.\n'
            'Akan diganti oleh modul anggota lain.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
