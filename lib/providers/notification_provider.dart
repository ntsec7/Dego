import 'package:dego/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dego/models/notification.dart';

final notificationServiceProvider = Provider<NotificationService>((ref){
  return NotificationService();
});

final createProvider = StateNotifierProvider<CreateNotification?>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final supabase = Supabase.instance.client;

  return NotificationNotifier(notificationService, supabase);
});

class NotificationNotifier extends StateNotifier<NotificationModel?> {
  final NotificationService notificationService;
  final SupabaseClient supabase;

  NotificationNotifier(this.notificationService, this.supabase)
      : super(supabase.auth.currentUser) {
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
  }

  Future<NotificationModel> createNotification(NotificationModel noti) async{
    try{
      return await notificationService.createNotification(noti);
    } catch (e){
      rethrow;
    }
  }


}