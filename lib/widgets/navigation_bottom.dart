import 'package:flutter/material.dart';

class NavigationBottom extends StatelessWidget {

  final int currentIndex;

  const NavigationBottom({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index){

    if(index == currentIndex) return;

    switch(index){

      case 0:
        Navigator.pushReplacementNamed(context, 'homePage');
        break;

      case 1:
        Navigator.pushReplacementNamed(context, 'homePage');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, 'homePage');
        break;

      case 3:
        Navigator.pushReplacementNamed(context, 'homePage');
        break;
    }
  }


  Widget _navItem({
    required BuildContext context,
    required int index,
    IconData? icon,
    String? imagePath,
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

          color: selected
              ? Color(0xFFBEBEBE)
              : Color(0xFFD9D9D9),

          child: Center(

            child: imagePath != null

                ? Image.asset(
                    imagePath,
                    width: web ? (screenHeight + screenWidth) * 0.03 : (screenHeight + screenWidth) * 0.05,
                    height: web ? (screenHeight + screenWidth) * 0.03 : (screenHeight + screenWidth) * 0.05,
                  )

                : Icon(
                    icon,
                    color: Colors.black,
                    size: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.04,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 70,

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