rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /shipments/{shipmentId} {
      allow read, write: if request.auth != null;
      // optionally: allow update/delete if request.auth.uid == resource.data.ownerUid
    }
    // limit other collections
    match /{document=**} { allow read, write: if false; }
  }
}
