// lib/screens/train_screen.dart
import 'package:flutter/material.dart';
import '../models/train.dart';
import '../services/train_service.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({Key? key}) : super(key: key);

  @override
  _TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  final TrainService _trainService = TrainService();

  List<Train> _trains = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrains();
  }

  Future<void> _loadTrains() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final trains = await _trainService.getTrains();
      setState(() {
        _trains = trains;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải danh sách tàu. Vui lòng thử lại sau.';
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
        title: Text('Quản lý Tàu'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF13B8A8),
        backgroundColor: Color(0xFF333333),
        onRefresh: () async {
          await _loadTrains();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)))
            : _error != null
            ? _buildErrorView()
            : _buildTrainList(),
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
            onPressed: _loadTrains,
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

  Widget _buildTrainList() {
    if (_trains.isEmpty) {
      return Center(
        child: Text(
          'Không có tàu nào',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      itemCount: _trains.length,
      itemBuilder: (context, index) {
        final train = _trains[index];
        return _buildTrainCard(train);
      },
    );
  }

  Widget _buildTrainCard(Train train) {
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
            // Xử lý sự kiện khi nhấp vào tàu
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
                        color: _getStatusColor(train.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.directions_railway,
                        color: _getStatusColor(train.status),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            train.trainType,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            train.trainOperator,
                            style: TextStyle(
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(train.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(train.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (train.capacity != null) ...[
                  SizedBox(height: 16),
                  Divider(height: 1, color: Colors.white24),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sức chứa: ${train.capacity} hành khách',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
                if (train.lastMaintenanceDate != null && train.lastMaintenanceDate!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.build,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Bảo trì lần cuối: ${train.lastMaintenanceDate}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
                if (train.amenities != null && train.amenities.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Tiện ích:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (train.amenities as List).map<Widget>((amenity) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF333333),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          amenity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
        return Color(0xFF00C853); // Xanh lá
      case 'MAINTENANCE':
        return Color(0xFFFFB300); // Vàng cam
      case 'OUT OF SERVICE':
      case 'OUT_OF_SERVICE':
        return Color(0xFFFF3D00); // Đỏ
      case 'RESERVED':
        return Color(0xFF2196F3); // Xanh dương
      default:
        return Color(0xFF757575); // Xám
    }
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Hoạt động';
      case 'MAINTENANCE':
        return 'Bảo trì';
      case 'OUT OF SERVICE':
      case 'OUT_OF_SERVICE':
        return 'Ngưng phục vụ';
      case 'RESERVED':
        return 'Đã đặt trước';
      default:
        return status;
    }
  }
}