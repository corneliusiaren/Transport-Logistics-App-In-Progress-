import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shipment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String shipmentsCol = 'shipments';

  Stream<List<Shipment>> shipmentsStream() {
    return _db.collection(shipmentsCol)
      .orderBy('updated_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => Shipment.fromMap(d.id, d.data())).toList());
  }

  Future<DocumentReference> createShipment(Map<String, dynamic> data) async {
    data['created_at'] = FieldValue.serverTimestamp();
    data['updated_at'] = FieldValue.serverTimestamp();
    final ref = await _db.collection(shipmentsCol).add(data);
    return ref;
  }

  Future<void> updateShipment(String id, Map<String, dynamic> data) async {
    data['updated_at'] = FieldValue.serverTimestamp();
    await _db.collection(shipmentsCol).doc(id).update(data);
  }

  Future<void> markDelivered(String id) async {
    await updateShipment(id, {'status': 'delivered'});
  }

  Future<void> createTestUserIfNotExists() async {
    final auth = FirebaseAuth.instance;
    final testEmail = 'test.driver@example.com';
    final testPassword = 'Test@1234';
    try {
      final methods = await auth.fetchSignInMethodsForEmail(testEmail);
      if (methods.isEmpty) {
        await auth.createUserWithEmailAndPassword(email: testEmail, password: testPassword);
        // Optionally set displayName
        await auth.currentUser?.updateDisplayName('Test Driver');
        await auth.signOut();
      }
    } catch (e) {
      // ignore - existing user or permission issues
    }
  }
}
