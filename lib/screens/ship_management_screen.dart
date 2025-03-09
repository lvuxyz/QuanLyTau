import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/ship/ship_bloc.dart';
import '../blocs/ship/ship_event.dart';
import '../blocs/ship/ship_state.dart';

class ShipManagementScreen extends StatefulWidget {
  const ShipManagementScreen({super.key});

  @override
  _ShipManagementScreenState createState() => _ShipManagementScreenState();
}

class _ShipManagementScreenState extends State<ShipManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShipBloc>().add(LoadShips());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Quản lý tàu'),
        elevation: 0,
      ),
      body: BlocConsumer<ShipBloc, ShipState>(
        listener: (context, state) {
          if (state is ShipOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ShipOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ShipLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
          } else if (state is ShipsLoaded) {
            return _ShipList(ships: state.ships);
          } else {
            return const Center(
              child: Text(
                'Không thể tải dữ liệu tàu',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditShipDialog(context),
        backgroundColor: const Color(0xFF13B8A8),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditShipDialog(BuildContext context, {Map<String, dynamic>? ship}) {
    final isEditing = ship != null;
    final controllers = {
      'name': TextEditingController(text: ship?['name'] ?? ''),
      'type': TextEditingController(text: ship?['type'] ?? ''),
      'capacity': TextEditingController(text: ship?['capacity']?.toString() ?? ''),
      'route': TextEditingController(text: ship?['route'] ?? ''),
      'imageUrl': TextEditingController(text: ship?['imageUrl'] ?? ''),
    };

    String status = ship?['status'] ?? 'Đang hoạt động';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          isEditing ? 'Chỉnh sửa tàu' : 'Thêm tàu mới',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: controllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _TextField(
                  controller: entry.value,
                  label: entry.key,
                  icon: Icons.directions_boat,
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controllers.values.any((c) => c.text.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final shipData = {
                'name': controllers['name']!.text,
                'type': controllers['type']!.text,
                'capacity': int.tryParse(controllers['capacity']!.text) ?? 0,
                'status': status,
                'route': controllers['route']!.text,
                'imageUrl': controllers['imageUrl']!.text,
              };

              if (isEditing) {
                context.read<ShipBloc>().add(UpdateShip(ship!['id'], shipData));
              } else {
                context.read<ShipBloc>().add(AddShip(shipData));
              }

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B8A8),
              foregroundColor: Colors.white,
            ),
            child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }
}

class _ShipList extends StatelessWidget {
  final List<Map<String, dynamic>> ships;

  const _ShipList({required this.ships});

  @override
  Widget build(BuildContext context) {
    if (ships.isEmpty) {
      return const Center(
        child: Text('Chưa có tàu nào', style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ships.length,
      itemBuilder: (context, index) {
        return _ShipCard(ship: ships[index]);
      },
    );
  }
}

class _ShipCard extends StatelessWidget {
  final Map<String, dynamic> ship;

  const _ShipCard({required this.ship});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A2A2A),
      child: ListTile(
        leading: Icon(Icons.directions_boat, color: _getStatusColor(ship['status'])),
        title: Text(ship['name'] ?? 'Tàu không tên', style: const TextStyle(color: Colors.white)),
        subtitle: Text(ship['route'] ?? 'Không có tuyến đường', style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () {},
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _TextField({required this.controller, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF333333),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'Đang hoạt động':
      return Colors.green;
    case 'Bảo trì':
      return Colors.orange;
    case 'Ngưng phục vụ':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
