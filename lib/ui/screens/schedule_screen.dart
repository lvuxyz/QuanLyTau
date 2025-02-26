// lib/ui/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> _ports = [];
  List<Map<String, dynamic>> _schedules = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;

  // Search filters
  String? _selectedDeparturePort;
  String? _selectedArrivalPort;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load port list (simulated)
      await Future.delayed(const Duration(milliseconds: 500));
      final ports = [
        {'id': '1', 'name': 'Singapore Port'},
        {'id': '2', 'name': 'Hong Kong Port'},
        {'id': '3', 'name': 'Shanghai Port'},
        {'id': '4', 'name': 'Busan Port'},
        {'id': '5', 'name': 'Tokyo Port'},
      ];

      // Load default schedules (next 7 days)
      await Future.delayed(const Duration(milliseconds: 300));
      final schedules = [
        {
          'id': '101',
          'shipId': '1',
          'shipType': 'Cargo Ship Alpha',
          'departureDate': '2023-11-10',
          'departureTime': '09:30',
          'arrivalTime': '18:45',
          'departurePort': 'Singapore Port',
          'arrivalPort': 'Hong Kong Port',
          'status': 'ACTIVE',
        },
        {
          'id': '102',
          'shipId': '3',
          'shipType': 'Container Ship Gamma',
          'departureDate': '2023-11-12',
          'departureTime': '07:15',
          'arrivalTime': '16:30',
          'departurePort': 'Busan Port',
          'arrivalPort': 'Tokyo Port',
          'status': 'PENDING',
        },
        {
          'id': '103',
          'shipId': '1',
          'shipType': 'Cargo Ship Alpha',
          'departureDate': '2023-11-15',
          'departureTime': '14:00',
          'arrivalTime': '08:30',
          'departurePort': 'Hong Kong Port',
          'arrivalPort': 'Shanghai Port',
          'status': 'ACTIVE',
        },
      ];

      setState(() {
        _ports = ports;
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data. Please try again later.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchSchedules() async {
    if (_selectedDeparturePort == null && _selectedArrivalPort == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least a departure or arrival port'))
      );
      return;
    }

    try {
      setState(() {
        _isSearching = true;
        _error = null;
      });

      final dateFormat = DateFormat('yyyy-MM-dd');
      final fromDate = dateFormat.format(_selectedDate);

      // Calculate end date (7 days after selected date)
      final toDate = dateFormat.format(
          _selectedDate.add(const Duration(days: 7))
      );

      // Simulate API call with search parameters
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock filtered schedules
      final filteredSchedules = [
        {
          'id': '101',
          'shipId': '1',
          'shipType': 'Cargo Ship Alpha',
          'departureDate': '2023-11-10',
          'departureTime': '09:30',
          'arrivalTime': '18:45',
          'departurePort': 'Singapore Port',
          'arrivalPort': 'Hong Kong Port',
          'status': 'ACTIVE',
        },
        {
          'id': '104',
          'shipId': '2',
          'shipType': 'Tanker Beta',
          'departureDate': '2023-11-11',
          'departureTime': '11:00',
          'arrivalTime': '20:15',
          'departurePort': 'Singapore Port',
          'arrivalPort': 'Busan Port',
          'status': 'ACTIVE',
        },
      ];

      setState(() {
        _schedules = filteredSchedules;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to search schedules. Please try again later.';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Schedule Search'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchForm(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: const Color(0xFF13B8A8)))
                : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white70)))
                : _buildScheduleList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13B8A8),
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to create schedule screen
        },
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          // Departure port
          _buildPortDropdown(
            label: 'Departure Port',
            value: _selectedDeparturePort,
            onChanged: (String? portName) {
              setState(() {
                _selectedDeparturePort = portName;
              });
            },
          ),

          const SizedBox(height: 12),

          // Arrival port
          _buildPortDropdown(
            label: 'Arrival Port',
            value: _selectedArrivalPort,
            onChanged: (String? portName) {
              setState(() {
                _selectedArrivalPort = portName;
              });
            },
          ),

          const SizedBox(height: 12),

          // Date picker
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Departure Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.white70),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Search button
          ElevatedButton(
            onPressed: _isSearching ? null : _searchSchedules,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B8A8),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSearching
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildPortDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: const Color(0xFF333333),
          hint: Text(label, style: const TextStyle(color: Colors.white70)),
          value: value,
          items: _ports.map((port) {
            return DropdownMenuItem<String>(
              value: port['name'],
              child: Text(
                port['name'],
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF13B8A8),
              onPrimary: Colors.white,
              surface: Color(0xFF333333),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildScheduleList() {
    if (_schedules.isEmpty) {
      return const Center(
        child: Text(
          'No schedules found',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    // Format date display
    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime departureDate;
    try {
      departureDate = DateTime.parse(schedule['departureDate']);
    } catch (e) {
      departureDate = DateTime.now();
    }

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
            // Navigate to schedule details
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      schedule['shipType'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(schedule['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(schedule['status']),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Departure',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            schedule['departurePort'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            schedule['departureTime'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF13B8A8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Arrival',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            schedule['arrivalPort'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            schedule['arrivalTime'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF13B8A8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(departureDate),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                          onPressed: () {
                            // Edit schedule
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {
                            // Delete schedule
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
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
      case 'RUNNING':
        return const Color(0xFF00C853);
      case 'PENDING':
        return const Color(0xFFFFB300);
      case 'CANCELLED':
        return const Color(0xFFFF3D00);
      case 'DELAYED':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF757575);
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Active';
      case 'RUNNING':
        return 'Running';
      case 'PENDING':
        return 'Pending';
      case 'CANCELLED':
        return 'Cancelled';
      case 'DELAYED':
        return 'Delayed';
      default:
        return status;
    }
  }
}