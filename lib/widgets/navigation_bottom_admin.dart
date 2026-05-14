import 'package:flutter/material.dart';

class NavigationBottomAdmin extends StatelessWidget {

  final int currentIndex;

  const NavigationBottomAdmin({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index){

    if(index == currentIndex) return;  //para evitar recargas innecesarias

    switch(index){

      case 0:
        Navigator.pushReplacementNamed(context, 'homePage');
        break;

      case 1:
        Navigator.pushReplacementNamed(context, 'usersList');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, 'profile');
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
                    size: web ? (screenHeight + screenWidth) * 0.02 : (screenHeight + screenWidth) * 0.03,
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
            imagePath: 'assets/images/IconoListaUsuarios.png',
          ),

          Container(
            width: 1,
            color: Colors.grey.shade700,
          ),

          _navItem(
            context: context,
            index: 2,
            imagePath: 'assets/images/IconoPerfil.png',
          ),
        ],
      ),
    );
  }
}