import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'shipment_detail_screen.dart';
import 'create_shipment_screen.dart';
import '../models/shipment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async { await FirebaseAuth.instance.signOut(); },
            tooltip: 'Logout',
          )
        ],
      ),
      body: StreamBuilder<List<Shipment>>(
        stream: service.shipmentsStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No shipments yet.'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final s = items[i];
              return ListTile(
                title: Text(s.title),
                subtitle: Text('Driver: ${s.driverName} • Status: ${s.status} • Vehicle: ${s.vehicleId}'),
                trailing: Text(s.eta.toLocal().toString().split('.').first),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShipmentDetailScreen(shipment: s))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateShipmentScreen())),
      ),
    );
  }
}
