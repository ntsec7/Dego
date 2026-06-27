import 'package:flutter/material.dart';
import 'package:dego/utilities/lang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigateToTie extends ConsumerStatefulWidget {
  final String id;

  const NavigateToTie({super.key, required this.id});

  @override
  ConsumerState<NavigateToTie> createState() => _NavigateToTie();
}

class _NavigateToTie extends ConsumerState<NavigateToTie> {

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    
    final bool web = screenWidth > 600  ? true : false; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Hace el fondo invisible
        elevation: 0, // Quita la sombra para que parezca que no hay barra
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), 
          // color: Theme.of(context).colorScheme.primary, 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrado Vertical
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado Horizontal
            mainAxisSize: MainAxisSize.min, // Ajusta la columna al tamaño de sus hijos
            children: [
              
              // DECIDE EL CREADOR
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.primary, 
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'tiedCreator', arguments: widget.id);
                },
                child: Text(
                  context.lang.decide_creador,
                  style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: web 
                        ? (screenHeight + screenWidth) * 0.01 
                        : (screenHeight + screenWidth) * 0.014,
                  ),
                ),
              ),


              SizedBox(height: web ? screenHeight * 0.15 : screenHeight * 0.15), 
              

              // RULETA
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.primary, 
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                  minimumSize: const Size(250, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'tiedRoulette', arguments: widget.id);
                },
                child: Text(
                  context.lang.ruleta,
                  style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: web 
                        ? (screenHeight + screenWidth) * 0.01 
                        : (screenHeight + screenWidth) * 0.014,
                  ),
                ),
              ),

              // SizedBox(height: web ? screenHeight * 0.1 : screenHeight * 0.1), 

              // //VOTACIÓN ÚNICA
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Theme.of(context).colorScheme.secondary,
              //     foregroundColor: Theme.of(context).colorScheme.primary, 
              //     side: BorderSide(
              //       color: Theme.of(context).colorScheme.primary,
              //       width: 1.5,
              //     ),
              //     minimumSize: const Size(250, 50),
              //   ),
              //   onPressed: () {
              //     // Navigator.pushNamed(context, 'createDecisionWatch');
              //   },
              //   child: Text(
              //     context.lang.votacion_unica,
              //     style: TextStyle(
              //       // color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: web 
              //           ? (screenHeight + screenWidth) * 0.01 
              //           : (screenHeight + screenWidth) * 0.014,
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}