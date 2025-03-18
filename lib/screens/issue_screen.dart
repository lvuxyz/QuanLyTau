import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/issue/issue_bloc.dart';
import '../blocs/issue/issue_event.dart';
import '../blocs/issue/issue_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sự cố'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateIssueDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<IssueBloc, IssueState>(
        builder: (context, state) {
          if (state is IssueInitial) {
            context.read<IssueBloc>().add(LoadIssues());
            return const LoadingIndicator();
          }

          if (state is IssueLoading) {
            return const LoadingIndicator();
          }

          if (state is IssueError) {
            return ErrorMessage(message: state.message);
          }

          if (state is IssueLoaded) {
            if (state.issues.isEmpty) {
              return const Center(
                child: Text('Không có sự cố nào'),
              );
            }

            return ListView.builder(
              itemCount: state.issues.length,
              itemBuilder: (context, index) {
                final issue = state.issues[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(issue['title'] ?? 'Không có tiêu đề'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(issue['description'] ?? 'Không có mô tả'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(issue['status']),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                issue['status'] ?? 'Không có trạng thái',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              issue['created_at'] ?? 'Không có thời gian',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Chỉnh sửa'),
                          onTap: () => _showUpdateIssueDialog(context, issue),
                        ),
                        if (issue['status'] != 'resolved')
                          PopupMenuItem(
                            child: const Text('Giải quyết'),
                            onTap: () => _showResolveIssueDialog(context, issue),
                          ),
                        PopupMenuItem(
                          child: const Text('Xóa'),
                          onTap: () => _confirmDeleteIssue(context, issue),
                        ),
                      ],
                    ),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showCreateIssueDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo sự cố mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
              ),
              maxLines: 3,
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
              if (titleController.text.isNotEmpty) {
                context.read<IssueBloc>().add(
                      CreateIssue(
                        issueData: {
                          'title': titleController.text,
                          'description': descriptionController.text,
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

  void _showUpdateIssueDialog(BuildContext context, Map<String, dynamic> issue) {
    final titleController = TextEditingController(text: issue['title']);
    final descriptionController = TextEditingController(text: issue['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật sự cố'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
              ),
              maxLines: 3,
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
              if (titleController.text.isNotEmpty) {
                context.read<IssueBloc>().add(
                      UpdateIssue(
                        issueId: issue['id'],
                        issueData: {
                          'title': titleController.text,
                          'description': descriptionController.text,
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

  void _showResolveIssueDialog(BuildContext context, Map<String, dynamic> issue) {
    final resolutionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giải quyết sự cố'),
        content: TextField(
          controller: resolutionController,
          decoration: const InputDecoration(
            labelText: 'Giải pháp',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (resolutionController.text.isNotEmpty) {
                context.read<IssueBloc>().add(
                      ResolveIssue(
                        issueId: issue['id'],
                        resolutionData: {
                          'resolution': resolutionController.text,
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Giải quyết'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteIssue(BuildContext context, Map<String, dynamic> issue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa sự cố này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<IssueBloc>().add(
                    DeleteIssue(issueId: issue['id']),
                  );
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
} 