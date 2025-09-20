class Shipment {
  final String id;
  final String title;
  final String status; // e.g., created, in_transit, delivered, delayed
  final double lat;
  final double lng;
  final String driverName;
  final String vehicleId;
  final DateTime eta;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shipment({
    required this.id,
    required this.title,
    required this.status,
    required this.lat,
    required this.lng,
    required this.driverName,
    required this.vehicleId,
    required this.eta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shipment.fromMap(String id, Map<String, dynamic> m) {
    return Shipment(
      id: id,
      title: m['title'] ?? 'Shipment',
      status: m['status'] ?? 'created',
      lat: (m['lat'] ?? 9.057) + 0.0,
      lng: (m['lng'] ?? 7.495) + 0.0,
      driverName: m['driverName'] ?? 'Unknown',
      vehicleId: m['vehicleId'] ?? 'UNKNOWN-001',
      eta: (m['eta'] != null) ? (m['eta'] as Timestamp).toDate() : DateTime.now().add(const Duration(hours: 4)),
      createdAt: (m['created_at'] != null) ? (m['created_at'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: (m['updated_at'] != null) ? (m['updated_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}
