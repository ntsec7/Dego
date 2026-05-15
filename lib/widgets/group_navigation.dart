import 'package:flutter/material.dart';

class GroupNavigation extends StatelessWidget {

  final int currentIndex;

  const GroupNavigation({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index){

    if(index == currentIndex) return;  //para evitar recargas innecesarias

    switch(index){

      case 0:
        Navigator.pushReplacementNamed(context, 'groupHomePage');
        break;

      case 1:
        Navigator.pushReplacementNamed(context, 'groupHomePage');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, 'groupHomePage');
        break;

    }
  }


  Widget _navItem({
    required BuildContext context,
    required int index,
    required IconData icon,
  }) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    final bool selected = currentIndex == index;

    return Expanded(
      child: InkWell(

        onTap: () => _navigate(context, index),

        child: Container(

          height: web? screenHeight * 0.17 : screenHeight * 0.08,

          color: Color(0xFFD9D9D9),

          child: Center(

            child: Icon(
                    icon,
                    color: selected ? Colors.black : Colors.grey.shade600,
                    size: web ? (screenHeight + screenWidth) * 0.015 : (screenHeight + screenWidth) * 0.02,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600;

    return SizedBox(

      height: web ? screenHeight * 0.06 : screenHeight * 0.03,

      child: Row(
        children: [

          _navItem(
            context: context,
            index: 0,
            icon: Icons.home_rounded,
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 1,
            icon: Icons.groups,
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 2,
            icon: Icons.history_rounded,
          ),
        ],
      ),
    );
  }
}