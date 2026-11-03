import 'package:flutter/material.dart';
import '../../../core/dummy/dummy_events.dart';

class EventProvider extends ChangeNotifier {
  // Mengambil data dummy
  final List<DummyEvent> _allEvents = dummyEvents;

  String _searchQuery = '';
  String _selectedCity = 'Semua';

  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;

  // filter event untuk beranda peserta
  List<DummyEvent> get filteredEvents {
    return _allEvents.where((event) {
      // peserta hanya melihat event yang dipublikasikan
      final isPublished = event.eventStatus == 'dipublikasikan';
      
      // filter judul pencarian
      final matchQuery = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // filter berdasarkan Kota/Kabupaten venue
      final venue = venueOf(event);
      final matchCity = _selectedCity == 'Semua' || (venue != null && venue.regency == _selectedCity);

      return isPublished && matchQuery && matchCity;
    }).toList();
  }

  // fungsi pencarian
  void searchEvents(String query) {
    _searchQuery = query;
    notifyListeners(); // render ulang
  }

  // fungsi filter wilayah
  void filterByCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  // reset filter pencarian
  void resetFilter() {
    _searchQuery = '';
    _selectedCity = 'Semua';
    notifyListeners();
  }
}