import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc({
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final result = await _notificationService.getAllNotifications();
      if (result['success'] == true) {
        emit(NotificationLoaded(notifications: result['data']));
      } else {
        emit(NotificationError(message: result['message']));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await _notificationService.markAsRead(event.notificationId);
      if (result['success'] == true) {
        add(LoadNotifications());
      } else {
        emit(NotificationError(message: result['message']));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await _notificationService.deleteNotification(event.notificationId);
      if (result['success'] == true) {
        add(LoadNotifications());
      } else {
        emit(NotificationError(message: result['message']));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
} 