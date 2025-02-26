// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/train_service.dart';
import '../models/schedule.dart';
import '../models/station.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TrainService _trainService = TrainService();

  List<Station> _stations = [];
  List<Schedule> _schedules = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;

  // Bộ lọc tìm kiếm
  Station? _selectedDepartureStation;
  Station? _selectedArrivalStation;
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

      // Tải danh sách ga
      final stations = await _trainService.getStations();

      // Tải lịch trình mặc định (7 ngày tới)
      final now = DateTime.now();
      final fromDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final nextWeek = now.add(Duration(days: 7));
      final toDate = '${nextWeek.year}-${nextWeek.month.toString().padLeft(2, '0')}-${nextWeek.day.toString().padLeft(2, '0')}';

      final schedules = await _trainService.getSchedules(
          fromDate: fromDate,
          toDate: toDate,
          status: 'ACTIVE'
      );

      setState(() {
        _stations = stations;
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải dữ liệu. Vui lòng thử lại sau.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchSchedules() async {
    if (_selectedDepartureStation == null && _selectedArrivalStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ít nhất một ga đi hoặc ga đến'))
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

      // Tính toán ngày kết thúc (7 ngày sau ngày đã chọn)
      final toDate = dateFormat.format(
          _selectedDate.add(Duration(days: 7))
      );

      final schedules = await _trainService.getSchedules(
          departureStation: _selectedDepartureStation?.stationName,
          arrivalStation: _selectedArrivalStation?.stationName,
          fromDate: fromDate,
          toDate: toDate,
          status: 'ACTIVE'
      );

      setState(() {
        _schedules = schedules;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tìm kiếm lịch trình. Vui lòng thử lại sau.';
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
        title: Text('Tìm Kiếm Lịch Trình'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchForm(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)))
                : _error != null
                ? Center(child: Text(_error!, style: TextStyle(color: Colors.white70)))
                : _buildScheduleList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFF2A2A2A),
      child: Column(
        children: [
          // Ga đi
          _buildStationDropdown(
            label: 'Ga đi',
            value: _selectedDepartureStation,
            onChanged: (Station? station) {
              setState(() {
                _selectedDepartureStation = station;
              });
            },
          ),

          SizedBox(height: 12),

          // Ga đến
          _buildStationDropdown(
            label: 'Ga đến',
            value: _selectedArrivalStation,
            onChanged: (Station? station) {
              setState(() {
                _selectedArrivalStation = station;
              });
            },
          ),

          SizedBox(height: 12),

          // Chọn ngày
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Ngày khởi hành: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.white70),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Nút tìm kiếm
          ElevatedButton(
            onPressed: _isSearching ? null : _searchSchedules,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF13B8A8),
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSearching
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text('Tìm Kiếm'),
          ),
        ],
      ),
    );
  }

  Widget _buildStationDropdown({
    required String label,
    required Station? value,
    required ValueChanged<Station?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Station>(
          isExpanded: true,
          dropdownColor: Color(0xFF333333),
          hint: Text(label, style: TextStyle(color: Colors.white70)),
          value: value,
          items: _stations.map((station) {
            return DropdownMenuItem<Station>(
              value: station,
              child: Text(
                station.stationName,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
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
      return Center(
        child: Text(
          'Không tìm thấy lịch trình nào',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    // Format hiển thị ngày tháng
    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime departureDate;
    try {
      departureDate = DateTime.parse(schedule.departureDate);
    } catch (e) {
      departureDate = DateTime.now();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Xử lý sự kiện khi nhấp vào thẻ lịch trình
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
                      schedule.train?.trainType ?? 'Tàu ${schedule.trainId}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(schedule.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(schedule.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ga đi',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            schedule.departureStation,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            schedule.departureTime,
                            style: TextStyle(
                              color: Color(0xFF13B8A8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ga đến',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            schedule.arrivalStation,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            schedule.arrivalTime,
                            style: TextStyle(
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
                SizedBox(height: 12),
                Divider(height: 1, color: Colors.white24),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          dateFormat.format(departureDate),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý sự kiện đặt vé
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF13B8A8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text('Đặt vé'),
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
      case 'RUNNING':
        return Color(0xFF00C853); // Xanh lá
      case 'PENDING':
        return Color(0xFFFFB300); // Vàng cam
      case 'CANCELLED':
        return Color(0xFFFF3D00); // Đỏ
      case 'DELAYED':
        return Color(0xFFFF9800); // Cam
      default:
        return Color(0xFF757575); // Xám
    }
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Hoạt động';
      case 'RUNNING':
        return 'Đang chạy';
      case 'PENDING':
        return 'Chờ khởi hành';
      case 'CANCELLED':
        return 'Đã hủy';
      case 'DELAYED':
        return 'Trễ chuyến';
      default:
        return status;
    }
  }
}