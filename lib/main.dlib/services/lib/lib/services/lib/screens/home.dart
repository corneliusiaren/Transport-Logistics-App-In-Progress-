import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transport & Logistics')),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.shipmentsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No shipments yet.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final d = docs[i];
              final data = d.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? 'Shipment'),
                subtitle: Text('Status: ${data['status'] ?? 'unknown'}\nLocation: ${data['location'] ?? '—'}'),
                trailing: Text(data['updated_at']?.toString() ?? ''),
                onTap: () {/* show detail / map view */},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await service.createShipment({
            'title': 'Shipment ${DateTime.now().millisecondsSinceEpoch}',
            'status': 'created',
            'location': 'Warehouse A',
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
