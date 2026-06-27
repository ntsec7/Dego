import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/usuario_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dego/models/decision.dart';

class TiedRoulette extends ConsumerStatefulWidget {
  final String id;

  const TiedRoulette({super.key, required this.id});

  @override
  ConsumerState<TiedRoulette> createState() => _TiedRoulette();
}

class _TiedRoulette extends ConsumerState<TiedRoulette> with SingleTickerProviderStateMixin {
  bool _loading = false;
  String? _selectedOptionId;
  String? _winnerTitle;

  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // controladores de confetti y audio
  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;

  final List<Color> _wheelColors = [];
  double _currentAngle = 0.0;

  bool hasAlreadyVote=false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Inicializar confetti (duración de la explosión: 2 segundos)
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    
    // Inicializar reproductor de audio
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

//Inicializar colores de forma aleatoria
  void _initializeColors(int count) {
    if (_wheelColors.length == count) return;
    
    final List<Color> colors = [
      Colors.red[600]!,       
      Colors.blue[600]!,      
      Colors.green[600]!,     
      Colors.orange[600]!,    
      Colors.purple[600]!,       
      Colors.teal[600]!,       
      Colors.indigo[600]!,    
      Colors.pink[600]!,  
      Colors.yellow,
      Colors.brown,
      Colors.greenAccent,
      Colors.cyanAccent,
      Colors.pink[200]!,
    ];

    final random = Random();
    
    // Clonamos la lista para poder ir gastando los colores sin romper la original
    List<Color> colors2 = List.from(colors);

    for (int i = 0; i < count; i++) {
      // Si nos quedamos sin colores en la piscina, la volvemos a rellenar
      if (colors2.isEmpty) {
        colors2 = List.from(colors);
      }

      // Elegimos un índice al azar de los colores disponibles
      int randomIndex = random.nextInt(colors2.length);
      Color choosenColor = colors2[randomIndex];

      // Para que no se repita si el color elegido es igual al del quesito anterior y hay más opciones, buscamos otro
      if (i > 0 && _wheelColors.last == choosenColor && colors2.length > 1) {
        randomIndex = (randomIndex + 1) % colors2.length;
        choosenColor = colors2[randomIndex];
      }

      // Añadimos el color a la ruleta y lo sacamos de la piscina temporal
      _wheelColors.add(choosenColor);
      colors2.removeAt(randomIndex);
    }
  }

//Girar la ruleta
  void _spinRoulette(List<dynamic> options, String decisionId, String currentUserId) async {
    if (_animationController.isAnimating ) return;

    setState(() {
      _winnerTitle = null;
      _selectedOptionId = null;
    });

    // Reproducir sonido al empezar a girar
    try {
      await _audioPlayer.stop(); // Por si acaso quedó reproduciéndose antes
      await _audioPlayer.play(AssetSource('sounds/roulette.mp3'));
    } catch (e) {
      debugPrint("Error al reproducir sonido: $e");
    }

    final random = Random();
    final winnerIndex = random.nextInt(options.length); //ganador
    final targetOption = options[winnerIndex];

    double sectorArc = (2 * pi) / options.length; //cuanto mide cada quesito
    double winnerAngle = (winnerIndex * sectorArc) + (sectorArc / 2); //ángulo del ganador
    double rouletteAngleTarget = (3 * pi / 2) - winnerAngle;  //ángulo hasta el ganador
    double totalRotation = rouletteAngleTarget + (2 * pi * (4 + random.nextInt(3))); //ángulo del ganador más varias vueltas

    _animation = Tween<double>( //empieza rápido, acaba lento
      begin: _currentAngle % (2 * pi),
      end: totalRotation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _animationController.forward(from: 0.0).then((_)  async {
      setState(() {
        _currentAngle = totalRotation;
        _selectedOptionId = targetOption.id;
        _winnerTitle = targetOption.title;
        _loading = false;
      });
      
      // Confetti
      _confettiController.play();

      //Guardamos el voto en la bd
      await ref.read(createProvider.notifier).createSimpleVote(id_option: _selectedOptionId!, id_decision: decisionId, id_user: currentUserId, tied:true);

      //guardamos que ya ha votado
      hasAlreadyVote = true;

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600;

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;

    final decisionAsync = ref.watch(decisionByIdProvider(widget.id));
    final optionsAsync = ref.watch(optionsByDecisionProvider(widget.id));
    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;

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

    final tiedOptions = sortedOptions.where((option) => (option.num_votes ?? 0) == winnerValue).toList();

    _initializeColors(tiedOptions.length);

    final double rouletteSize = web ? screenHeight * 0.4 : screenWidth * 0.75;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
          child: Column(
            children: [

          //Título
          Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                horizontal: web ? screenWidth * 0.14 : screenWidth * 0.03,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {
                      Navigator.pop(context),
                      Navigator.pop(context),
                    }
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
                    ),
                  ),
                ],
              ),
            ),

              const Spacer(),

              // CONTENEDOR VISUAL DE LA RULETA E INDICADOR
              Stack(
                alignment: Alignment.center,
                children: [
                  // La ruleta que gira mediante la animación
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      double angle = _animationController.isAnimating ? _animation.value : _currentAngle;
                      return Transform.rotate(
                        angle: angle,
                        child: SizedBox(
                          width: rouletteSize,
                          height: rouletteSize,
                          child: CustomPaint(
                            painter: RoulettePainter(
                              options: tiedOptions,
                              colors: _wheelColors,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Marcador/Flecha superior fija
                  Positioned(
                    top: -10,
                    child: const Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),

                  // Eje central decorativo de la ruleta
                  Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(51, 0, 0, 0),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                  ),

                  // Widget de confetti
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive, // Explota en 360 grados
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                      Colors.yellow
                    ], 
                    numberOfParticles: 30, // Cantidad de papeles por ráfaga
                    gravity: 0.3, // Velocidad de caída
                  ),
                ],
              ),

              // Informar del resultado
              if (_winnerTitle != null) ...[
                const Spacer(),
                Text(
                  context.lang.ganador,
                  style: TextStyle(fontSize: web ? 14 : 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  _winnerTitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: web ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],



              const Spacer(),

              //Botón de girar
              ElevatedButton.icon(
                onPressed: _animationController.isAnimating || _loading ? null : () async {
                  
                  // Solo puede girar si es el creador
                  if (decision.id_creator != currentUserId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.lang.error_ruleta_girar)),
                    );
                    return;
                  }

                  setState(() => _loading = true); 

                  try {

                    //Ver si ya ha votado

                    // final hasAlreadyVote = await ref.read(createProvider.notifier).hasAlreadyVote(
                    //   id_decision: decision.id,
                    //   id_user: currentUserId!,
                    // );

                    if (hasAlreadyVote) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.lang.error_ya_votado)),
                      );
                      setState(() => _loading = false);
                      return;
                    }

