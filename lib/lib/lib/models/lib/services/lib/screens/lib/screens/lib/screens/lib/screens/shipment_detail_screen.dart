import 'package:flutter/material.dart';
import '../models/shipment.dart';
import '../services/firebase_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShipmentDetailScreen extends StatelessWidget {
  final Shipment shipment;
  const ShipmentDetailScreen({required this.shipment, super.key});
  final FirebaseService svc = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final LatLng pos = LatLng(shipment.lat, shipment.lng);
    return Scaffold(
      appBar: AppBar(title: Text(shipment.title)),
      body: Column(children: [
        Expanded(
          flex: 2,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: pos, zoom: 12),
            markers: { Marker(markerId: MarkerId(shipment.id), position: pos, infoWindow: InfoWindow(title: shipment.title, snippet: shipment.status)) },
          )
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Driver: ${shipment.driverName}'),
              Text('Vehicle: ${shipment.vehicleId}'),
              Text('Status: ${shipment.status}'),
              Text('ETA: ${shipment.eta.toLocal().toString().split(".").first}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(onPressed: () => svc.updateShipment(shipment.id, {'status': 'in_transit'}), child: const Text('Mark In Transit')),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: () => svc.markDelivered(shipment.id), child: const Text('Mark Delivered')),
                ],
              )
            ]),
          ),
        )
      ]),
    );
  }
}
