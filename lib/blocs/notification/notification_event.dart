abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsRead({required this.notificationId});
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  DeleteNotification({required this.notificationId});
} 