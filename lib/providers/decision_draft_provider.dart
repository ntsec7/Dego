import 'package:dego/models/decision.dart';
import 'package:dego/models/decision_draft.dart';
import 'package:dego/models/option_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DecisionDraftNotifier extends StateNotifier<DecisionDraft> {

  DecisionDraftNotifier()
      : super(DecisionDraft());


  void setTitle(String title) {
    state = state.copyWith(
      title: title,
    );
  }

  void setOptionDate(DateTime? date) {
    state = state.copyWith(
      options_date: date,
    );
  }

  void setVoteDate(DateTime? date) {
    state = state.copyWith(
      vote_date: date,
    );
  }

  void setType(DecisionType type){
    state = state.copyWith(
      type: type,
    );
  }

  void addOption(OptionDraft option) {
    state = state.copyWith(
      options: [
        ...state.options,
        option,
      ],
    );
  }

  void updateOption(int index, OptionDraft option) {
    final options = List<OptionDraft>.from(state.options);

    options[index] = option;

    state = state.copyWith(
      options: options,
    );
  }

  void removeOpcion(int index) {
    final nuevasOpciones =
        List<OptionDraft>.from(state.options);

    nuevasOpciones.removeAt(index);

    state = state.copyWith(
      options: nuevasOpciones,
    );
  }

  void reset() {
    state = DecisionDraft();
  }
}

final decisionDraftProvider =
    StateNotifierProvider<
      DecisionDraftNotifier,
      DecisionDraft
    >(
      (ref) => DecisionDraftNotifier(),
);