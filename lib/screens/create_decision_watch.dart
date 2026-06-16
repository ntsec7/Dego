// ignore_for_file: use_build_context_synchronously

import 'package:dego/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/utilities/lang.dart';
import 'package:dego/utilities/error.dart';
import 'package:dego/providers/decision_draft_provider.dart';
import 'package:dego/providers/current_group_provider.dart';
import 'package:dego/providers/create_provider.dart';
import 'package:dego/models/tmdb_info.dart';

class CreateDecisionWatch extends ConsumerStatefulWidget {
  const CreateDecisionWatch({super.key});

  @override
  ConsumerState<CreateDecisionWatch> createState() => _CreateDecisionWatch();
}

class _CreateDecisionWatch extends ConsumerState<CreateDecisionWatch> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _dateControllerVote = TextEditingController();

  bool _loading = false;

  // Estados locales para los filtros (puedes migrarlos a tu draft provider después)
  String _selectedType = "";
  final List<int> _selectedProviders = [];
  final List<int> _selectedFilmGenres = [];
  final List<int> _selectedSerieGenres = [];
  RangeValues _scoreRange = const RangeValues(0, 10);
  RangeValues _durationRange = const RangeValues(30, 210);
  final int _currentYear = DateTime.now().year;
  late RangeValues _yearRange = RangeValues(1950, _currentYear.toDouble());
  // final List<TMDBWatchType> _selectedWatchTypes = [];
  TMDBOrder _selectedOrder = TMDBOrder.voteAverageDesc;

  @override
  void dispose() {
    _title.dispose();
    _dateControllerVote.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isOptionDate) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (finalDateTime.isBefore(DateTime.now())) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.lang.error_tiempo),
        ),
      );
      return;
    }

    final formattedText = 
      "${finalDateTime.day.toString().padLeft(2, '0')}-${finalDateTime.month.toString().padLeft(2, '0')}-${finalDateTime.year} "
      "${finalDateTime.hour.toString().padLeft(2, '0')}:${finalDateTime.minute.toString().padLeft(2, '0')}";

    setState(() {
        _dateControllerVote.text = formattedText;
        ref.read(decisionDraftProvider.notifier).setVoteDate(finalDateTime);
    });
  }

  // WIDGET CONTENEDOR CON TÍTULO EN EL BORDE
  Widget _buildFilterContainer({required String title, required Widget child}) {

    final screenWidth = MediaQuery.of(context).size.width;

    bool web = screenWidth > 600 ? true : false;    

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
            color: Theme.of(context).scaffoldBackgroundColor, // Para tapar el borde de abajo
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

  String generateUrl() {

    String endpoint = _selectedType == context.lang.peli ? 'movie' : 'tv';

    // Base de los parámetros obligatorios
    final Map<String, String> queryParameters = {
      'endpoint': endpoint,
      'language': 'es-ES',
      'sort_by': _selectedOrder.key,
      'watch_region': 'ES',
    };

    // Si se ordena por nota, exijimos al menos 100 votos para que no salgan películas raras
    if (_selectedOrder.key == 'vote_average.desc') {
      queryParameters['vote_count.gte'] = '100'; 
    }

    // Plataformas
    queryParameters['with_watch_providers'] = _selectedProviders.join('|'); // '|' funciona como un "OR" en TMDB
    

    String yearStart = "${_yearRange.start.round()}-01-01"; //primer día del año
    String yearEnd = "${_yearRange.end.round()}-12-31"; //último  día del año

    // Si es peli
    if (endpoint=='movie') {

      queryParameters['with_genres'] = _selectedFilmGenres.join('|'); //género

      //Duración (es solo en pelis)
      queryParameters['with_runtime.gte'] = _durationRange.start.round().toString();
      queryParameters['with_runtime.lte'] = _durationRange.end.round().toString();

      //Año de estreno (movie: release_date)
      queryParameters['primary_release_date.gte'] = yearStart;
      queryParameters['primary_release_date.lte'] = yearEnd;


    } else{ //Si es serie

      queryParameters['with_genres'] = _selectedSerieGenres.join('|');

      // Año de estreno (tv : first_air_date)
      queryParameters['first_air_date.gte'] = yearStart;
      queryParameters['first_air_date.lte'] = yearEnd;

    }

    // Puntuación 
    queryParameters['vote_average.gte'] = _scoreRange.start.toStringAsFixed(1);
    queryParameters['vote_average.lte'] = _scoreRange.end.toStringAsFixed(1);

    //Tipo de pago
    // queryParameters['with_watch_monetization_types'] = 
    //       _selectedWatchTypes.map((type) => type.name).join('|');


    final queryString = Uri(queryParameters: queryParameters).query;

    return '/discover/$endpoint?$queryString';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool web = screenWidth > 600 ? true : false;

    final double ladoIzquierdo = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double ladoDerecho = web ? screenWidth * 0.15 : screenWidth * 0.05;
    final double labelWidth = web ? screenWidth * 0.1 : screenWidth * 0.25;

    final usuarioAsync = ref.watch(usuarioProvider);
    final currentUserId = usuarioAsync.value?.id;
    final currentGroupId = ref.watch(idCurrentGroupProvider);

    final film = context.lang.peli;
    final serie = context.lang.serie;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TÍTULO DE LA PANTALLA
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: web ? screenHeight * 0.03 : screenHeight * 0.02,
                horizontal: web ? screenWidth * 0.15 : screenWidth * 0.05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.lang.que_ver,
                  style: TextStyle(
                    fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.018,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: ladoIzquierdo, right: ladoDerecho, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: web ? screenHeight * 0.01 : screenHeight * 0.02),

                      // TÍTULO FORMULARIO
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(
                            width: labelWidth,
                            child: Text.rich(
                              TextSpan(
                                text: "${context.lang.titulo} ", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: web ? (screenHeight + screenWidth) * 0.009 : (screenHeight + screenWidth) * 0.014,
                                  color: Theme.of(context).textTheme.bodyLarge?.color, 
                                ),
                                children: const [
                                  TextSpan(text: '*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' :'),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: TextFormField(
                              key: const Key('nameField'),
                              controller: _title,
                              validator: (value) => value == null || value.isEmpty ? context.lang.campo_obligatorio : null,
                              onChanged: (value) => ref.read(decisionDraftProvider.notifier).setTitle(value),
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Arial',
                                fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.0125,
                              ),
                              decoration: InputDecoration(
                                hintText: context.lang.titulo,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.012,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: web ? (screenHeight + screenWidth) * 0.007 : (screenHeight + screenWidth) * 0.012,
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                                filled: true,
                                fillColor: Colors.white,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: web ? screenHeight * 0.03 : screenHeight * 0.03),

                      // TIPO (Peli o Serie)
                      _buildFilterContainer(
                        title: context.lang.tipo,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [film, serie].map((type) {
                            final isSelected = _selectedType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(type),
                                selected: isSelected,
                                selectedColor: Theme.of(context).colorScheme.primary, 
                                backgroundColor: Colors.grey.shade200,
                                labelStyle: TextStyle(color: isSelected ? Colors.white : const Color.fromARGB(255, 88, 88, 88) ),
                                shape: const StadiumBorder(),
                                showCheckmark: false,
                                onSelected: (bool selected) {
                                  if (selected) { 
                                    setState(() {
                                      _selectedType = type; 
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // PLATAFORMA (Scroll Horizontal)
                      _buildFilterContainer(
                        title: context.lang.plataforma,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: TMDBData.providers.map((provider) {
                              final isSelected = _selectedProviders.contains(provider.id);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(provider.name),
                                  selected: isSelected,
                                  selectedColor: Theme.of(context).colorScheme.primary, 
                                  backgroundColor: Colors.grey.shade200,
                                  labelStyle: TextStyle(color: isSelected ? Colors.white : const Color.fromARGB(255, 88, 88, 88) ),
                                  shape: const StadiumBorder(),
                                  showCheckmark: false,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedProviders.add(provider.id);
                                      } else {
                                        _selectedProviders.remove(provider.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),


                      // GÉNERO PELI (Wrap - Varias Filas)
                      if(_selectedType == film) ...[
                      _buildFilterContainer(
                        title: context.lang.genero_peli,
                        child: Wrap(
                          spacing: 8.0, // Espacio horizontal entre óvalos
                          runSpacing: 4.0, // Espacio vertical entre filas
                          children: TMDBData.filmGenres(context).map((genero) {
                            final isSelected = _selectedFilmGenres.contains(genero.id);
                            return FilterChip(
                              label: Text(genero.name),
                              selected: isSelected,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : const Color.fromARGB(255, 88, 88, 88) ),
                              shape: const StadiumBorder(),
                              showCheckmark: false,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedFilmGenres.add(genero.id);
                                  } else {
                                    _selectedFilmGenres.remove(genero.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      ],


                      // GÉNERO SERIE (Wrap - Varias Filas)
                       if(_selectedType == serie) ...[
                      _buildFilterContainer(
                        title: context.lang.genero_serie,
                        child: Wrap(
                          spacing: 8.0, // Espacio horizontal entre óvalos
                          runSpacing: 4.0, // Espacio vertical entre filas
                          children: TMDBData.serieGenres(context).map((genero) {
                            final isSelected = _selectedSerieGenres.contains(genero.id);
                            return FilterChip(
                              label: Text(genero.name),
                              selected: isSelected,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : const Color.fromARGB(255, 88, 88, 88) ),
                              shape: const StadiumBorder(),
                              showCheckmark: false,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSerieGenres.add(genero.id);
                                  } else {
                                    _selectedSerieGenres.remove(genero.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      ],

                      //PUNTUACIÓN (Deslizable Rango)
                      _buildFilterContainer(
                        title: context.lang.puntuacion,
                        child: Column(
                          children: [
                            RangeSlider(
                              values: _scoreRange,
                              min: 0,
                              max: 10,
                              divisions: 20,
                              activeColor: Theme.of(context).colorScheme.primary, 
                              inactiveColor: Colors.grey.shade300,
                              labels: RangeLabels(
                                _scoreRange.start.toStringAsFixed(1),
                                _scoreRange.end.toStringAsFixed(1),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _scoreRange = values;
                                });
                              },
                            ),
                            Text(
                              "${context.lang.rango}: ${_scoreRange.start.toStringAsFixed(1)} - ${_scoreRange.end.toStringAsFixed(1)}",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            )
                          ],
                        ),
                      ),

                      //DURACIÓN PELI (Deslizable Rango)
                       if(_selectedType == film) ...[
                      _buildFilterContainer(
                        title: context.lang.duracion_peli,
                        child: Column(
                          children: [
                            RangeSlider(
                              values: _durationRange,
                              min: 30,  //30 min
                              max: 210, //3h:30min
                              divisions: 12,
                              activeColor: Theme.of(context).colorScheme.primary, 
                              inactiveColor: Colors.grey.shade300,
                              labels: RangeLabels(
                                _durationRange.start.round().toString(),
                                _durationRange.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _durationRange = values;
                                });
                              },
                            ),
                            Text(
                              "${context.lang.rango}: ${_durationRange.start.round()} - ${_durationRange.end.round()} min",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                       ],

                      //FECHA DE ESTRENO
                      _buildFilterContainer(
                        title: context.lang.estreno,
                        child: Column(
                          children: [
                            RangeSlider(
                              values: _yearRange,
                              min: 1950,  
                              max: _currentYear.toDouble(), 
                              divisions: 12,
                              activeColor: Theme.of(context).colorScheme.primary, 
                              inactiveColor: Colors.grey.shade300,
                              labels: RangeLabels(
                                _yearRange.start.round().toString(),
                                _yearRange.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _yearRange = values;
                                });
                              },
                            ),
                            Text(
                              "${context.lang.rango}: ${_yearRange.start.round()} - ${_yearRange.end.round()}",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            )
                          ],
                        ),
                      ),

                      // TIPO DE PAGO
                      // _buildFilterContainer(
                      //   title: context.lang.tipo_pago,
                      //   child: Wrap(
                      //     spacing: 8.0, // Espacio horizontal entre óvalos
                      //     runSpacing: 4.0, // Espacio vertical entre filas
                      //     children: TMDBWatchType.values.map((type) {
                      //       final isSelected = _selectedWatchTypes.contains(type);
                      //       return Padding(
                      //         padding: const EdgeInsets.only(right: 8.0),
                      //         child: FilterChip(
                      //           label: Text(type.getLabel(context)),
                      //           selected: isSelected,
                      //           selectedColor: Theme.of(context).colorScheme.primary, 
                      //           backgroundColor: Colors.grey.shade200,
                      //           labelStyle: TextStyle(color: isSelected ? Colors.white : const Color.fromARGB(255, 88, 88, 88) ),
                      //           shape: const StadiumBorder(),
                      //           showCheckmark: false,
                      //           onSelected: (bool selected) {
                      //             setState(() {
                      //               if (selected) {
                      //                 _selectedWatchTypes.add(type);
                      //               } else {
                      //                 _selectedWatchTypes.remove(type);
                      //               }
                      //             });
                      //           },
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),

                    // ORDENAR POR (Desplegable)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: web ? screenWidth * 0.02 : 0, 
                            right: 12.0, 
                          ),
                          child: Text(
                            "${context.lang.orden}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: web
                                  ? (screenHeight + screenWidth) * 0.012
                                  : (screenHeight + screenWidth) * 0.014,
                            ),
                          ),
                        ),
                        
                        Expanded(
                          child: DropdownButtonFormField<TMDBOrder>(
                            key: const Key('orderField'),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            initialValue: _selectedOrder, 
                            onChanged: (TMDBOrder? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedOrder = newValue;
                                });
                              }
                            },
                            items: TMDBOrder.values.map((TMDBOrder order) {
                              return DropdownMenuItem<TMDBOrder>(
                                value: order,
                                child: Text(order.getLabel(context)), 
                              );
                            }).toList(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: web 
                                  ? (screenHeight + screenWidth) * 0.01 
                                  : (screenHeight + screenWidth) * 0.0125,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: web 
                                    ? (screenHeight + screenWidth) * 0.007 
                                    : (screenHeight + screenWidth) * 0.012,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200, 
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none, 
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            alignment: Alignment.centerLeft,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: web ? screenHeight * 0.03 : screenHeight * 0.03),

                      // =======================================

                      // FECHA FINAL VOTACIÓN
                        TextFormField(
                          controller: _dateControllerVote,
                          readOnly: true,
                          onTap: () => _pickDateTime(false),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: context.lang.fecha_final_votacion,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.012,
                            ),
                            prefixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.black),
                            suffixIcon: _dateControllerVote.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _dateControllerVote.clear();
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        SizedBox(height: web ? screenHeight * 0.04 : screenHeight * 0.04),

                      // BOTONES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CANCELAR
                          ElevatedButton(
                            onPressed: () {
                              ref.read(decisionDraftProvider.notifier).reset();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCC2525),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              context.lang.cancelar,
                              style: TextStyle(
                                fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                              ),
                            ),
                          ),

                          SizedBox(width: screenWidth * 0.05),

                          // EMPEZAR
                          ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      try {
                                        
                                        //Comprueba que haya al menos una opción seleccionada de cada categoría
                                        if(_selectedType.isEmpty || _selectedProviders.isEmpty || (_selectedType==film && _selectedFilmGenres.isEmpty) || (_selectedType==serie && _selectedSerieGenres.isEmpty)){
                                           ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(context.lang.error_opciones_decision_watch),
                                            ),
                                          );
                                          _loading=false;
                                          return;
                                        }

                                        //Coge los filtros
                                        final url = generateUrl();

                                        //Crea la decisión

                                        final DateTime? parsedDate = DateTime.tryParse(_dateControllerVote.text);
                                        final DateTime? finishDateTime = parsedDate?.toLocal();

                                        await ref.read(createProvider.notifier).createWatchDecision(id_creator: currentUserId!, id_group: currentGroupId, title: _title.text, finish_hour: finishDateTime, url: url);

                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(context.lang.exito_crear_decision)),
                                        );

                                        Navigator.pop(context);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(translateSupabaseError(context, e))),
                                        );
                                      }
                                      setState(() => _loading = false);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(context.lang.error_titulo),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF098238),
                              foregroundColor: Colors.white,
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    context.lang.empezar,
                                    style: TextStyle(
                                      fontSize: web ? (screenHeight + screenWidth) * 0.01 : (screenHeight + screenWidth) * 0.015,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
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