// lib/ui/screens/station_screen.dart
import 'package:flutter/material.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({Key? key}) : super(key: key);

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  List<Map<String, dynamic>> _ports = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPorts();
  }

  Future<void> _loadPorts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      final ports = [
        {
          'id': '201',
          'name': 'Singapore Port',
          'location': 'Singapore',
          'shipCount': 12,
          'facilities': 'Cargo handling, Ship repair, Container storage',
          'operatingHours': '24/7',
          'contactInfo': '+65 1234 5678',
        },
        {
          'id': '202',
          'name': 'Hong Kong Port',
          'location': 'Hong Kong, China',
          'shipCount': 8,
          'facilities': 'Container terminal, Bulk cargo',
          'operatingHours': '24/7',
          'contactInfo': '+852 9876 5432',
        },
        {
          'id': '203',
          'name': 'Busan Port',
          'location': 'Busan, South Korea',
          'shipCount': 10,
          'facilities': 'Container handling, Ship maintenance',
          'operatingHours': '6:00 - 22:00',
          'contactInfo': '+82 5551 2345',
        },
        {
          'id': '204',
          'name': 'Tokyo Port',
          'location': 'Tokyo, Japan',
          'shipCount': 7,
          'facilities': 'Cargo terminal, Passenger terminal',
          'operatingHours': '7:00 - 23:00',
          'contactInfo': '+81 3334 5678',
        },
        {
          'id': '205',
          'name': 'Shanghai Port',
          'location': 'Shanghai, China',
          'shipCount': 15,
          'facilities': 'Container terminal, Ship repair, Logistics center',
          'operatingHours': '24/7',
          'contactInfo': '+86 2134 5678',
        },
      ];

      setState(() {
        _ports = ports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load port list. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Port Management'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF13B8A8),
        backgroundColor: const Color(0xFF333333),
        onRefresh: _loadPorts,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: const Color(0xFF13B8A8)))
            : _error != null
            ? _buildErrorView()
            : _buildPortList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13B8A8),
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add port screen
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPorts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B8A8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildPortList() {
    if (_ports.isEmpty) {
      return const Center(
        child: Text(
          'No ports found',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _ports.length,
      itemBuilder: (context, index) {
        final port = _ports[index];
        return _buildPortCard(port);
      },
    );
  }

  Widget _buildPortCard(Map<String, dynamic> port) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              port['name'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              port['location'],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            if (port['shipCount'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.directions_boat, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Ships: ${port['shipCount']}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
            if (port['facilities'] != null && port['facilities'].isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Facilities:', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                port['facilities'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
            if (port['operatingHours'] != null && port['operatingHours'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Operating Hours: ${port['operatingHours']}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
            if (port['contactInfo'] != null && port['contactInfo'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Contact: ${port['contactInfo']}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
