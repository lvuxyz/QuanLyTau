import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ship/ship_bloc.dart';
import '../blocs/ship/ship_event.dart';
import '../blocs/ship/ship_state.dart';
import '../models/ship.dart';

class ShipManagementScreen extends StatefulWidget {
  const ShipManagementScreen({super.key});

  @override
  _ShipManagementScreenState createState() => _ShipManagementScreenState();
}

class _ShipManagementScreenState extends State<ShipManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<ShipBloc>().add(LoadShips());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocConsumer<ShipBloc, ShipState>(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditShipDialog(context),
        backgroundColor: const Color(0xFF13B8A8),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm tàu...',
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: const Icon(Icons.search, color: Colors.white60),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.white60),
            onPressed: () {
              _searchController.clear();
              context.read<ShipBloc>().add(LoadShips());
            },
          ),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<ShipBloc>().add(SearchShips(value));
          } else {
            context.read<ShipBloc>().add(LoadShips());
          }
        },
      ),
    );
  }

  void _showAddEditShipDialog(BuildContext context, {Ship? ship}) {
    final isEditing = ship != null;
    
    final nameController = TextEditingController(text: ship?.name ?? '');
    final typeController = TextEditingController(text: ship?.type ?? '');
    final capacityController = TextEditingController(text: ship?.capacity.toString() ?? '');
    final routeController = TextEditingController(text: ship?.route ?? '');
    final imageUrlController = TextEditingController(text: ship?.imageUrl ?? '');
    
    String status = ship?.status ?? 'Đang hoạt động';
    
    final statusOptions = [
      'Đang hoạt động',
      'Bảo trì',
      'Ngưng phục vụ',
    ];

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
            children: [
              _buildTextField(nameController, 'Tên tàu', Icons.directions_boat),
              _buildTextField(typeController, 'Loại tàu', Icons.category),
              _buildTextField(capacityController, 'Sức chứa', Icons.people, keyboardType: TextInputType.number),
              _buildTextField(routeController, 'Tuyến đường', Icons.route),
              _buildTextField(imageUrlController, 'URL hình ảnh', Icons.image),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: status,
                    dropdownColor: const Color(0xFF333333),
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        status = newValue;
                      }
                    },
                    items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || 
                  typeController.text.isEmpty || 
                  capacityController.text.isEmpty || 
                  routeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đầy đủ thông tin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final newShip = Ship(
                id: ship?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                type: typeController.text,
                capacity: int.tryParse(capacityController.text) ?? 0,
                status: status,
                route: routeController.text,
                imageUrl: imageUrlController.text.isEmpty ? null : imageUrlController.text,
                createdAt: ship?.createdAt,
                updatedAt: DateTime.now().toIso8601String(),
              );

              if (isEditing) {
                context.read<ShipBloc>().add(UpdateShip(ship!.id, newShip));
              } else {
                context.read<ShipBloc>().add(AddShip(newShip));
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
  
  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF333333),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ShipList extends StatelessWidget {
  final List<Ship> ships;

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
  final Ship ship;

  const _ShipCard({required this.ship});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF2A2A2A),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ship.imageUrl != null && ship.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                ship.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white60,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ship.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ship.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ship.status,
                        style: TextStyle(
                          color: _getStatusColor(ship.status),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ship.type,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      'Sức chứa: ${ship.capacity}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.route, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Tuyến: ${ship.route}',
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF13B8A8)),
                      onPressed: () {
                        (context as Element).findAncestorStateOfType<_ShipManagementScreenState>()!
                            ._showAddEditShipDialog(context, ship: ship);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteConfirmation(context, ship);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, Ship ship) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text(
          'Bạn có chắc chắn muốn xóa tàu "${ship.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ShipBloc>().add(DeleteShip(ship.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

Color _getStatusColor(String status) {
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
