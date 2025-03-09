// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';
import '../blocs/ship/ship_bloc.dart';
import 'ship_management_screen.dart';
import 'schedule_management_screen.dart';
import 'station_screen.dart';
import 'profile_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedMenuIndex = 0;

  final List<String> _menuTitles = [
    'Tổng quan',
    'Quản lý tàu',
    'Quản lý lịch trình',
    'Quản lý trạm',
    'Thống kê'
  ];

  @override
  void initState() {
    super.initState();
    // Make sure the event is properly defined
    // context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(_menuTitles[_selectedMenuIndex]),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Make sure the event is properly defined
              // context.read<HomeBloc>().add(RefreshHomeData());
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildAdminDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF13B8A8)),
            );
          } else if (state is HomeError) {
            return _buildErrorView(state.message);
          } else if (state is HomeLoaded) {
            return _buildDashboard(state);
          }
          return const Center(
            child: Text(
              'Đang tải dữ liệu...',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF222222),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(icon: Icons.dashboard, title: 'Tổng quan', index: 0),
          _buildDrawerItem(icon: Icons.directions_boat, title: 'Quản lý tàu', index: 1),
          _buildDrawerItem(icon: Icons.schedule, title: 'Quản lý lịch trình', index: 2),
          _buildDrawerItem(icon: Icons.train, title: 'Quản lý trạm', index: 3),
          _buildDrawerItem(icon: Icons.bar_chart, title: 'Thống kê', index: 4),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text('Cài đặt', style: TextStyle(color: Colors.white70)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white70),
            title: const Text('Trợ giúp & Hỗ trợ', style: TextStyle(color: Colors.white70)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: Color(0xFF13B8A8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 32, color: Color(0xFF13B8A8)),
          ),
          SizedBox(height: 12),
          Text(
            'Admin',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'admin@shipmanager.com',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required int index}) {
    final isSelected = _selectedMenuIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF13B8A8) : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF13B8A8) : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF13B8A8).withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedMenuIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }

  // Add the missing method for error view
  Widget _buildErrorView(String message) {
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
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Make sure to use the correct HomeEvent
              // context.read<HomeBloc>().add(LoadHomeData());
            },
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

  Widget _buildDashboard(HomeLoaded state) {
    switch (_selectedMenuIndex) {
      case 0:
        return _buildOverviewContent(state);
      case 1:
        return BlocProvider.value(
          value: context.read<ShipBloc>(),
          child: ShipManagementScreen(),
        );
      case 2:
        return ScheduleManagementScreen();
      case 3:
        return StationScreen();
      case 4:
        return _buildStatisticsContent(state);
      default:
        return _buildOverviewContent(state);
    }
  }

  // Add the missing method for overview content
  Widget _buildOverviewContent(HomeLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview header
          Text(
            'Tổng quan hệ thống',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Tổng số tàu',
                  value: state.trainCount.toString(),
                  icon: Icons.directions_boat,
                  color: Color(0xFF2196F3),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Lịch trình',
                  value: state.scheduleCount.toString(),
                  icon: Icons.schedule,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Số trạm',
                  value: state.stationCount.toString(),
                  icon: Icons.train,
                  color: Color(0xFFFF9800),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Tàu hoạt động',
                  value: '${state.trainCount > 0 ?
                  state.trains.where((t) => t['status'] == 'Đang hoạt động').length : 0}',
                  icon: Icons.speed,
                  color: Color(0xFF9C27B0),
                ),
              ),
            ],
          ),

          SizedBox(height: 32),

          // Recent schedules
          Text(
            'Lịch trình gần đây',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildRecentSchedules(state.schedules),

          SizedBox(height: 32),

          // Upcoming activities
          Text(
            'Sắp diễn ra',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildUpcomingActivities(),
        ],
      ),
    );
  }

  // Add the missing method for statistics content
  Widget _buildStatisticsContent(HomeLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Tính năng đang phát triển',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Thống kê và biểu đồ sẽ được cập nhật trong phiên bản sau',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Add the missing helper methods
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSchedules(List<Map<String, dynamic>> schedules) {
    if (schedules.isEmpty) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'Không có lịch trình nào',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }

    // Take only the first 3 schedules
    final recentSchedules = schedules.take(3).toList();

    return Column(
      children: recentSchedules.map((schedule) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getStatusColor(schedule['status']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_boat,
                  color: _getStatusColor(schedule['status']),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['trainType'] ?? 'Không xác định',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${schedule['departureStation']} → ${schedule['arrivalStation']}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(schedule['status']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatStatus(schedule['status']),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    schedule['departureTime'] ?? '',
                    style: TextStyle(
                      color: Color(0xFF13B8A8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingActivities() {
    // Demo data for upcoming activities
    final activities = [
      {
        'title': 'Bảo trì tàu Cao Tốc A',
        'time': '28/02/2025',
        'type': 'maintenance',
      },
      {
        'title': 'Thêm lịch trình mới',
        'time': '01/03/2025',
        'type': 'schedule',
      },
      {
        'title': 'Nâng cấp trạm Vũng Tàu',
        'time': '05/03/2025',
        'type': 'station',
      },
    ];

    return Column(
      children: activities.map((activity) {
        IconData icon;
        Color color;

        switch (activity['type']) {
          case 'maintenance':
            icon = Icons.build;
            color = Colors.orange;
            break;
          case 'schedule':
            icon = Icons.event;
            color = Colors.green;
            break;
          case 'station':
            icon = Icons.location_city;
            color = Colors.blue;
            break;
          default:
            icon = Icons.event_note;
            color = Colors.grey;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          activity['time'] ?? '',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Xử lý đăng xuất ở đây
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
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

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';

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