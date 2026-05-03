import 'package:flutter/material.dart';
import 'package:dego/utilities/lang.dart';

enum PoliticsType { p, t, a }

extension PoliticsTypeExtension on PoliticsType {
  String title(BuildContext context) {
    switch (this) {
      case PoliticsType.p: return context.lang.politica_priv;
      case PoliticsType.t: return context.lang.term_cond;
      case PoliticsType.a: return context.lang.aviso_legal;
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case PoliticsType.p: return context.lang.politica_priv_text;
      case PoliticsType.t: return context.lang.term_cond_text;
      case PoliticsType.a: return context.lang.aviso_legal_text;
    }
  }

}