import 'package:flutter/material.dart';

class VenuePickerPage extends StatefulWidget {
  const VenuePickerPage({super.key});

  @override
  State<VenuePickerPage> createState() => _VenuePickerPageState();
}

class _VenuePickerPageState extends State<VenuePickerPage> {
  // Default titik Gedung Sate (Kota Bandung)
  double selectedLat = -6.9025;
  double selectedLng = 107.6188;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi Venue')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_pin, size: 64, color: Colors.red),
                    const SizedBox(height: 8),
                    const Text('Titik Koordinat Venue Terpilih:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Lat: $selectedLat, Lng: $selectedLng'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Mengembalikan koordinat ke form milik Anggota D
                  Navigator.pop(context, {'lat': selectedLat, 'lng': selectedLng});
                },
                child: const Text('Pilih Titik Lokasi Ini'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}