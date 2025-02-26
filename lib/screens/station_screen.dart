// lib/screens/station_screen.dart
import 'package:flutter/material.dart';
import '../models/station.dart';
import '../services/station_service.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({Key? key}) : super(key: key);

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final StationService _stationService = StationService();

  List<Station> _stations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stations = await _stationService.getStations();
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải danh sách ga. Vui lòng thử lại sau.';
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
        title: Text('Quản lý Ga'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF13B8A8),
        backgroundColor: Color(0xFF333333),
        onRefresh: () async {
          await _loadStations();
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)))
            : _error != null
            ? _buildErrorView()
            : _buildStationList(),
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
            onPressed: _loadStations,
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

  Widget _buildStationList() {
    if (_stations.isEmpty) {
      return Center(
        child: Text(
          'Không có ga nào',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      itemCount: _stations.length,
      itemBuilder: (context, index) {
        final station = _stations[index];
        return _buildStationCard(station);
      },
    );
  }

  Widget _buildStationCard(Station station) {
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
            // Xử lý sự kiện khi nhấp vào ga
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
                        color: Color(0xFF13B8A8).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.train,
                        color: Color(0xFF13B8A8),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.stationName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            station.location,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF333333),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.route,
                            color: Color(0xFF13B8A8),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${station.numberOfLines ?? 0} tuyến',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (station.facilities != null && station.facilities!.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Divider(height: 1, color: Colors.white24),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.local_activity,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tiện ích:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    station.facilities!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
                if (station.operatingHours != null && station.operatingHours!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Giờ hoạt động: ${station.operatingHours}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
                if (station.contactInfo != null && station.contactInfo!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white70,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Liên hệ: ${station.contactInfo}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}