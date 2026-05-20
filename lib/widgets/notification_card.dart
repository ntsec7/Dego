import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/notification.dart';
import 'package:dego/utilities/lang.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationDisplayModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    final marginVertical = web ? screenHeight * 0.007 : 0.0;
    final marginHorizontal= web ? screenWidth * 0.03 : screenWidth * 0.05;
    final fontSize = web ? 18.0 : 15.0;

    return Stack(
      children: [

        //Cuerpo principal de la notificación (Rectángulo gris)
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            vertical: marginVertical, 
            horizontal: marginHorizontal,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 224, 224, 224),  
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Mensaje dinámico según el tipo
              Padding(padding: EdgeInsets.only(
                right: web ? screenWidth * 0.01 : screenWidth * 0.03,) ,
                child : _buildNotificationMessage(context, fontSize),
              ),
              
              
              //Si es una invitación de grupo, añadimos los botones abajo
              if (notification.baseNotification.type == NotificationType.invite_group) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Botón Rechazar 
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Lógica para aceptar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 228, 59, 59),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: EdgeInsets.symmetric(
                          horizontal: web ? screenWidth * 0.03 : 24, 
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        context.lang.rechazar,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    SizedBox(width: web ? screenWidth * 0.1 : screenWidth * 0.1),

                    // Botón Aceptar
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Lógica para aceptar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 17, 151, 69),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: EdgeInsets.symmetric(
                          horizontal: web ? screenWidth * 0.03 : 24, 
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        context.lang.aceptar,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // X en la esquina superior derecha
        Positioned(
          top: marginVertical + 12,
          right: marginHorizontal + 12,
          child: GestureDetector(
            onTap: () {
              // TODO: Lógica para borrar/descartar la notificación
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  // Método auxiliar para pintar un mensaje u otro según el tipo
  Widget _buildNotificationMessage(BuildContext context, fontSize) {
    switch (notification.baseNotification.type) {
      case NotificationType.invite_group:
        return Text(
          context.lang.noti_invite_group(notification.creatorUsername, notification.groupName), 
          style: TextStyle(fontSize: fontSize, color: Colors.black),
        );
      case NotificationType.kick_group:
        return Text(
          context.lang.noti_kick_group(notification.creatorUsername, notification.groupName),
          style: TextStyle(fontSize: fontSize, color: Colors.black),
        );
      case NotificationType.create_group:
        return const Text("¡Se ha creado un nuevo grupo!");
      case NotificationType.end_vote:
        return const Text("Una votación ha terminado.");
      case NotificationType.create_option:
        return const Text("Se ha añadido una nueva opción.");
    }
  }
}