import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/politics_type.dart';

class Politics extends ConsumerStatefulWidget {
  final PoliticsType type;

  const Politics({super.key, required this.type});

  @override
  ConsumerState<Politics> createState() => _PoliticsState();
}

class _PoliticsState extends ConsumerState<Politics> {

   @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    return Scaffold(
     body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: screenHeight * 0.02), 

          Padding(
            padding: EdgeInsets.symmetric(horizontal: web ? screenWidth * 0.3 : screenWidth * 0.1),
          child : Stack(
          alignment: Alignment.center,
          children: [

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
            ),

            //DEGO
            Text(
              widget.type.title(context),
            ),

          ],), ), 

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Center( 
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
  

          child : Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
            children: [

          SizedBox(height: screenHeight * 0.05),

          Text(widget.type.description(context)),

          SizedBox(height: screenHeight * 0.08),

          Image.asset(
            'assets/images/logo.png',
            // Si el 20% del ancho es mayor a 150px, usa el 0.07(para web)
            width: (screenWidth * 0.2) > 150 ? screenWidth * 0.07 : screenWidth * 0.2,
          ),

          SizedBox(height: screenHeight * 0.03),

            ],
            ),
          ),


      ),
      ),
                ),
              ),
            ),
          ],
     ),
     ),

    );
  }

}