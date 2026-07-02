import 'package:dego/providers/watch_decision_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:dego/providers/group_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/notification.dart';
import 'current_notifications_provider.dart'; 
import 'auth_provider.dart'; 
// import 'group_provider.dart'; // El service o provider donde busques el nombre del grupo

final enrichedNotificationsProvider = FutureProvider.autoDispose<List<NotificationDisplayModel>>((ref) async {

  final rawNotificationsAsync = ref.watch(currentNotificationsProvider);
  
  // Si el stream aún está cargando o no tiene datos, devolvemos lista vacía momentáneamente
  final rawNotifications = rawNotificationsAsync.value ?? [];
  if (rawNotifications.isEmpty) return [];

  final authNotifier = ref.read(authProvider.notifier);
  final groupInfoNotifier = ref.read(groupInfoProvider.notifier);

  // Mapeamos cada notificación ordinaria y disparamos las peticiones asíncronas en paralelo
  final futures = rawNotifications.map((noti) async {

    final username = await authNotifier.getUserUsername(noti.id_creator_user ?? '') ?? '';
    
    final groupName = await groupInfoNotifier.getGroupName(noti.id_group) ?? '';

    var decisionTitle = "";

    if(noti.id_decision!=null){
      if(noti.is_watch == true){
        try {
          final decision = await ref.read(watchDecisionByIdProvider(noti.id_decision!).future);
          decisionTitle = decision.title; 
        } catch (_) {
          decisionTitle = ""; 
        }
      } else{
        try {
          final decision = await ref.read(decisionByIdProvider(noti.id_decision!).future);
          decisionTitle = decision.title; 
        } catch (_) {
          decisionTitle = ""; 
        }
      }
    }

    return NotificationDisplayModel(
      baseNotification: noti,
      creatorUsername: username,
      groupName: groupName,
      decisionTitle: decisionTitle,
    );
  });

  // 3. Esperamos a que TODAS las peticiones terminen a la vez en segundo plano
  return await Future.wait(futures);
});