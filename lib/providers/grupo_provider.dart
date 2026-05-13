import 'package:dego/services/grupo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dego/models/grupo.dart';

final grupoServiceProvider = Provider<GrupoService>((ref){
  return GrupoService();
});

final grupoProvider = StateNotifierProvider<GrupoNotifier, AsyncValue<List<Grupo>>>((ref) {
  final grupoService = ref.watch(grupoServiceProvider);

  return GrupoNotifier(grupoService);
});

class GrupoNotifier extends StateNotifier<AsyncValue<List<Grupo>>> {
  final GrupoService grupoService;

  GrupoNotifier(this.grupoService) : super(const AsyncValue.loading()) {
    getGrupos();
  }

  //GET GRUPOS
  Future<void> getGrupos() async{

    // AsyncValue.guard captura automáticamente errores y los envuelve en AsyncError
    state = await AsyncValue.guard(() async {
      final grupos = await grupoService.getGrupos();
      return grupos;
    });

  }

}