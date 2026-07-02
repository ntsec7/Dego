import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_notifications_provider.dart'; 

class NavigationBottom extends ConsumerWidget {

  final int currentIndex;

  final ValueChanged<int> onTap;  //función callback para avisar al padre

  const NavigationBottom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _navigate(int index){  

    //if(index == currentIndex) return;  //para evitar recargas innecesarias

    onTap(index);
  }


  Widget _navItem({
    required BuildContext context,
    required int index,
    IconData? icon,
    String? imagePath,
    int badgeCount = 0,
  }) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    final bool selected = currentIndex == index;

    final Widget iconContent = imagePath != null
        ? Image.asset(
            imagePath,
            width: web ? (screenHeight + screenWidth) * 0.03 : (screenHeight + screenWidth) * 0.05,
            height: web ? (screenHeight + screenWidth) * 0.03 : (screenHeight + screenWidth) * 0.05,
          )
        : Icon(
            icon,
            color: Colors.black,
            size: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.03,
          );

    return Expanded(
      child: InkWell(
        onTap: () => _navigate(index),
        child: Container(
          height: web ? screenHeight * 0.17 : screenHeight * 0.08,
          color: selected ? const Color(0xFFBEBEBE) : const Color(0xFFD9D9D9),
          child: Center(
            // 3. Si tiene notificaciones, envolvemos el icono con Badge
            child: badgeCount > 0
                ? Badge(
                    label: Text('$badgeCount'),
                    backgroundColor: Theme.of(context).colorScheme.primary, // Color del circulito
                    textColor: Colors.white,
                    child: iconContent,
                  )
                : iconContent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    final notificationsAsync = ref.watch(currentNotificationsProvider);
    
    final totalNotifications = notificationsAsync.value?.length ?? 0;

    return SizedBox(

      height: web ? screenHeight * 0.07 : screenHeight * 0.06,

      child: Row(
        children: [

          _navItem(
            context: context,
            index: 0,
            imagePath: 'assets/images/IconoGrupo.png',
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 1,
            imagePath: 'assets/images/IconoIndividual.png',
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 2,
            icon: Icons.notifications,
            badgeCount: totalNotifications,
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 3,
            imagePath: 'assets/images/IconoPerfil.png',
          ),
        ],
      ),
    );
  }
}