import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';
import 'package:dego/providers/watch_decision_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/models/tmdb_info.dart';
import 'package:dego/utilities/lang.dart';

class WatchVote extends ConsumerWidget {
  final String id;

  const WatchVote({
    super.key,
    required this.id,
  });

  String FormatDate(String date){
    // Si es vacia o sin guiones, la devolvemos tal cual
    if (date.isEmpty || !date.contains('-')) {
      return date;
    }

    // Dividimos el string en una lista: ["2026", "05", "01"]
    final parts = date.split('-');

    // Si no tiene 3 partes(año,mes,dia), la devolvemos
    if (parts.length != 3) return date;

    // Invertimos el orden de las partes y las unimos con guiones: "01-05-2026"
    return parts.reversed.join('-');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final decisionAsync = ref.watch(watchDecisionByIdProvider(id));
    final state = ref.watch(watchDecisionSessionProvider(id));

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (decisionAsync.isLoading ) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    }

    final decision = decisionAsync.requireValue;

    // Si la lista esta vacia
    if (state.queue.isEmpty) {


      if (!state.isInitialLoaded) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      else{
         return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //TITULO DECISION Y BOTÓN DE ATRÁS
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                        horizontal: web ? screenWidth * 0.05 : screenWidth * 0.01,
                      ),
                    child: Row(
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
                              // fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? const Color.fromARGB(255, 167, 167, 167) : const Color.fromARGB(255, 74, 74, 74), 
                            ),
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    ),

                    // ERROR
                    SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                    child: Text(
                      context.lang.no_quedan_opciones,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   ),
                    ),
                  ],
                ),
              ),
            ),
          );
      }
    
    }

    final movie = state.currentMovie;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //TITULO DECISION Y BOTÓN DE ATRÁS
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: web ? screenHeight * 0.02 : screenHeight * 0.015,
                  horizontal: web ? screenWidth * 0.05 : screenWidth * 0.01,
                ),
              child: Row(
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
                        // fontSize: web ? (screenHeight + screenWidth) * 0.014 : (screenHeight + screenWidth) * 0.02,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? const Color.fromARGB(255, 167, 167, 167) : const Color.fromARGB(255, 74, 74, 74), 
                      ),
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 3,
                    ),
                  ),
                ],
              ),
              ),

              // TITULO
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // POSTER
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 350,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 350,
                      width: 233,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.movie, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // GENEROS
              _buildFilterContainer(
                context: context,
                title: context.lang.generos,
                child: Wrap(
                  spacing: 8.0, 
                  runSpacing: 4.0, 
                  children: ( () {
                    final genreList = movie.isMovie ? TMDBData.filmGenres(context) : TMDBData.serieGenres(context);
                    final genres = genreList.where((g) => movie.genreIds.contains(g.id)); //filtramos para quedarnos con los que contiene
                    return genres.map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary, // Formato "Selected" de tu diseño
                        borderRadius: BorderRadius.circular(20), // Aspecto Stadium/Óvalo
                      ),
                      child: Text(
                        genre.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList();
                  })(), //Los parentesis finales ejecutan la función anónima automáticamente
              ),
              ),

              // FECHA DE ESTRENO
              Row(
                children: [
                  Text(
                    "${context.lang.fecha_estreno}: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    FormatDate(movie.releaseDate),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // PUNTUACIÓN
              Row(
                children: [
                  Text(
                    "${context.lang.puntuacion}: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "${movie.voteAverage} (${movie.voteCount} votos)",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // SINOPSIS
              Text(
                "${context.lang.sinopsis}:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                movie.synopsis,
                style: TextStyle(
                  fontSize: 14, 
                  // color: Colors.grey.shade800, 
                  height: 1.4
                ),
              ),
              const SizedBox(height: 20),

              // VER MÁS +
              Center(
                child: TextButton(
                  onPressed: () {
                    // Acción para expandir o ir a detalles externos de TMDB
                  },
                  child: Text(
                    "${context.lang.ver_mas} +",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline, // Aspecto de enlace web
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.close,
                    color: const Color(0xFFCC2525),
                    onPressed: () {         

                      //SI YA HA ACABADO LO ECHA
                      if(decision.finish){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.lang.error_votacion_finalizada),
                            ),
                          );
                          Navigator.pop(context);
                      }

                      //Pasar a la siguiente
                      ref.read(watchDecisionSessionProvider(id).notifier).next();
                    },
                  ),
                  SizedBox(width: web ? screenWidth  * 0.3 : screenWidth * 0.15), // Separación entre círculos

                  // Botón aceptar (Corazón)
                  _buildCircleButton(
                    icon: Icons.favorite,
                    color: const Color(0xFF098238),
                    onPressed: () async{

                      //SI YA HA ACABADO LO ECHA
                      if(decision.finish){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.lang.error_votacion_finalizada),
                          ),
                        );
                        Navigator.pop(context);
                      }


                      //Votar
                      await ref.read(watchDecisionSessionProvider(id).notifier).watchVote();

                      //Pasar a la siguiente
                      ref.read(watchDecisionSessionProvider(id).notifier).next();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Tu contenedor personalizado adaptado para recibir el contexto por parámetro
  Widget _buildFilterContainer({required BuildContext context, required String title, required Widget child}) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool web = screenWidth > 600;    

    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
        Positioned(
          left: 12,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Theme.of(context).scaffoldBackgroundColor, 
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: web ? const Color.fromARGB(255, 179, 179, 179) : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget para generar los botones inferiores en un círculo pulcro
  Widget _buildCircleButton({required IconData icon, required Color color, required VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 32,
        padding: const EdgeInsets.all(16),
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}