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
  final groupInfoNotifier = ref.read(groupInfoProvider.notifier); // Descomenta cuando uses el de grupos

  // Mapeamos cada notificación ordinaria y disparamos las peticiones asíncronas en paralelo
  final futures = rawNotifications.map((noti) async {

    final username = await authNotifier.getUserUsername(noti.id_creator_user ?? '') ?? '';
    
    final groupName = await groupInfoNotifier.getGroupName(noti.id_group ?? '') ?? '';

    return NotificationDisplayModel(
      baseNotification: noti,
      creatorUsername: username,
      groupName: groupName,
    );
  });

  // 3. Esperamos a que TODAS las peticiones terminen a la vez en segundo plano
  return await Future.wait(futures);
});