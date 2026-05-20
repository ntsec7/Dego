import 'package:dego/providers/current_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/widgets/notification_card.dart';

class Notifications extends ConsumerStatefulWidget {

  const Notifications({super.key});

  @override
  ConsumerState<Notifications> createState() => _Notifications();
}

class _Notifications extends ConsumerState<Notifications> {

@override
Widget build(BuildContext context) {

  final notificationsState = ref.watch(currentNotificationsProvider);

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;  //Para ver si el tema es claro u oscuro

  return Scaffold(
    body: SafeArea(
      child: Column(
            children: [
                Padding(
                  padding:EdgeInsets.symmetric( 
                    vertical: web? screenHeight * 0.03 : screenHeight * 0.02,
                    horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 
                  ),
                child: Align(
                      alignment: Alignment.centerLeft,    
                  child: Row(
                    children: [ 
                    Text(
                    context.lang.notificaciones,
                    style: TextStyle(
                      fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline, 
                    )
                    ),
                    SizedBox(width: web ? screenWidth * 0.006 : screenWidth * 0.02),
                    Icon(
                      Icons.notifications, 
                      color: isDarkMode ? Colors.white : Colors.black, 
                      size: web ? screenWidth * 0.017 : screenWidth * 0.06, 
                    )                    
                    ],
                  ),
                ),
                ),

              Expanded( // Esto hace que la lista use todo el espacio central
              child: notificationsState.when(
                data: (notification) {
                  if (notification.isEmpty) return const Center(child: Text(""));
                
                  return ListView.builder(
                    itemCount: notification.length,
                    itemBuilder: (context, index) {
                      final noti = notification[index];
                      
                      // Llamas a tu widget especializado y le pasas el modelo
                      return NotificationCard(notification: noti);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("Error: $e")),
              ),
            ),

            ],
    ),
    ),
  );
}
}