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
  String get error_credenciales => 'Error: Credenciales incorrectas';

  @override
  String get error_servidor => 'Error interno del servidor';

  @override
  String get error_username => 'Error: El nombre de usuario ya está en uso';

  @override
  String get error_email => 'Error: El email ya está en uso';

  @override
  String get error_confirma_email =>
      'Por favor, confirma tu correo electrónico';

  @override
  String get error_internet => 'Error: No hay conexión a internet';

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
  String get username_no_existe => 'Error: El username ingresado no existe';

  @override
  String get usuario_pertenece_grupo =>
      'Error: El usuario ya pertenece al grupo';

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

  @override
  String get usuarios => 'Usuarios';

  @override
  String get buscar_usuarios => 'Buscar usuarios...';

  @override
  String get perfil => 'Perfil';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get user_edit => 'Usuario modificado';

  @override
  String get cambiar_email => 'Cambiar email';

  @override
  String get cambiar_email_text =>
      'El cambio de email deberá ser confirmado mediante la antigua o nueva cuenta de correo. Para visualizar la actualización en la app es posible que tenga que reiniciar la sesión';

  @override
  String get editar_usuario => 'Editar usuario';

  @override
  String get tipo => 'Tipo';

  @override
  String get cliente => 'Cliente';

  @override
  String get admin => 'Admin';

  @override
  String get no_usuario => 'No hay usuario';

  @override
  String get usuario_eliminado => 'Usuario eliminado';

  @override
  String get eliminar_usuario => 'Eliminar usuario';

  @override
  String get eliminar_usuario_text =>
      '¿Estás seguro de que quieres eliminar al usuario?';

  @override
  String get eliminar_cuenta => 'Eliminar cuenta';

  @override
  String get eliminar_cuenta_text =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Perderás todos tus datos';

  @override
  String get titulo => 'Título';

  @override
  String get votacion => 'Votación';

  @override
  String get ruleta => 'Ruleta';

  @override
  String get ranking => 'Ranking';

  @override
  String get cientifico => 'Científico';

  @override
  String get crear_decision => 'Crear decisión';

  @override
  String get opciones => 'Opciones';

  @override
  String get abrir_opciones => 'Abrir opciones';

  @override
  String get fecha_final_opciones => 'Fecha de finalización de las opciones';

  @override
  String get fecha_final_opciones_min => 'Fecha opciones';

  @override
  String get fecha_final_votacion => 'Fecha de finalización de la votación';

  @override
  String get fecha_final_votacion_min => 'Fecha votación';

  @override
  String get empezar => 'Empezar';

  @override
  String get imagen => 'Imagen';

  @override
  String get descripcion => 'Descripción';

  @override
  String get descripcion_txt => 'Escribir una descripción';

  @override
  String get crear_opcion => 'Crear opción';

  @override
  String get error_tiempo =>
      'Error: No puedes seleccionar una fecha u hora que ya ha pasado';

  @override
  String get error_num_opciones =>
      'Error: Hace falta al menos 2 opciones para poder empezar';

  @override
  String get exito_crear_decision => 'Decisión creada con éxito';

  @override
  String get error_tiempos =>
      'Error: La fecha de votación debe ser posterior a la de opciones';

  @override
  String get dar_opciones => 'Dar opciones';

  @override
  String get votar => 'Votar';

  @override
  String get eliminar_decision => 'Eliminar decisión';

  @override
  String eliminar_decision_txt(String titulo) {
    return '¿Estás seguro de que quieres eliminar la decisión $titulo';
  }

  @override
  String get exito_eliminar_decision => 'Decisión eliminada con éxito';

  @override
  String get empezar_votacion => 'Empezar votación';

  @override
  String get eliminar_opcion => 'Eliminar opción';

  @override
  String eliminar_opcion_txt(String titulo) {
    return '¿Estás seguro de que quieres eliminar la opción $titulo';
  }

  @override
  String get exito_eliminar_opcion => 'Opción eliminada con éxito';

  @override
  String get editar_opcion => 'Editar opción';

  @override
  String get editar_decision => 'Editar decisión';

  @override
  String get error_ya_votado => 'Error: Ya has votado en esta decisión';

  @override
  String get edit_decision_votos =>
      'Ya ha votos registrados, solo se puede modificar la fecha de finalización';

  @override
  String votar_ranking(int num1, int num2) {
    return 'Ordena de $num1 a $num2 en orden de preferencia, siendo $num1 la más preferente';
  }

  @override
  String get error_votar_ranking_no_ops =>
      'Error: Todas las opciones deben tener un número';

  @override
  String get error_votar_ranking_repe =>
      'Error: Elige un número distinto para cada opción';

  @override
  String get error_votar_simple_no_ops =>
      'Error: Selecciona una opción para votar';

  @override
  String get girar => 'Girar';

  @override
  String get ganador => '¡Ganador!';

  @override
  String get error_ruleta_girar =>
      'Solo puede decidir el creador en decisiones de tipo ruleta';

  @override
  String get aventura => 'Aventura';

  @override
  String get animacion => 'Animación';

  @override
  String get comedia => 'Comedia';

  @override
  String get crimen => 'Crimen';

  @override
  String get documental => 'Documental';

  @override
  String get drama => 'Drama';

  @override
  String get familia => 'Familia';

  @override
  String get fantasia => 'Fantasía';

  @override
  String get historia => 'Historia';

  @override
  String get terror => 'Terror';

  @override
  String get musica => 'Música';

  @override
  String get misterio => 'Misterio';

  @override
  String get romance => 'Romance';

  @override
  String get ciencia_ficcion => 'Ciencia ficción';

  @override
  String get pelicula_tv => 'Película de TV';

  @override
  String get suspense => 'Suspense';

  @override
  String get belica => 'Bélica';

  @override
  String get western => 'Western';

  @override
  String get accion_aventura => 'Acción y Aventura';

  @override
  String get infantil => 'Infantil';

  @override
  String get noticias => 'Noticias';

  @override
  String get reality_show => 'Reality show';

  @override
  String get scifi_fantasia => 'Sci-Fi y Fantasía';

  @override
  String get telenovelas => 'Telenovelas';

  @override
  String get talk_show => 'Talk show';

  @override
  String get guerra_politica => 'Guerra y Políticas';

  @override
  String get que_ver => '¿Qué ver?';

  @override
  String get peli => 'Peli';

  @override
  String get serie => 'Serie';

  @override
  String get plataforma => 'Plataforma';

  @override
  String get genero_peli => 'Género Pelis';

  @override
  String get genero_serie => 'Género Series';

  @override
  String get puntuacion => 'Puntuación';

  @override
  String get rango => 'Rango';

  @override
  String get duracion_peli => 'Duración peli';

  @override
  String get estreno => 'Estreno';

  @override
  String get tipo_pago => 'Tipo de Pago';

  @override
  String get orden => 'Orden';

  @override
  String get suscripcion => 'Suscripción';

  @override
  String get compra => 'Compra';

  @override
  String get alquiler => 'Alquiler';

  @override
  String get gratis => 'Gratis';

  @override
  String get mas_populares => 'Más populares';

  @override
  String get mas_taquilleras => 'Más taquilleras';

  @override
  String get mas_recientes => 'Más recientes';

  @override
  String get mejor_valoradas => 'Mejor valoradas';

  @override
  String get mas_vistas => 'Más vistas';

  @override
  String get error_opciones_decision_watch =>
      'Error: Debes seleccionar al menos un apartado de cada categoría';

  @override
  String get error_titulo => 'Error: Debes introducir un título';

  @override
  String get generos => 'Géneros';

  @override
  String get fecha_estreno => 'Fecha de estreno';

  @override
  String get sinopsis => 'Sinopsis';

  @override
  String get ver_mas => 'Ver más';

  @override
  String get terminar_votacion => 'Terminar votación';

  @override
  String get error_votacion_finalizada => 'Error: La votación ya ha finalizado';

  @override
  String get no_quedan_opciones => 'No quedan opciones';
}
