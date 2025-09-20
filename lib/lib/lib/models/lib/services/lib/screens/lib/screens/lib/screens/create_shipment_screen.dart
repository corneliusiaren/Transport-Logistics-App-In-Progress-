import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});
  @override State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _title = TextEditingController();
  final _driver = TextEditingController();
  final _vehicle = TextEditingController();
  final _lat = TextEditingController(text: '9.057'); // default sample (e.g., Abuja/Nigeria coords)
  final _lng = TextEditingController(text: '7.495');
  DateTime _eta = DateTime.now().add(const Duration(hours: 4));
  String _status = 'created';
  final FirebaseService _svc = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Shipment')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: _driver, decoration: const InputDecoration(labelText: 'Driver name')),
          TextField(controller: _vehicle, decoration: const InputDecoration(labelText: 'Vehicle ID')),
          TextField(controller: _lat, decoration: const InputDecoration(labelText: 'Latitude')),
          TextField(controller: _lng, decoration: const InputDecoration(labelText: 'Longitude')),
          const SizedBox(height: 10),
          ListTile(
            title: Text('ETA: ${DateFormat('yyyy-MM-dd HH:mm').format(_eta)}'),
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () async {
              final dt = await showDatePicker(context: context, initialDate: _eta, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (dt == null) return;
              final tm = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_eta));
              if (tm == null) return;
              setState(() { _eta = DateTime(dt.year, dt.month, dt.day, tm.hour, tm.minute); });
            }),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _status,
            items: ['created','in_transit','delayed','delivered'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _status = v ?? 'created'),
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height:20),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'title': _title.text.isNotEmpty ? _title.text : 'Shipment ${DateTime.now().millisecondsSinceEpoch}',
                'driverName': _driver.text.isNotEmpty ? _driver.text : 'Test Driver',
                'vehicleId': _vehicle.text.isNotEmpty ? _vehicle.text : 'TRUCK-001',
                'lat': double.tryParse(_lat.text) ?? 9.057,
                'lng': double.tryParse(_lng.text) ?? 7.495,
                'status': _status,
                'eta': Timestamp.fromDate(_eta),
                'notes': ''
              };
              await _svc.createShipment(data);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Create Shipment')),
        ]),
      ),
    );
  }
}
