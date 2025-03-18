import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/seat_config/seat_config_bloc.dart';
import '../blocs/seat_config/seat_config_event.dart';
import '../blocs/seat_config/seat_config_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class SeatConfigScreen extends StatelessWidget {
  final String? trainId;

  const SeatConfigScreen({Key? key, this.trainId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trainId != null ? 'Cấu hình ghế tàu' : 'Quản lý cấu hình ghế'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateConfigDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<SeatConfigBloc, SeatConfigState>(
        builder: (context, state) {
          if (state is SeatConfigInitial) {
            if (trainId != null) {
              context.read<SeatConfigBloc>().add(LoadTrainSeatConfig(trainId: trainId!));
            } else {
              context.read<SeatConfigBloc>().add(LoadSeatConfigs());
            }
            return const LoadingIndicator();
          }

          if (state is SeatConfigLoading) {
            return const LoadingIndicator();
          }

          if (state is SeatConfigError) {
            return ErrorMessage(message: state.message);
          }

          if (state is SeatConfigLoaded) {
            if (state.seatConfigs.isEmpty) {
              return const Center(
                child: Text('Không có cấu hình ghế nào'),
              );
            }

            return ListView.builder(
              itemCount: state.seatConfigs.length,
              itemBuilder: (context, index) {
                final config = state.seatConfigs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text('Tàu: ${config['train_name'] ?? 'Không có tên'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Số ghế: ${config['total_seats'] ?? 0}'),
                        Text('Số hàng: ${config['rows'] ?? 0}'),
                        Text('Số cột: ${config['columns'] ?? 0}'),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Chỉnh sửa'),
                          onTap: () => _showUpdateConfigDialog(context, config),
                        ),
                        PopupMenuItem(
                          child: const Text('Xóa'),
                          onTap: () => _confirmDeleteConfig(context, config),
                        ),
                      ],
                    ),
                    onTap: () => _showConfigDetails(context, config),
                  ),
                );
              },
            );
          }

          return const LoadingIndicator();
        },
      ),
    );
  }

  void _showCreateConfigDialog(BuildContext context) {
    final trainNameController = TextEditingController();
    final rowsController = TextEditingController();
    final columnsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo cấu hình ghế mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trainNameController,
              decoration: const InputDecoration(
                labelText: 'Tên tàu',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rowsController,
              decoration: const InputDecoration(
                labelText: 'Số hàng',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: columnsController,
              decoration: const InputDecoration(
                labelText: 'Số cột',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (trainNameController.text.isNotEmpty &&
                  rowsController.text.isNotEmpty &&
                  columnsController.text.isNotEmpty) {
                context.read<SeatConfigBloc>().add(
                      CreateSeatConfig(
                        configData: {
                          'train_name': trainNameController.text,
                          'rows': int.parse(rowsController.text),
                          'columns': int.parse(columnsController.text),
                          if (trainId != null) 'train_id': trainId,
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showUpdateConfigDialog(BuildContext context, Map<String, dynamic> config) {
    final trainNameController = TextEditingController(text: config['train_name']);
    final rowsController = TextEditingController(text: config['rows'].toString());
    final columnsController = TextEditingController(text: config['columns'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật cấu hình ghế'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trainNameController,
              decoration: const InputDecoration(
                labelText: 'Tên tàu',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rowsController,
              decoration: const InputDecoration(
                labelText: 'Số hàng',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: columnsController,
              decoration: const InputDecoration(
                labelText: 'Số cột',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (trainNameController.text.isNotEmpty &&
                  rowsController.text.isNotEmpty &&
                  columnsController.text.isNotEmpty) {
                context.read<SeatConfigBloc>().add(
                      UpdateSeatConfig(
                        configId: config['id'],
                        configData: {
                          'train_name': trainNameController.text,
                          'rows': int.parse(rowsController.text),
                          'columns': int.parse(columnsController.text),
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteConfig(BuildContext context, Map<String, dynamic> config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa cấu hình ghế này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<SeatConfigBloc>().add(
                    DeleteSeatConfig(configId: config['id']),
                  );
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showConfigDetails(BuildContext context, Map<String, dynamic> config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết cấu hình: ${config['train_name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Số ghế: ${config['total_seats']}'),
            Text('Số hàng: ${config['rows']}'),
            Text('Số cột: ${config['columns']}'),
            const SizedBox(height: 16),
            const Text('Sơ đồ ghế:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: config['columns'],
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: config['rows'] * config['columns'],
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
} 