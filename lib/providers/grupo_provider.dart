import 'package:dego/services/grupo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/grupo.dart';

final grupoServiceProvider = Provider<GrupoService>((ref) => GrupoService());

// Este provider escuchará el stream automáticamente
final grupoProvider = StreamProvider<List<Grupo>>((ref) {
  final service = ref.watch(grupoServiceProvider);
  return service.getGrupos();
});
