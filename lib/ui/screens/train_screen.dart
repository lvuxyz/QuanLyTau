// lib/ui/screens/train_screen.dart
import 'package:flutter/material.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  _TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  List<Map<String, dynamic>> _ships = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShips();
  }

  Future<void> _loadShips() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      final ships = [
        {
          'id': '1',
          'name': 'Cargo Ship Alpha',
          'status': 'ACTIVE',
          'operator': 'Maritime Logistics Inc.',
          'capacity': 5000,
          'lastMaintenanceDate': '2023-10-15',
          'amenities': ['GPS', 'Radar', 'Satellite Communication']
        },
        {
          'id': '2',
          'name': 'Tanker Beta',
          'status': 'MAINTENANCE',
          'operator': 'Ocean Shipping Co.',
          'capacity': 7500,
          'lastMaintenanceDate': '2023-11-02',
          'amenities': ['GPS', 'Radar', 'Emergency Systems']
        },
        {
          'id': '3',
          'name': 'Container Ship Gamma',
          'status': 'ACTIVE',
          'operator': 'Global Transport Ltd.',
          'capacity': 6000,
          'lastMaintenanceDate': '2023-09-28',
          'amenities': ['GPS', 'Advanced Navigation', 'Crew Quarters']
        },
        {
          'id': '4',
          'name': 'Bulk Carrier Delta',
          'status': 'OUT_OF_SERVICE',
          'operator': 'Coastal Shipping Services',
          'capacity': 4500,
          'lastMaintenanceDate': '2023-08-20',
          'amenities': ['GPS', 'Communication Systems']
        },
      ];

      setState(() {
        _ships = ships;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load ship list. Please try again later.';
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
        title: const Text('Ship Management'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF13B8A8),
        backgroundColor: const Color(0xFF333333),
        onRefresh: _loadShips,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)))
            : _error != null
            ? _buildErrorView()
            : _buildShipList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13B8A8),
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add ship screen
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadShips,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B8A8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildShipList() {
    if (_ships.isEmpty) {
      return const Center(
        child: Text(
          'No ships found',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _ships.length,
      itemBuilder: (context, index) {
        final ship = _ships[index];
        return _buildShipCard(ship);
      },
    );
  }

  Widget _buildShipCard(Map<String, dynamic> ship) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to ship details
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getStatusColor(ship['status']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.directions_boat,
                        color: _getStatusColor(ship['status']),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ship['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ship['operator'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ship['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(ship['status']),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF00C853); // Green
      case 'MAINTENANCE':
        return const Color(0xFFFFB300); // Amber
      case 'OUT OF SERVICE':
      case 'OUT_OF_SERVICE':
        return const Color(0xFFFF3D00); // Red
      case 'RESERVED':
        return const Color(0xFF2196F3); // Blue
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Active';
      case 'MAINTENANCE':
        return 'Maintenance';
      case 'OUT OF SERVICE':
      case 'OUT_OF_SERVICE':
        return 'Out of Service';
      case 'RESERVED':
        return 'Reserved';
      default:
        return status;
    }
  }
}
