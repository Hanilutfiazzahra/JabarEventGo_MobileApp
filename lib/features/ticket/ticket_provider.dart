import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/dummy/dummy_events.dart';
import '../../core/dummy/dummy_tickets.dart';

class RegistrationResult {
  final bool success;
  final String message;
  final DummyRegistration? registration;
  final DummyTicket? ticket;

  RegistrationResult({
    required this.success,
    required this.message,
    this.registration,
    this.ticket,
  });
}

class TicketProvider extends ChangeNotifier {
  // Status yang masih menggunakan kuota.
  bool _isRegistrationActive(String status) {
    return [
      'terdaftar',
      'confirmed',
      'aktif',
      'active',
    ].contains(status.toLowerCase());
  }

  // Mengambil tiket milik pengguna.
  List<DummyTicket> getTicketsByUser(int userId) {
    final registrationIds = dummyRegistrations
        .where((registration) => registration.userId == userId)
        .map((registration) => registration.id)
        .toSet();

    return dummyTickets
        .where((ticket) => registrationIds.contains(ticket.registrationId))
        .toList();
  }

  DummyRegistration? getRegistrationById(int registrationId) {
    try {
      return dummyRegistrations.firstWhere(
        (registration) => registration.id == registrationId,
      );
    } catch (_) {
      return null;
    }
  }

  DummyTicket? getTicketByCode(String ticketCode) {
    try {
      return dummyTickets.firstWhere(
        (ticket) => ticket.ticketCode == ticketCode,
      );
    } catch (_) {
      return null;
    }
  }

  DummyTicket? getTicketByRegistrationId(int registrationId) {
    try {
      return dummyTickets.firstWhere(
        (ticket) => ticket.registrationId == registrationId,
      );
    } catch (_) {
      return null;
    }
  }

  DummyEvent? getEventById(int eventId) {
    try {
      return dummyEvents.firstWhere((event) => event.id == eventId);
    } catch (_) {
      return null;
    }
  }

  // Menghitung jumlah pendaftaran yang masih aktif pada suatu event.
  int getActiveRegistrationCount(int eventId) {
    return dummyRegistrations.where((registration) {
      return registration.eventId == eventId &&
          _isRegistrationActive(registration.registrationStatus);
    }).length;
  }

  // Menghitung kuota yang masih tersedia.
  int getRemainingQuota(int eventId) {
    final event = getEventById(eventId);
    if (event == null) return 0;

    final remaining = event.ticketQuota - getActiveRegistrationCount(eventId);

    debugPrint('EVENT ID: $eventId');
    debugPrint('KUOTA AWAL: ${event.ticketQuota}');
    debugPrint('REGISTRASI AKTIF: ${getActiveRegistrationCount(eventId)}');
    debugPrint('SISA KUOTA: $remaining');

    return remaining < 0 ? 0 : remaining;
  }

  bool isUserRegistered(int userId, int eventId) {
    return dummyRegistrations.any((registration) {
      return registration.userId == userId &&
          registration.eventId == eventId &&
          _isRegistrationActive(registration.registrationStatus);
    });
  }

  int _generateRegistrationId() {
    if (dummyRegistrations.isEmpty) return 1;

    return dummyRegistrations
            .map((registration) => registration.id)
            .reduce(max) +
        1;
  }

  int _generateTicketId() {
    if (dummyTickets.isEmpty) return 1;

    return dummyTickets.map((ticket) => ticket.id).reduce(max) + 1;
  }

  String _generateTicketCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    String ticketCode;

    do {
      final code = List.generate(
        6,
        (_) => characters[random.nextInt(characters.length)],
      ).join();

      ticketCode = 'JEG-$code';
    } while (dummyTickets.any(
      (ticket) => ticket.ticketCode == ticketCode,
    ));

    return ticketCode;
  }

  // Proses pendaftaran tiket.
  RegistrationResult registerForEvent({
    required int userId,
    required int eventId,
    required String namaPeserta,
    required String emailPeserta,
  }) {
    final event = getEventById(eventId);

    if (event == null) {
      return RegistrationResult(
        success: false,
        message: 'Event tidak ditemukan.',
      );
    }

    if (namaPeserta.trim().isEmpty || emailPeserta.trim().isEmpty) {
      return RegistrationResult(
        success: false,
        message: 'Nama dan email peserta harus diisi.',
      );
    }

    if (isUserRegistered(userId, eventId)) {
      return RegistrationResult(
        success: false,
        message: 'Anda sudah terdaftar pada event ini.',
      );
    }

    if (getRemainingQuota(eventId) <= 0) {
      return RegistrationResult(
        success: false,
        message: 'Maaf, kuota event sudah penuh.',
      );
    }

    final registration = DummyRegistration(
      id: _generateRegistrationId(),
      userId: userId,
      eventId: eventId,
      namaPeserta: namaPeserta.trim(),
      emailPeserta: emailPeserta.trim(),
      registrationDate: DateTime.now(),
      registrationStatus: 'terdaftar',
    );

    final ticket = DummyTicket(
      id: _generateTicketId(),
      registrationId: registration.id,
      eventId: eventId,
      ticketCode: _generateTicketCode(),
      ticketStatus: 'aktif',
      issuedAt: DateTime.now(),
    );

    dummyRegistrations.add(registration);
    dummyTickets.add(ticket);

    debugPrint('=== HASIL PENDAFTARAN ===');
    debugPrint('Event ID: $eventId');
    debugPrint('User ID: $userId');
    debugPrint('Status registrasi: ${registration.registrationStatus}');
    debugPrint('Jumlah registrasi: ${dummyRegistrations.length}');
    debugPrint(
        'Registrasi aktif event: ${getActiveRegistrationCount(eventId)}');
    debugPrint('Sisa kuota: ${getRemainingQuota(eventId)}');

    notifyListeners();

    return RegistrationResult(
      success: true,
      message: 'Pendaftaran berhasil! Tiket kamu sudah dibuat.',
      registration: registration,
      ticket: ticket,
    );
  }

  // Membatalkan tiket dan mengembalikan kuota.
  bool cancelTicket(int ticketId) {
    final ticketIndex = dummyTickets.indexWhere(
      (ticket) => ticket.id == ticketId,
    );

    if (ticketIndex == -1) return false;

    final ticket = dummyTickets[ticketIndex];

    if (ticket.ticketStatus == 'dibatalkan' ||
        ticket.ticketStatus == 'cancelled' ||
        ticket.ticketStatus == 'sudah_checkin') {
      return false;
    }

    final registration = getRegistrationById(ticket.registrationId);
    if (registration == null) return false;

    ticket.ticketStatus = 'dibatalkan';
    registration.registrationStatus = 'dibatalkan';

    notifyListeners();
    return true;
  }
}