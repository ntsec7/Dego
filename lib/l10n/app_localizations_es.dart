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
  String get guardar => 'Guardar';

  @override
  String get enviar => 'Enviar';

  @override
  String get txt_recuperar_contra2 => 'Revisa tu correo para continuar';

  @override
  String get politica_priv => 'Política de privacidad';

  @override
  String get term_cond => 'Términos y condiciones';

  @override
  String get aviso_legal => 'Aviso legal';

  @override
  String get politica_priv_text =>
      'Esta aplicación recoge y trata datos personales con la finalidad de permitir el uso de sus funcionalidades, en concreto la gestión de cuentas de usuario. El único dato personal almacenado es el correo electrónico, que se utiliza para la autenticación y gestión de la cuenta. Los datos son tratados sobre la base del consentimiento del usuario al registrarse en la aplicación. La información se almacena de forma segura utilizando servicios de terceros, concretamente Supabase, que actúa como encargado del tratamiento. Los datos se conservarán mientras la cuenta permanezca activa o hasta que el usuario solicite su eliminación. El usuario puede solicitar en cualquier momento el acceso, rectificación o eliminación de sus datos. La aplicación puede mantener la sesión iniciada mediante almacenamiento local seguro para mejorar la experiencia de usuario. La aplicación podrá enviar notificaciones relacionadas con el uso del servicio. El usuario podrá aceptar o rechazar este permiso y gestionarlo desde la configuración de su dispositivo. Se aplican las medidas de seguridad necesarias para proteger la información y evitar accesos no autorizados. Para cualquier cuestión relacionada con la privacidad, el usuario puede contactar a través de dego.application@gmail.com';

  @override
  String get term_cond_text =>
      'El uso de esta aplicación está sujeto a la aceptación de estas condiciones. El usuario se compromete a proporcionar información veraz durante el registro y a utilizar la aplicación de forma responsable. Queda prohibido el uso de la aplicación para fines ilícitos, así como cualquier intento de vulnerar su seguridad o integridad. El titular se reserva el derecho de modificar o interrumpir el servicio en cualquier momento. El incumplimiento de estas condiciones podrá dar lugar a la suspensión o eliminación de la cuenta del usuario.';

  @override
  String get aviso_legal_text =>
      'Esta aplicación es un proyecto de carácter personal y académico desarrollado con fines educativos. El acceso y uso de la aplicación implica la aceptación de las condiciones aquí descritas. El usuario se compromete a hacer un uso adecuado de la aplicación y a no emplearla para actividades ilícitas o contrarias a la buena fe. El titular no garantiza la disponibilidad continua del servicio ni la ausencia de errores, y no se hace responsable de los posibles daños derivados del uso de la aplicación. Todos los contenidos, incluyendo código, diseño y elementos visuales, son propiedad del desarrollador o se utilizan bajo licencia, quedando prohibida su reproducción sin autorización.';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get nombre => 'Nombre';

  @override
  String get email => 'Email';

  @override
  String get repite_contra => 'Repite la contraseña';

  @override
  String get contras_no_coinciden => 'Las contraseñas no coinciden';

  @override
  String get intro_nueva_contra => 'Introduce una nueva contraseña';

  @override
  String get confirmar_email => 'Confirmar email';

  @override
  String get confirmar_email_text =>
      'Diríjase a su correo electrónico para confirmar su cuenta.';

  @override
  String get continuar => 'Continuar';

  @override
  String get contra_cambiada => 'Contraseña cambiada correctamente';

  @override
  String get error_credenciales => 'Credenciales incorrectas';

  @override
  String get error_servidor => 'Error interno del servidor';

  @override
  String get error_username => 'El nombre de usuario ya está en uso';

  @override
  String get error_confirma_email =>
      'Por favor, confirma tu correo electrónico';

  @override
  String get error_internet => 'No hay conexión a internet';

  @override
  String get error_datos => 'Error al guardar los datos. Inténtalo de nuevo';

  @override
  String get error_inesperado =>
      'Ha ocurrido un error inesperado. Inténtalo más tarde';

  @override
  String get buscar_grupos => 'Buscar grupos...';

  @override
  String get crear => 'Crear';

  @override
  String get crear_grupo => 'Crear grupo';

  @override
  String get exito_crear_usuario => 'Usuario creado con éxito';

  @override
  String get exito_crear_grupo => 'Grupo creado con éxito';

  @override
  String get error_carga_usuario =>
      'Error: No se ha cargado el usuario correctamente';

  @override
  String get grupos => 'Grupos';

  @override
  String get error_carga_grupo =>
      'Error cargando los datos del grupo. Vuelva a intentarlo';

  @override
  String get miembros => 'Miembros';

  @override
  String get buscar_miembros => 'Buscar miembros...';

  @override
  String get anadir_miembro => 'Añadir miembro';

  @override
  String get anadir_miembro_txt =>
      'Introduce el username del usuario que quieres añadir en el grupo para enviarle una invitación.';

  @override
  String get intro_username => 'Introduce el username';

  @override
  String get invitacion_enviada => 'Invitación enviada';

  @override
  String get username_no_existe => 'El username ingresado no existe';

  @override
  String get usuario_pertenece_grupo => 'El usuario ya pertenece al grupo';

  @override
  String get aceptar => 'Aceptar';

  @override
  String get rechazar => 'Rechazar';

  @override
  String get notificaciones => 'Notificaciones';

  @override
  String noti_invite_group(String user_name, String group_name) {
    return '$user_name te ha invitado a unirte al grupo $group_name';
  }

  @override
  String noti_kick_group(String user_name, String group_name) {
    return '$user_name te ha echado del grupo $group_name';
  }

  @override
  String get eliminar_miembro => 'Eliminar miembro';

  @override
  String eliminar_miembro_txt(String user_name) {
    return '¿Estás seguro que quieres eliminar a $user_name del grupo?';
  }

  @override
  String get eliminar_miembro_res => 'Miembro eliminado';

  @override
  String get salir_grupo => 'Salirse del grupo';

  @override
  String get salir_grupo_txt => '¿Estás seguro que quieres abandonar el grupo?';

  @override
  String get eliminar_grupo => 'Eliminar grupo';

  @override
  String get eliminar_grupo_txt =>
      '¿Estás seguro de que quieres eliminar el grupo?';

  @override
  String get editar_grupo => 'Editar grupo';
}
