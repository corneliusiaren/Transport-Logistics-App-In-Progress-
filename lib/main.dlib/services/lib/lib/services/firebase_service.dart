import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> shipmentsStream() {
    return _db.collection('shipments').orderBy('updated_at', descending: true).snapshots();
  }

  Future<void> createShipment(Map<String, dynamic> data) async {
    data['created_at'] = FieldValue.serverTimestamp();
    data['updated_at'] = FieldValue.serverTimestamp();
    await _db.collection('shipments').add(data);
  }

  Future<void> updateShipment(String id, Map<String, dynamic> data) async {
    data['updated_at'] = FieldValue.serverTimestamp();
    await _db.collection('shipments').doc(id).update(data);
  }
}
