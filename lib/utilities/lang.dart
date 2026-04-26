import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get lang => AppLocalizations.of(this)!;
}