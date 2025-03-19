// lib/widgets/home/stations_section.dart
import 'package:flutter/material.dart';

class StationsSection extends StatelessWidget {
  final List<Map<String, dynamic>> stations;
  final VoidCallback onViewAllPressed;

  const StationsSection({
    Key? key,
    required this.stations,
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
              'Ga Tàu',
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
        stations.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stations.length > 2 ? 2 : stations.length,
          itemBuilder: (context, index) {
            return _buildStationCard(context, stations[index]);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Không tìm thấy thông tin ga',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, Map<String, dynamic> station) {
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
            // Xử lý sự kiện khi nhấn vào ga
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
                        station['name'] ?? 'Không có tên',
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
                        station['location'] ?? 'Không có địa chỉ',
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
                        '${station['numberOfLines'] ?? 0} tuyến',
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
          ),
        ),
      ),
    );
  }
}