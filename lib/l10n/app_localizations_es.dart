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
  String get intro_usuario => 'Email o username';

  @override
  String get contra => 'Contraseña';

  @override
  String get intro_contra => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get registrarse => 'Registrarse';

  @override
  String get campo_obligatorio => 'Campo obligatorio';

  @override
  String get olvidado_contra => 'He olvidado mi contraseña';

  @override
  String get recuperar_contra => 'Recuperar contraseña';

  @override
  String get txt_recuperar_contra =>
      'Introduce tu email y te enviaremos un correo para restablecer tu contraseña.';

  @override
  String get intro_email => 'Introduce el email';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get enviar => 'Enviar';

  @override
  String get txt_recuperar_contra2 => 'Revisa tu correo para continuar';

  @override
  String get politica_priv => 'Política de privacidad';

  @override
  String get term_cond => 'Términos y condiciones';

  @override
  String get polit_cookies => 'Política de cookies';

  @override
  String get aviso_legal => 'Aviso legal';
}
