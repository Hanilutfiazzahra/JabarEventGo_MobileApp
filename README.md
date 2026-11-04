# jabar_eventgo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Anggota D — versi sederhana untuk pemula

Login penyelenggara: penyelenggara@mail.com / panitia123.
Setelah login langsung terbuka tab Kelola Event. Tema mengikuti AppTheme.light
aplikasi utama. Kode asli anggota lain tetap; integrasi hanya menambahkan baris.

### Cara menjalankan
Dari root proyek, jalankan `flutter pub get`, lalu `flutter run`.
Lakukan hot restart setelah memperbarui kode atau dependensi.
Target fitur poster Android/iOS, belum web (menggunakan dart:io).

### Empat file tambahan di lib/features/manage_event/
1. event_data.dart: model satu event, daftar data dummy, hitung peserta,
   simpan perubahan dan batalkan event. Ini kelas biasa, bukan Provider.
2. manage_event_page.dart: daftar event penyelenggara dan tombol tambah.
3. organizer_event_detail_page.dart: informasi event, edit, hapus draft,
   dan pembatalan dengan konfirmasi.
4. event_form_page.dart: form tambah/edit, validasi, pemilihan dan penyimpanan
   poster. Setiap kotak isian memakai controller bernama jelas.

Urutan baca yang disarankan: event_data.dart, manage_event_page.dart,
organizer_event_detail_page.dart, lalu event_form_page.dart.

### Alur yang perlu dipahami
- StatefulWidget: halaman yang tampilannya dapat diperbarui.
- setState: menggambar ulang tampilan setelah ada perubahan lokal.
- Navigator.push: membuka halaman detail atau form.
- Navigator.pop: menutup halaman dan kembali ke halaman sebelumnya.
- TextEditingController: membaca dan mengisi tulisan pada form.
- Form.validate: memeriksa apakah isian memenuhi aturan.
- EventData.save: menambah event baru atau menyimpan edit berdasarkan ID.

Hanya memakai setState lokal, tanpa menambahkan Provider/Bloc/Riverpod.
Provider milik anggota lain di main.dart tetap seperti semula.
Jumlah file sengaja empat supaya data bersama tidak dicampurkan dengan UI
atau diimpor berputar antarhalaman. File poster_storage.dart versi D sebelumnya
sudah tidak diperlukan dan tidak disertakan di versi ini.

### Fitur dasar
Daftar event milik penyelenggara; detail; tambah/edit dengan isian otomatis;
kategori dan 27 kab/kota Jawa Barat; tanggal dan jam; lokasi; kuota dan harga;
poster JPG/PNG maksimal 5 MB dari galeri; hapus draft tanpa peserta;
batalkan event beserta pendaftaran/tiket dummy terkait.

Library tambahan: image_picker (galeri), path_provider (folder dokumen lokal).
Izin galeri iOS sudah ditambahkan. Pilih Flutter yang kompatibel dengan versi
image_picker dan path_provider pada pubspec.yaml, lalu jalankan flutter pub get.

### File asli yang hanya mendapat tambahan
- pubspec.yaml: dependensi poster.
- lib/features/shell/main_shell.dart: import, data lokal, initState untuk
  tab awal penyelenggara, dan penghubung menu Kelola Event.
- ios/Runner/Info.plist: deskripsi izin galeri.
- README.md: panduan ini.
main.dart, tema, data dummy asli, serta file anggota lain tetap identik.

### Batasan
Data event hanya selama sesi, belum disimpan ke database/server. Data awal
mengambil salinan dummy bersama, ID tetap; perubahan event belum disinkronkan
ke halaman B/C. Poster tersalin lokal, tetapi metadata event kembali ke awal
setelah restart/login ulang; poster lama belum dibersihkan otomatis.
Pemilih lokasi B masih menggunakan titik contoh Gedung Sate, belum peta aktif.
Lihat Peserta dan Check-in menampilkan pesan belum tersedia sampai modul E siap.
Pembatalan belum mengirim notifikasi OS atau riwayat notifikasi anggota C.
Tidak ada endpoint API, backend, atau upload poster ke server pada versi ini.

### Verifikasi
Perbandingan terhadap ZIP awal memastikan seluruh file asli tetap ada dan
perubahan pada file asli hanya berupa penambahan baris. Import relatif modul
diperiksa. Flutter/Dart tidak tersedia, sehingga build/analyze dan uji perangkat
belum dijalankan. Uji tambah/edit, validasi, poster, hapus dan batal pada perangkat.