                    // Gira la ruleta
                    _spinRoulette(tiedOptions, decision.id, currentUserId!);

                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateSupabaseError(context, e))),
                    );
                    setState(() => _loading = false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.primary, 
                  side: BorderSide( //Borde
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                icon: const Icon(Icons.autorenew),
                label: Text(context.lang.girar,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.014,
                  ),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

//PAINTER DE LA RULETA
class RoulettePainter extends CustomPainter {
  final List<dynamic> options;
  final List<Color> colors;

  RoulettePainter({required this.options, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double arcAngle = (2 * pi) / options.length;  //tamaño de cada quesito

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true; //Suavizado para que los bordes no se vean pixelados

    for (int i = 0; i < options.length; i++) {
      paint.color = colors[i];
      double startAngle = i * arcAngle;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        true,
        paint,
      );

      canvas.save();
      canvas.translate(center.dx, center.dy); //Mueve el origen del lienzo (0,0) de la esquina superior izquierda al centro de la ruleta.
      canvas.rotate(startAngle + (arcAngle / 2)); //Rota el lienzo completo hasta el ángulo central de este quesito

      final textPainter = TextPainter(
        text: TextSpan(
          text: options[i].title.length > 12 ? "${options[i].title.substring(0, 10)}..." : options[i].title,  //corta texto de más de 12 caracteres
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        textDirection: TextDirection.ltr, //el texto va de izq a der
        textAlign: TextAlign.center,
      )..layout(maxWidth: radius * 0.7);  //Que el texto ocupe como mucho el 70% del radio del quesito

      textPainter.paint(canvas, Offset(radius * 0.3, -textPainter.height / 2)); //pinta el texto, el offset es para que no empiece justo en el medio
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant RoulettePainter oldDelegate) =>  //para que no repinte la ruleta si no cambian opciones o colores
      oldDelegate.options != options || oldDelegate.colors != colors;
}