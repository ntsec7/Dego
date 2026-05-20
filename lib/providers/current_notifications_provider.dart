import 'package:dego/models/notification.dart';
import 'package:dego/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/notification_provider.dart';

final currentNotificationsProvider = StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final authUser = ref.watch(authProvider);

  if (authUser == null) {
    return Stream.value([]);
  }

  final notificationService = ref.watch(notificationServiceProvider);
  return notificationService.getNotifications();
});