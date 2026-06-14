import 'package:dego/utilities/lang.dart';
import 'package:flutter/material.dart';

class TMDBProvider {
  final int id;
  final String name;

  // Constructor: define cómo se crea una plataforma
  const TMDBProvider({
    required this.id,
    required this.name,
  });
}

class TMDBData{

  //https://api.themoviedb.org/3/watch/providers/movie?api_key=3ab6e2904dd7507576e1341f27941769&language=es-ES&watch_region=ES
  static const List<TMDBProvider> providers =[
    TMDBProvider(id: 8, name: "Netflix"),
    TMDBProvider(id: 119, name: "Amazon"),
    TMDBProvider(id: 350, name: "Apple TV"),
    TMDBProvider(id: 337, name: "Disney +"),
    TMDBProvider(id: 2241, name: "Movistar +"),
    TMDBProvider(id: 35, name: "Rakuten TV"),
    TMDBProvider(id: 1773, name: "SkyShowtime"),
    TMDBProvider(id: 62, name: "Atres Player"),
    TMDBProvider(id: 1899, name: "HBO Max")
  ];

  //https://api.themoviedb.org/3/genre/movie/list?api_key=3ab6e2904dd7507576e1341f27941769&language=es-ES
  static List<TMDBProvider> filmGenres(BuildContext context) {
    return [
    TMDBProvider(id: 12, name: context.lang.aventura),
    TMDBProvider(id: 16, name: context.lang.animacion),
    TMDBProvider(id: 35, name: context.lang.comedia),
    TMDBProvider(id: 80, name: context.lang.crimen),
    TMDBProvider(id: 99, name: context.lang.documental),
    TMDBProvider(id: 18, name: context.lang.drama),
    TMDBProvider(id: 10751, name: context.lang.familia),
    TMDBProvider(id: 14, name: context.lang.fantasia),
    TMDBProvider(id: 36, name: context.lang.historia),
    TMDBProvider(id: 27, name: context.lang.terror),
    TMDBProvider(id: 10402, name: context.lang.musica),
    TMDBProvider(id: 9648, name: context.lang.misterio),
    TMDBProvider(id: 10749, name: context.lang.romance),
    TMDBProvider(id: 878, name: context.lang.ciencia_ficcion),
    TMDBProvider(id: 10770, name: context.lang.pelicula_tv),
    TMDBProvider(id: 53, name: context.lang.suspense),
    TMDBProvider(id: 10752, name: context.lang.belica),
    TMDBProvider(id: 37, name: context.lang.western),
    ];
  }

  //https://api.themoviedb.org/3/genre/tv/list?api_key=3ab6e2904dd7507576e1341f27941769&language=es-ES
  static List<TMDBProvider> serieGenres(BuildContext context) { 
    return
  [
    TMDBProvider(id: 10759, name: context.lang.accion_aventura),
    TMDBProvider(id: 16, name: context.lang.animacion),
    TMDBProvider(id: 35, name: context.lang.comedia),
    TMDBProvider(id: 80, name: context.lang.crimen),
    TMDBProvider(id: 99, name: context.lang.documental),
    TMDBProvider(id: 18, name: context.lang.drama),
    TMDBProvider(id: 10751, name: context.lang.familia),
    TMDBProvider(id: 10762, name: context.lang.infantil),
    TMDBProvider(id: 9648, name: context.lang.misterio),
    TMDBProvider(id: 10763, name: context.lang.noticias),
    TMDBProvider(id: 10764, name: context.lang.reality_show),
    TMDBProvider(id: 10765, name: context.lang.scifi_fantasia),
    TMDBProvider(id: 10766, name: context.lang.telenovelas),
    TMDBProvider(id: 10767, name: context.lang.talk_show),
    TMDBProvider(id: 10768, name: context.lang.guerra_politica),
    TMDBProvider(id: 37, name: context.lang.western),
  ];
  }

}

enum TMDBWatchType {
  subscription('flatrate'),
  free('free'),
  rent('rent'),
  buy('buy');


  final String key;
  const TMDBWatchType(this.key);


  String getLabel(BuildContext context) {
    switch (this) {
      case TMDBWatchType.subscription:
        return context.lang.suscripcion; 
      case TMDBWatchType.free:
        return context.lang.gratis;       
      case TMDBWatchType.rent:
        return context.lang.alquiler;    
      case TMDBWatchType.buy:
        return context.lang.compra;      
    }
  }
}


enum TMDBOrder {
  popularityDesc('popularity.desc'),
  revenueDesc('revenue.desc'),
  primaryReleaseDateDesc('primary_release_date.desc'),
  voteAverageDesc('vote_average.desc'),
  voteCountDesc('vote_count.desc');


  final String key;
  const TMDBOrder(this.key);


  String getLabel(BuildContext context) {
    switch (this) {
      case TMDBOrder.popularityDesc:
        return context.lang.mas_populares; 
      case TMDBOrder.revenueDesc:
        return context.lang.mas_taquilleras;
      case TMDBOrder.primaryReleaseDateDesc:
        return context.lang.mas_recientes;
      case TMDBOrder.voteAverageDesc:
        return context.lang.mejor_valoradas;
      case TMDBOrder.voteCountDesc:
        return context.lang.mas_vistas;
    }
  }
}