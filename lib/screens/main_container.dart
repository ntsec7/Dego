import 'package:dego/screens/group_tab_manager.dart';
import 'package:dego/screens/notifications.dart';
import 'package:dego/screens/profile.dart';
import 'package:dego/screens/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:dego/widgets/navigation_bottom.dart';
import 'package:dego/widgets/navigation_bottom_admin.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/screens/individual_container.dart';



class AppMainContainer extends ConsumerStatefulWidget {
  const AppMainContainer({super.key});

  @override
  ConsumerState<AppMainContainer> createState() => _AppMainContainerState();
}

// 2. Cambiado a ConsumerState
class _AppMainContainerState extends ConsumerState<AppMainContainer> {
  int _mainIndex = 0;

  // Lista de las pantallas principales del Navbar global
  final List<Widget> _mainPagesAdmin = [
    const GroupTabManager(),
    const Userslist(),
    const Profile(),
    
  ];

  final List<Widget> _mainPagesClient = [
    const GroupTabManager(),
    const IndividualContainer(),
    const Notifications(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    
    final usuarioAsync = ref.watch(usuarioProvider);

    return Scaffold(
      body: SafeArea(
        child: usuarioAsync.when(
          data: (usuario) {
            if (usuario == null) {
              return Center(child: Text(context.lang.error_carga_usuario));
            }

            return Column(
              children: [
                // El cuerpo principal que cambia sin flash
                Expanded(
                  child: IndexedStack(
                    index: _mainIndex,
                    children: usuario.tipo == 'admin' 
                        ? _mainPagesAdmin 
                        : _mainPagesClient,
                  ),
                ),
                
                //NAVEGACIÓN INFERIOR
                if (usuario.tipo == 'admin')
                  NavigationBottomAdmin(
                    currentIndex: _mainIndex,
                    onTap: (index) {
                      ref.read(idCurrentGroupProvider.notifier).state = null;
                      setState(() {
                        _mainIndex = index;
                      });
                    },
                  )
                else
                  NavigationBottom(
                    currentIndex: _mainIndex,
                    onTap: (index) {
                      ref.read(idCurrentGroupProvider.notifier).state = null;
                      setState(() {
                        _mainIndex = index;
                      });
                    },
                  ),
              ],
            );
          },
          // Manejo de estados de carga y error del Provider
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}