class EventModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String city;
  final String venueName;
  final String address;
  final int price;
  final int remainingQuota;
  final double latitude;
  final double longitude;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.city,
    required this.venueName,
    required this.address,
    required this.price,
    required this.remainingQuota,
    required this.latitude,
    required this.longitude,
  });
}