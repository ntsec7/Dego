import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/utilities/lang.dart';

class GroupHomePage extends ConsumerStatefulWidget {

  const GroupHomePage({super.key});

  @override
  ConsumerState<GroupHomePage> createState() => _GroupHomePage();
}

class _GroupHomePage extends ConsumerState<GroupHomePage> {

@override
Widget build(BuildContext context) {

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  bool web = screenWidth > 600 ? true : false;

  final grupo = ref.watch(currentGroupProvider);

  if(grupo==null){
    return Scaffold(
        body: Center(child: Text(context.lang.error_carga_grupo)),
    );
  }

  return Scaffold(
    body: SafeArea(
      child: Column(
            children: [

              Align(
                alignment: AlignmentGeometry.center,
                child: IconButton(
                  icon: const Icon(Icons.add,
                  weight: 900.0,),
                  color: Color(0xFF098238),
                  iconSize: web ? screenWidth * 0.03 : screenWidth * 0.15,
                  onPressed: () async{
                    Navigator.pushNamed(context, 'createDecision');
                  },
                ),
              )

              

            ],
      ),
    ),
  );
}
}