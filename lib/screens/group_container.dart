import 'package:dego/screens/group_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:dego/screens/group_members.dart';
import 'package:dego/screens/group_history.dart';
import 'package:dego/widgets/group_header.dart';
import 'package:dego/widgets/group_navigation.dart';


class GroupContainer extends ConsumerStatefulWidget {
  const GroupContainer({super.key});

  @override
  ConsumerState<GroupContainer> createState() => _GroupContainerState();
}

// 2. Cambiado a ConsumerState
class _GroupContainerState extends ConsumerState<GroupContainer> {
  int _mainIndex = 0;

  // Lista de las pantallas principales del Navbar global
  final List<Widget> _mainPages = [
    const GroupHomePage(),
    const GroupMembers(),
    const GroupHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    
    return  Column(
              children: [

                GroupHeader(),
                GroupNavigation(
                  currentIndex: _mainIndex,
                  onTap: (index) {
                    setState(() {
                      _mainIndex = index;
                    });
                  },
                ),
                

                // El cuerpo principal que cambia sin flash
                Expanded(
                  child: IndexedStack(
                    index: _mainIndex,
                    children: _mainPages,
                  ),
                ),

              ],
    );
  }
}