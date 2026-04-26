// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get usuario => 'Usuario';

  @override
  String get intro_usuario => 'Introduce el email o username';

  @override
  String get contra => 'Contraseña';

  @override
  String get intro_contra => 'Introduce la contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get registrarse => 'Registrarse';
}
