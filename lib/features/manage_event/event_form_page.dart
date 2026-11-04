import 'package:flutter/material.dart';
import '../event/venue_picker_page.dart';
import 'event_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, required this.owner, required this.data, this.event});
  final int owner;
  final EventData data;
  final ManagedEvent? event;
  @override
  State<EventFormPage> createState() => _EventFormPageState();
}
class _EventFormPageState extends State<EventFormPage> {
  final form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();
  final addressController = TextEditingController();
  final quotaController = TextEditingController();
  final priceController = TextEditingController(text: '0');
  String category = 'seminar', status = 'draft', city = 'Kota Bandung', poster = '';
  DateTime? date;
  TimeOfDay? start, end;
  double? lat, lng;
  bool picking = false;
  static const cities = ['Kabupaten Bandung','Kabupaten Bandung Barat','Kabupaten Bekasi',
    'Kabupaten Bogor','Kabupaten Ciamis','Kabupaten Cianjur','Kabupaten Cirebon',
    'Kabupaten Garut','Kabupaten Indramayu','Kabupaten Karawang','Kabupaten Kuningan',
    'Kabupaten Majalengka','Kabupaten Pangandaran','Kabupaten Purwakarta',
    'Kabupaten Subang','Kabupaten Sukabumi','Kabupaten Sumedang','Kabupaten Tasikmalaya',
    'Kota Bandung','Kota Banjar','Kota Bekasi','Kota Bogor','Kota Cimahi','Kota Cirebon',
    'Kota Depok','Kota Sukabumi','Kota Tasikmalaya'];
  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e != null) {
      nameController.text = e.title;
      descriptionController.text = e.description;
      venueController.text = e.venue;
      addressController.text = e.address;
      quotaController.text = e.quota.toString();
      priceController.text = e.price.toString();
      category = e.category; status = e.status; city = e.city;
      poster = e.poster; date = e.date; lat = e.latitude; lng = e.longitude;
      start = parseTime(e.start); end = parseTime(e.end);
    }
  }
  TimeOfDay parseTime(String text) {
    final parts = text.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  String timeText(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    addressController.dispose();
    quotaController.dispose();
    priceController.dispose();
    super.dispose();
  }
  // Periksa isian, simpan data, lalu kembali ke halaman sebelumnya.
  void save() {
    if (!form.currentState!.validate()) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date == null || date!.isBefore(today)) { message('Pilih tanggal hari ini atau setelahnya.'); return; }
    if (start == null || end == null || end!.hour * 60 + end!.minute <= start!.hour * 60 + start!.minute) {
      message('Jam selesai harus setelah jam mulai.'); return;
    }
    if (lat == null || lng == null) { message('Pilih lokasi venue terlebih dahulu.'); return; }
    if (poster.isEmpty) { message('Poster wajib dipilih.'); return; }
    final old = widget.event;
    if (old != null && (old.organizerId != widget.owner || old.status == 'dibatalkan')) {
      message('Event tidak dapat diubah.'); return;
    }
    widget.data.save(ManagedEvent(id: old?.id ?? widget.data.nextId, organizerId: widget.owner,
      title: nameController.text.trim(), description: descriptionController.text.trim(), category: category,
      date: date!, start: timeText(start!), end: timeText(end!), quota: int.parse(quotaController.text.trim()),
      price: int.tryParse(priceController.text.trim()) ?? 0, status: status, poster: poster,
      venue: venueController.text.trim(), address: addressController.text.trim(), city: city,
      latitude: lat, longitude: lng), widget.owner);
    Navigator.pop(context, true);
  }
  String? requiredText(String? value, int minimum) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Wajib diisi';
    if (text.length < minimum) return 'Minimal $minimum karakter';
    return null;
  }

  // Widget kecil agar gaya semua kotak isian sama.
  Widget input(TextEditingController controller, String label,
      {int lines = 1, bool number = false,
      required String? Function(String?) validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: lines,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        validator: validator,
      ),
    );
  }

  // Pilih poster, periksa, dan salin ke folder dokumen aplikasi.
  Future<String?> pickPoster() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return null; // Pengguna menutup galeri.

    final name = photo.name.toLowerCase();
    if (!name.endsWith('.jpg') && !name.endsWith('.jpeg') && !name.endsWith('.png')) {
      throw Exception('Gunakan file JPG atau PNG');
    }
    if (await photo.length() > 5 * 1024 * 1024) {
      throw Exception('Ukuran maksimal 5 MB');
    }

    // Pastikan file memang bisa dibaca sebagai gambar.
    final bytes = await photo.readAsBytes();
    final image = await decodeImageFromList(bytes);
    image.dispose();
    final documents = await getApplicationDocumentsDirectory();
    final extension = name.endsWith('.png') ? 'png' : 'jpg';
    final path = '${documents.path}/poster_${DateTime.now().microsecondsSinceEpoch}.$extension';
    await File(path).writeAsBytes(bytes);
    return path;
  }

  Widget posterPreview(String path) {
    const empty = Icon(Icons.image_outlined, size: 80);
    if (path.isEmpty) return empty;
    if (path.startsWith('http')) {
      return Image.network(path, height: 180, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => empty);
    }
    return Image.file(File(path), height: 180, fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => empty);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event != null && (widget.event!.organizerId != widget.owner || widget.event!.status == 'dibatalkan')) {
      return const Scaffold(body: Center(child: Text('Event tidak dapat diubah')));
    }
    return Scaffold(appBar: AppBar(title: Text(widget.event == null ? 'Tambah Event' : 'Edit Event')),
      body: Form(key: form, child: ListView(padding: const EdgeInsets.all(16), children: [
        input(nameController, 'Nama event',
          validator: (value) => requiredText(value, 5)),
        input(descriptionController, 'Deskripsi', lines: 4,
          validator: (value) => requiredText(value, 20)),
        input(venueController, 'Nama venue',
          validator: (value) => requiredText(value, 1)),
        input(addressController, 'Alamat',
          validator: (value) => requiredText(value, 1)),
        input(quotaController, 'Kuota tiket', number: true,
          validator: (value) {
            final quota = int.tryParse(value ?? '');
            if (quota == null || quota <= 0) return 'Kuota harus angka lebih dari 0';
            final total = widget.data.registered(widget.event?.id ?? -1);
            if (quota < total) return 'Kuota tidak boleh di bawah jumlah pendaftar';
            return null;
          }),
        input(priceController, 'Harga tiket (0 = Gratis)', number: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            final price = int.tryParse(value);
            if (price == null || price < 0) return 'Harga harus angka 0 atau lebih';
            return null;
          }),
        DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Kategori'),
          items: ['seminar','musik','olahraga','budaya','workshop','lainnya'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => category = v!)), const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: city, isExpanded: true, decoration: const InputDecoration(labelText: 'Kabupaten/kota'),
          items: cities.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => city = v!)),
        ListTile(title: const Text('Tanggal'), subtitle: Text(date?.toString().split(' ').first ?? 'Belum dipilih'),
          trailing: const Icon(Icons.calendar_month), onTap: () async {
            final now = DateTime.now(); final today = DateTime(now.year, now.month, now.day);
            final chosen = await showDatePicker(context: context,
              initialDate: date != null && !date!.isBefore(today) ? date! : today,
              firstDate: today, lastDate: DateTime(2100));
            if (chosen != null && mounted) setState(() => date = chosen);
          }),
        for (final isStart in [true, false]) ListTile(title: Text(isStart ? 'Jam mulai' : 'Jam selesai'),
          subtitle: Text((isStart ? start : end)?.format(context) ?? 'Belum dipilih'),
          trailing: const Icon(Icons.schedule), onTap: () async {
            final t = await showTimePicker(context: context,
              initialTime: (isStart ? start : end) ?? const TimeOfDay(hour: 9, minute: 0));
            if (t != null && mounted) setState(() { if (isStart) { start = t; } else { end = t; } });
          }),
        OutlinedButton.icon(icon: const Icon(Icons.location_on), label: const Text('Pilih Lokasi Venue'), onPressed: () async {
          final result = await Navigator.push<Map<String, double>>(context,
            MaterialPageRoute(builder: (_) => const VenuePickerPage()));
          if (result != null && mounted) setState(() { lat = result['lat']; lng = result['lng']; });
        }),
        Text(lat == null ? 'Lokasi belum dipilih' : 'Koordinat: $lat, $lng'),
        const Text('Pemilih lokasi anggota B saat ini masih berupa titik contoh Gedung Sate.'),
        const SizedBox(height: 12), posterPreview(poster),
        OutlinedButton.icon(icon: const Icon(Icons.photo_library), label: const Text('Pilih Poster dari Galeri (JPG/PNG, maks. 5 MB)'),
          onPressed: picking ? null : () async {
            setState(() => picking = true);
            try {
              final path = await pickPoster();
              if (path != null && mounted) setState(() => poster = path);
            } catch (_) {
              if (mounted) message('Gagal memilih poster. Gunakan JPG/PNG maksimal 5 MB dan periksa izin galeri.');
            } finally { if (mounted) setState(() => picking = false); }
          }),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: status, decoration: const InputDecoration(labelText: 'Status'),
          items: ['draft','dipublikasikan'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => status = v!)),
        const SizedBox(height: 20), FilledButton(onPressed: picking ? null : save, child: const Text('Simpan Event')),
      ])));
  }
}
