import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/notification/notification_event.dart';
import '../blocs/notification/notification_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial) {
            context.read<NotificationBloc>().add(LoadNotifications());
            return const LoadingIndicator();
          }

          if (state is NotificationLoading) {
            return const LoadingIndicator();
          }

          if (state is NotificationError) {
            return ErrorMessage(message: state.message);
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('Không có thông báo nào'),
              );
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Dismissible(
                  key: Key(notification['id']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<NotificationBloc>().add(
                          DeleteNotification(
                            notificationId: notification['id'],
                          ),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã xóa thông báo'),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(
                        notification['title'] ?? 'Không có tiêu đề',
                        style: TextStyle(
                          fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['message'] ?? 'Không có nội dung'),
                          const SizedBox(height: 4),
                          Text(
                            notification['created_at'] ?? 'Không có thời gian',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (!notification['read']) {
                          context.read<NotificationBloc>().add(
                                MarkNotificationAsRead(
                                  notificationId: notification['id'],
                                ),
                              );
                        }
                      },
                      trailing: !notification['read']
                          ? Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
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
} 