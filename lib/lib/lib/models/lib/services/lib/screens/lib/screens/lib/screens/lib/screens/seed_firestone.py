# seed_firestore.py
from google.cloud import firestore
import datetime
import os
import json

# Set path to your service account JSON in environment or provide path here:
# os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/path/to/serviceAccountKey.json'

db = firestore.Client()

shipments = [
    {
        "title": "Electronics consignment #A-1001",
        "status": "in_transit",
        "lat": 9.076479,
        "lng": 7.398574,
        "driverName": "Emeka Okafor",
        "vehicleId": "TRUK-4521",
        "eta": datetime.datetime(2025,9,22,14,30),
        "notes": "Fragile; keep upright"
    },
    {
        "title": "Pharmaceutical batch PH-33",
        "status": "created",
        "lat": 6.4551,
        "lng": 3.3846,
        "driverName": "Fatima Sani",
        "vehicleId": "VAN-1034",
        "eta": datetime.datetime(2025,9,21,9,0),
        "notes": "Temperature sensitive"
    },
    {
        "title": "Construction steel beams",
        "status": "delayed",
        "lat": 4.8156,
        "lng": 7.0498,
        "driverName": "Chinedu Nwosu",
        "vehicleId": "TRLR-7770",
        "eta": datetime.datetime(2025,9,20,18,0),
        "notes": "Roadworks causing delay"
    },
    {
        "title": "Consumer goods pallet B-501",
        "status": "in_transit",
        "lat": 9.05785,
        "lng": 7.49508,
        "driverName": "Ibrahim Musa",
        "vehicleId": "TRUK-5588",
        "eta": datetime.datetime(2025,9,21,16,30),
        "notes": ""
    }
]

def seed():
    col = db.collection('shipments')
    for s in shipments:
        data = s.copy()
        data['created_at'] = firestore.SERVER_TIMESTAMP
        data['updated_at'] = firestore.SERVER_TIMESTAMP
        data['eta'] = s['eta']
        doc_ref = col.add(data)
        print("Added", doc_ref)

if __name__ == "__main__":
    seed()
