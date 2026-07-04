import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:dego/providers/decision_provider.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/providers/watch_decision_detail_provider.dart';
import 'package:intl/intl.dart';  //para el formato del dinero
import 'package:dego/widgets/youtube_player.dart';

class VoteDetails extends ConsumerWidget {
  final String id; 
  final int mediaId; 
  final bool isMovie;

  const VoteDetails({
    super.key,
    required this.id,
    required this.mediaId,
    required this.isMovie,
  });

  String _formatDate(String date) {
    if (date.isEmpty || !date.contains('-')) return date;
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return parts.reversed.join('-');
  }

  String _formatRuntime(int? minutes) {
    if (minutes == null || minutes == 0) return '';
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    if (hours == 0) return '$remainingMinutes min';
    return '${hours}h ${remainingMinutes}min';
  }

  String getTranslateStatus(String? status, BuildContext context){

    if(status==null) return '';

    switch(status){
      case 'Returning Series': return context.lang.emision;
      case 'Ended' : return context.lang.finalizada;
      case 'Canceled' : return context.lang.cancelada;
      case 'Pilot' : return context.lang.piloto;
      default: return status;
    }

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool web = screenWidth > 600;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;


    final decisionAsync = ref.watch(decisionByIdProvider(id));

    final detailAsync = ref.watch( watchDecisionDetailProvider( WatchDecisionDetail(mediaId, isMovie)));

    if (decisionAsync.isLoading || detailAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CupertinoActivityIndicator(radius: 15)),
      );
    }

    if (detailAsync.hasError || decisionAsync.hasError) {
      return Scaffold(
        body: Center(child: Text("Error: ${detailAsync.error ?? decisionAsync.error}")),
      );
    }

    final decision = decisionAsync.requireValue;
    final detail = detailAsync.requireValue;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TÍTULO DECISIÓN Y BOTÓN DE ATRÁS
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
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? const Color.fromARGB(255, 167, 167, 167) : const Color.fromARGB(255, 74, 74, 74), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TÍTULO DE LA PELI/SERIE
              Text(
                detail.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // TAGLINE
              if (detail.tagline.isNotEmpty) ...[
                Text(
                  '"${detail.tagline}"',
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? const Color.fromARGB(255, 167, 167, 167) : const Color.fromARGB(255, 74, 74, 74),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // PLATAFORMAS
              if (detail.platforms.isNotEmpty)
                _buildFilterContainer(
                  context: context,
                  title: context.lang.disponible,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: detail.platforms.map((platform) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary, // Cambiado para contrastar con géneros
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                        ),
                        child: Text(
                          platform,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // DURACIÓN Y ESTADO
              _buildFilterContainer(
                context: context,
                title: context.lang.duracion,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (detail.isMovie) ...[
                      Text("${context.lang.duracion}: ${_formatRuntime(detail.movieRuntime)}", style: const TextStyle(fontSize: 15)),
                    ] else ...[
                      Text("${context.lang.temporadas}: ${detail.numberSeasons}", style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 4),
                      Text("${context.lang.capitulos_totales}: ${detail.numberEpisodes}", style: const TextStyle(fontSize: 15)),
                      if (detail.episodeRuntime != null && detail.episodeRuntime!.isNotEmpty) ...[
                        const SizedBox(height: 4), 
                        Text(
                          "${context.lang.duracion_cap}: ${detail.episodeRuntime!.first}" 
                          "${detail.episodeRuntime!.length > 1 ? ' - ${detail.episodeRuntime![1]}' : ''} min",
                          style: const TextStyle(fontSize: 15)
                        ),
                      ],
                    ],
                    if (!detail.isMovie && detail.status != null) ...[
                      const SizedBox(height: 4),
                      Text("${context.lang.estado_emision}: ${getTranslateStatus(detail.status, context)}", style: const TextStyle(fontSize: 15)),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text("${context.lang.fecha_estreno}: ", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                        Text(_formatDate(detail.releaseDate), style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    if (!detail.isMovie && detail.finishDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text("${context.lang.fecha_final}: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                          Text(_formatDate(detail.finishDate!), style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ]
                  ],
                ),
              ),

              // ACTORES
              if (detail.actors.isNotEmpty)
                _buildFilterContainer(
                  context: context,
                  title: context.lang.reparto,
                  child: Text(detail.actors.join(', '), style: const TextStyle(fontSize: 14, height: 1.4)),
                ),

              // DIRECTORES Y GUIONISTAS
              if (detail.directors.isNotEmpty || detail.scriptwriters.isNotEmpty)
                _buildFilterContainer(
                  context: context,
                  title: context.lang.equipo_tecnico,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (detail.directors.isNotEmpty)
                        Text("${context.lang.direccion}: ${detail.directors.join(', ')}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      if (detail.scriptwriters.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text("${context.lang.guion}: ${detail.scriptwriters.join(', ')}", style: const TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),

              // COMPAÑÍAS PRODUCTORAS
              if (detail.productionCompanies.isNotEmpty)
                _buildFilterContainer(
                  context: context,
                  title: context.lang.companias_productoras,
                  child: Text(
                    detail.productionCompanies.join(' • '),
                    style: TextStyle(
                      fontSize: 14, 
                    fontStyle: FontStyle.italic, 
                    // color: Colors.grey.shade700
                    ),
                  ),
                ),

              // PRESUPUESTO Y RECAUDACIÓN (SOLO PELIS)
              if (detail.isMovie && (detail.budget != 0 || detail.revenue != 0))
                _buildFilterContainer(
                  context: context,
                  title: context.lang.finanzas,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (detail.budget != null && detail.budget! > 0)
                        Text("${context.lang.presupuesto}: ${NumberFormat('#,##0', 'es_ES').format((detail.budget! * 0.92).round())} €",
                        style: const TextStyle(fontSize: 14)),
                      if (detail.revenue != null && detail.revenue! > 0) ...[
                        const SizedBox(height: 4),
                        Text("${context.lang.recaudacion}: ${NumberFormat('#,##0', 'es_ES').format((detail.revenue! * 0.92).round())} €",
                        style: const TextStyle(fontSize: 14, 
                        // color: Colors.green
                        )),
                      ],
                    ],
                  ),
                ),

              // TRÁILER
              if (detail.trailer != null)
              _buildFilterContainer(
                context: context,
                title: context.lang.trailer,
                child: YoutubeTrailerPlayer(videoKey: detail.trailer!),
              ),

              // CONTENIDO SIMILAR (Scroll Horizontal usando tu clase MovieSerie)
              if (detail.similars.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text("Títulos Similares", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.similars.length,
                    itemBuilder: (context, index) {
                      final item = detail.similars[index];
                      return GestureDetector(
                        onTap: () {
                          // Navegación recursiva al pulsar un similar
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => VoteDetails(
                          //       id: id,
                          //       mediaId: item.id,
                          //       isMovie: item.isMovie,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.fullPosterUrl,
                                    fit: BoxFit.cover,
                                    width: 110,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

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
}