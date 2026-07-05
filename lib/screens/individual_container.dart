import 'package:dego/screens/individual_history.dart';
import 'package:dego/screens/individual_home_page.dart';
import 'package:dego/widgets/individual_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:dego/screens/group_history.dart';
import 'package:dego/utilities/lang.dart';


class IndividualContainer extends ConsumerStatefulWidget {
  const IndividualContainer({super.key});

  @override
  ConsumerState<IndividualContainer> createState() => _IndividualContainerState();
}

// 2. Cambiado a ConsumerState
class _IndividualContainerState extends ConsumerState<IndividualContainer> {
  int _mainIndex = 0;

  // Lista de las pantallas principales del Navbar global
  final List<Widget> _mainPages = [
    const Individualhomepage(),
    const IndividualHistory(),
  ];

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return  Column(
              children: [

                SizedBox(height: 5),
                Padding(
                    padding:EdgeInsets.symmetric( horizontal: web ? screenWidth * 0.01 : screenWidth * 0.03 ,),
                  child: Align(
                        alignment: Alignment.centerLeft,    
                    child: Row(
                      children: [ 
                      Text(
                      context.lang.individual,
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) *0.01 : (screenHeight + screenWidth) *0.018,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline, 
                      )
                      ),
                      SizedBox(width: web ? screenWidth * 0.006 : screenWidth * 0.008),
                      if(isDarkMode) //imagen blanca
                        Image.asset( 
                          'assets/images/IconoIndividualBlanco.png',
                          width: web? screenWidth * 0.025 : screenWidth * 0.08,
                        )
                      else //Imagen oscura
                      Image.asset( 
                          'assets/images/IconoIndividual.png',
                          width: web? screenWidth * 0.025 : screenWidth * 0.08,
                        ),
                      
                      ],
                    ),
                  ),
                  ),

                  SizedBox(height: 5),

                IndividualNavigation(
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