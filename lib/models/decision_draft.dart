import 'package:dego/models/decision.dart';
import 'package:dego/models/option_draft.dart';

class DecisionDraft{
  String? title;
  DateTime? options_date;
  DateTime? vote_date;
  DecisionType type;
  List<OptionDraft> options;


  DecisionDraft({
    this.title = "",
    this.options_date,
    this.vote_date,
    this.type = DecisionType.simple,
    this.options = const [],
  });

  DecisionDraft copyWith({
    String? title,
    DateTime? options_date,
    DateTime? vote_date,
    DecisionType? type,
    List<OptionDraft>? options,
  }) {
    return DecisionDraft(
      title: title ?? this.title,
      options_date: options_date ?? this.options_date,
      vote_date: vote_date ?? this.vote_date,
      options: options ?? this.options,
    );
  }

}