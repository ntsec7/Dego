import 'package:dego/models/decision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:dego/models/option.dart';

class GroupHistoryDecision extends ConsumerStatefulWidget {
  final String id;

  const GroupHistoryDecision({super.key, required this.id});

  @override
  ConsumerState<GroupHistoryDecision> createState() => _GroupHistoryDecision();
}

class _GroupHistoryDecision extends ConsumerState<GroupHistoryDecision> {


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;

    final decisionAsync = ref.watch(decisionByIdProvider(widget.id));
    final optionsAsync = ref.watch(optionsByDecisionProvider(widget.id));

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final currentUserId = ref.watch(usuarioProvider).value?.id ?? '';


    if (decisionAsync.isLoading || optionsAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    }

    final decision = decisionAsync.requireValue;
    final options = optionsAsync.requireValue;

    final sortedOptions = List.from(options)..sort((a, b) {
      final votesA = a.num_votes ?? 0;
      final votesB = b.num_votes ?? 0;
      if(decision.type==DecisionType.ranking){
        return votesA.compareTo(votesB); // Ascendente
      }
      else{
        return votesB.compareTo(votesA); // Descendente
      }
      
    });

    int? winnerValue;

    if(sortedOptions.isNotEmpty){
      winnerValue = sortedOptions.first.num_votes ?? 0;  //el primero tiene el valor ganador
    } 

    List<String> winnersIds= [];

    if (winnerValue != null) {
      for (var option in sortedOptions) {
        final votes = option.num_votes ?? 0;
        if (votes == winnerValue) {
          winnersIds.add(option.id);
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
          child: Column(
            children: [

              // DAR PARA ATRÁS Y TÍTULO Y TIPO DE LA DECISIÓN
              Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                horizontal: web ? screenWidth * 0.14 : screenWidth * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Expanded(
                    child: Text(
                      decision.title,
                      style: TextStyle(
                        fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              //TIPO
              Text(
                decision.type.title(context),
                style: TextStyle(
                  // fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? const Color.fromARGB(255, 167, 167, 167) : const Color.fromARGB(255, 74, 74, 74), 
                ),
              ),
              ],
              ),
            ),

              // BLOQUE DE OPCIONES (Se expande para ocupar el espacio restante)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(
                    web
                        ? (screenHeight + screenWidth) * 0.01
                        : (screenHeight + screenWidth) * 0.01,
                  ),
                  children: [
                  ...List.generate(sortedOptions.length, (index) {
                    final option = sortedOptions[index];

                    return GestureDetector(
                      onTap: () {
                        if(option.type==OptionType.standard){
                          Navigator.pushNamed(context, 'seeOption', arguments: option.id);
                        }else{
                          Navigator.pushNamed(context, 'seeMediaOption', arguments: {
                            'id': decision.id,
                            'optionId': option.id,
                          },);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                        padding: EdgeInsets.only(
                          left: web
                              ? (screenHeight + screenWidth) * 0.01
                              : (screenHeight + screenWidth) * 0.015,
                          // Reducimos el padding derecho un poco para que el IconButton no quede muy lejos del borde
                          right: web ? 4.0 : 8.0, 
                        ),
                        constraints: BoxConstraints(
                          minHeight: web ? screenHeight * 0.05 : 50.0,
                        ),
                        decoration: BoxDecoration(
                          color:  const Color.fromARGB(255, 224, 224, 224),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [

                            //POSICIÓN(si es ranking)
                            if(decision.type == DecisionType.ranking) ...[
                            Text(
                              "${index+1}º",
                              style: TextStyle(
                                fontSize: web
                                    ? (screenHeight + screenWidth) * 0.007
                                    : (screenHeight + screenWidth) * 0.013,
                                fontWeight: FontWeight.bold,
                                color:Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ],

                            Expanded(
                              child: Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: web
                                      ? (screenHeight + screenWidth) * 0.007
                                      : (screenHeight + screenWidth) * 0.013,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            
                            // NÚMERO DE VOTOS (si es ruleta o ranking no se muestra)
                            if(decision.type != DecisionType.roulette && decision.type != DecisionType.ranking)
                            Text(
                              '${option.num_votes ?? 0}',
                              style: TextStyle(
                                fontSize: web
                                    ? (screenHeight + screenWidth) * 0.007
                                    : (screenHeight + screenWidth) * 0.013,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(width: 5),

                            //ICONO DE LOS GANADORES
                            if(option.num_votes == winnerValue)
                              winnersIds.length == 1
                                ? const Icon( //Ganador
                                    Icons.emoji_events, // trofeo
                                    color: Color(0xFFFFD700), 
                                  )
                                : const Icon( //Empate
                                    Icons.balance,
                                    color: Color.fromARGB(255, 134, 134, 134), 
                                  )
                            else
                              const Icon(
                                Icons.emoji_events, 
                                color: Colors.transparent, // Ocupa espacio pero no se ve
                              ),
                            
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

              //BOTÓN DE DESEMPATE
              if(winnersIds.length>1 && decision.id_creator==currentUserId)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra el botón horizontalmente
                  mainAxisSize: MainAxisSize.min, // Hace que la fila solo ocupe el espacio de sus hijos
                  children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    // foregroundColor: Theme.of(context).colorScheme.primary, 
                    side: BorderSide( //Borde
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'navigateToTie', arguments: decision.id);
                  },
                  child: Text(context.lang.desempatar,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                        ),),
                ),
                  ],
                ),
              ),
        
            ],
          ),
        ),
            ],
      ),
        ),
      ),
    );
  }
}