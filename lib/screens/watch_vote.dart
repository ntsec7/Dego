import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/providers/watch_decision_session_provider.dart';

class WatchVote extends ConsumerWidget {
  final String id;

  const WatchVote({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(watchDecisionSessionProvider(id));

    // Si la lista esta vacia
    if (state.queue.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final movie = state.currentMovie;

    // Mapear los IDs de los géneros que vienen en la película a nombres legibles
    // Nota: Adapta 'TMDBData.getGenreNamesFromIds' según cómo recuperes los strings en tu app
    List<String> genreNames = ["Aventura", "Animación", "Fantasía"]; // Ejemplo temporal

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 1. Fila superior: Flecha atrás y Nombre de la decisión
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Tu Decisión", // O el nombre dinámico que prefieras
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Fila: Título de la película/serie
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Fila: Imagen del póster (Centrada y con bordes redondeados)
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

              // 4. Fila: Géneros usando tu contenedor reutilizado personalizado
              _buildFilterContainer(
                context: context,
                title: "Géneros",
                child: Wrap(
                  spacing: 8.0, 
                  runSpacing: 4.0, 
                  children: genreNames.map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary, // Formato "Selected" de tu diseño
                        borderRadius: BorderRadius.circular(20), // Aspecto Stadium/Óvalo
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 5. Fila: Fecha de estreno
              Row(
                children: [
                  const Text(
                    "Fecha de estreno: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    movie.releaseDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 6. Fila: Puntuación (votos)
              Row(
                children: [
                  const Text(
                    "Puntuación: ",
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

              // 7. Fila: Sinopsis
              const Text(
                "Sinopsis",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                movie.synopsis,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
              ),
              const SizedBox(height: 20),

              // 8. Fila: Enlace "Ver más +" centrado
              Center(
                child: TextButton(
                  onPressed: () {
                    // Acción para expandir o ir a detalles externos de TMDB
                  },
                  child: Text(
                    "ver más +",
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

              // 9. Fila inferior: Botones de acción redondos (X y Corazón)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón rechazar (X)
                  _buildCircleButton(
                    icon: Icons.close,
                    iconColor: Colors.red,
                    onPressed: () {
                      // Acción al pulsar X
                    },
                  ),
                  const SizedBox(width: 40), // Separación entre círculos
                  // Botón guardar/favorito (Corazón)
                  _buildCircleButton(
                    icon: Icons.favorite,
                    iconColor: Colors.green,
                    onPressed: () {
                      // Acción al pulsar Corazón
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
  Widget _buildCircleButton({required IconData icon, required Color iconColor, required VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
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
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }
}