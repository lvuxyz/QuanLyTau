// lib/screens/schedule_management_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/train_service.dart';
import '../models/schedule.dart';
import '../models/station.dart';
import '../models/train.dart';

class ScheduleManagementScreen extends StatefulWidget {
  @override
  _ScheduleManagementScreenState createState() => _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends State<ScheduleManagementScreen> {
  final TrainService _trainService = TrainService();

  List<Schedule> _schedules = [];
  List<Train> _trains = [];
  List<Station> _stations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load trains, stations and schedules in parallel
      final results = await Future.wait([
        _trainService.getTrains(),
        _trainService.getStations(),
        _trainService.getSchedules(),
      ]);

      setState(() {
        _trains = results[0] as List<Train>;
        _stations = results[1] as List<Station>;
        _schedules = results[2] as List<Schedule>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải dữ liệu. Vui lòng thử lại sau.';
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
        title: Text('Quản lý lịch trình'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF13B8A8),
        backgroundColor: Color(0xFF333333),
        onRefresh: _loadData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)))
            : _error != null
            ? _buildErrorView()
            : _buildScheduleList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditScheduleDialog();
        },
        backgroundColor: Color(0xFF13B8A8),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            _error ?? 'Đã xảy ra lỗi',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B8A8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    if (_schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có lịch trình nào',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nhấp vào nút + để thêm lịch trình mới',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
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

    // Tìm tàu tương ứng
    final train = _trains.firstWhere(
          (train) => train.id == schedule.trainId,
      orElse: () => Train(
        id: 'unknown',
        trainType: 'Không xác định',
        trainOperator: 'Không xác định',
        capacity: 0,
        status: 'UNKNOWN',
        amenities: [],
      ),
    );

    return Dismissible(
      key: Key(schedule.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(schedule);
      },
      onDismissed: (direction) {
        // Handle schedule deletion
        setState(() {
          _schedules.removeWhere((item) => item.id == schedule.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa lịch trình'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Hoàn tác',
              onPressed: () {
                // Restore the schedule
                setState(() {
                  _schedules.add(schedule);
                  // Sort schedules again
                  _schedules.sort((a, b) => a.departureDate.compareTo(b.departureDate));
                });
              },
            ),
          ),
        );
      },
      child: Card(
        color: Color(0xFF2A2A2A),
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            _showAddEditScheduleDialog(schedule: schedule);
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
                      train.trainType,
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
                    Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Color(0xFF13B8A8),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Chỉnh sửa',
                          style: TextStyle(
                            color: Color(0xFF13B8A8),
                            fontSize: 14,
                          ),
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

  Future<bool> _showDeleteConfirmationDialog(Schedule schedule) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF333333),
          title: Text(
            'Xác nhận xóa',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa lịch trình này không?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showFilterDialog() {
    // Implementation for filter dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF333333),
          title: Text(
            'Lọc lịch trình',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filter options here
                Text(
                  'Tính năng đang phát triển',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Đóng',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEditScheduleDialog({Schedule? schedule}) {
    final isEditing = schedule != null;

    // Prepare controllers and initial values
    final trainController = TextEditingController();
    final departureStationController = TextEditingController();
    final arrivalStationController = TextEditingController();
    final departureDateController = TextEditingController();
    final departureTimeController = TextEditingController();
    final arrivalTimeController = TextEditingController();

    // Set initial values if editing
    if (isEditing) {
      departureStationController.text = schedule.departureStation;
      arrivalStationController.text = schedule.arrivalStation;
      departureDateController.text = schedule.departureDate;
      departureTimeController.text = schedule.departureTime;
      arrivalTimeController.text = schedule.arrivalTime;

      // Find the train for the dropdown
      final train = _trains.firstWhere(
            (t) => t.id == schedule.trainId,
        orElse: () => _trains.first,
      );
      trainController.text = train.trainType;
    }

    // Show the dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF333333),
        title: Text(
          isEditing ? 'Chỉnh sửa lịch trình' : 'Thêm lịch trình mới',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Implementation for schedule form
              Text(
                'Tính năng đang phát triển',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF13B8A8),
            ),
            child: Text(
              isEditing ? 'Cập nhật' : 'Thêm mới',
            ),
            onPressed: () {
              // Handle save/update
              Navigator.of(context).pop();
            },
          ),
        ],
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