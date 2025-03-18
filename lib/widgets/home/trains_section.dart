// lib/widgets/home/trains_section.dart
import 'package:flutter/material.dart';

class TrainsSection extends StatelessWidget {
  final List<Map<String, dynamic>> trains;
  final VoidCallback onViewAllPressed;

  const TrainsSection({
    Key? key,
    required this.trains,
    required this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tàu Đang Hoạt Động',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: onViewAllPressed,
              child: Row(
                children: [
                  Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Color(0xFF13B8A8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF13B8A8),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        trains.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: trains.length > 2 ? 2 : trains.length,
          itemBuilder: (context, index) {
            return _buildTrainCard(context, trains[index]);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 80,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Không có tàu nào đang hoạt động',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTrainCard(BuildContext context, Map<String, dynamic> train) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Xử lý sự kiện khi nhấn vào tàu
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getStatusColor(train['status']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_railway,
                    color: _getStatusColor(train['status']),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        train['name'] ?? 'Không xác định',
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
                        train['operator'] ?? 'Không có thông tin',
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
                    color: _getStatusColor(train['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatStatus(train['status']),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';

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