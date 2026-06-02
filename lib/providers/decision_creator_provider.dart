import 'package:dego/models/decision.dart';
import 'package:dego/models/option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DecisionNotifier extends StateNotifier<Decision> {

  DecisionNotifier()
    : super(
        Decision(
          id_creator: '',
          state: DecisionState.draft,
          type: DecisionType.simple,
          options: [],
        ),
      );

  void setTitle(String title) {
    state = state.copyWith(
      title: title,
    );
  }

  void setOptionDate(DateTime date) {
    state = state.copyWith(
      options_date: date,
    );
  }

  void setVoteDate(DateTime date) {
    state = state.copyWith(
      vote_date: date,
    );
  }

  void addOption(Option option) {
    state = state.copyWith(
      options: [
        ...state.options,
        option,
      ],
    );
  }

  void removeOpcion(int index) {
    final nuevasOpciones =
        List<Option>.from(state.options);

    nuevasOpciones.removeAt(index);

    state = state.copyWith(
      options: nuevasOpciones,
    );
  }

  void reset() {
    state = Decision(
      id_creator: '',
      state: DecisionState.draft,
      type: DecisionType.simple,
      options: [],
    );
  }
}

final decisionCreatorProvider =
    StateNotifierProvider<
      DecisionNotifier,
      Decision
    >(
      (ref) => DecisionNotifier(),
);