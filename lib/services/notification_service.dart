import 'api_service.dart';

class NotificationService extends ApiService {
  Future<Map<String, dynamic>> getAllNotifications() async {
    return await get('notifications');
  }

  Future<Map<String, dynamic>> getNotificationById(String id) async {
    return await get('notifications/$id');
  }

  Future<Map<String, dynamic>> createNotification(Map<String, dynamic> notificationData) async {
    return await post('notifications', notificationData);
  }

  Future<Map<String, dynamic>> updateNotification(String id, Map<String, dynamic> notificationData) async {
    return await put('notifications/$id', notificationData);
  }

  Future<Map<String, dynamic>> deleteNotification(String id) async {
    return await delete('notifications/$id');
  }

  Future<Map<String, dynamic>> markAsRead(String id) async {
    return await put('notifications/$id/read', {});
  }

  Future<Map<String, dynamic>> getUnreadCount() async {
    return await get('notifications/unread/count');
  }
} 