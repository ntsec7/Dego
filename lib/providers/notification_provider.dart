import 'package:dego/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/notification.dart';

final notificationServiceProvider = Provider<NotificationService>((ref){
  return NotificationService();
});

final NotificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(notificationService);
});

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationService notificationService;

  NotificationNotifier(this.notificationService) : super(const AsyncValue.data(null));


  Future<void> createNotification(NotificationModel noti) async{
    try{
      await notificationService.createNotification(noti);
    } catch (e){
      rethrow;
    }
  }


}