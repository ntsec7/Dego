import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @usuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get usuario;

  /// No description provided for @intro_usuario.
  ///
  /// In es, this message translates to:
  /// **'Email o username'**
  String get intro_usuario;

  /// No description provided for @contra.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get contra;

  /// No description provided for @intro_contra.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get intro_contra;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// No description provided for @registrarse.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registrarse;

  /// No description provided for @campo_obligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get campo_obligatorio;

  /// No description provided for @olvidado_contra.
  ///
  /// In es, this message translates to:
  /// **'He olvidado mi contraseña'**
  String get olvidado_contra;

  /// No description provided for @recuperar_contra.
  ///
  /// In es, this message translates to:
  /// **'Recuperar contraseña'**
  String get recuperar_contra;

  /// No description provided for @txt_recuperar_contra.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu email y te enviaremos un correo para restablecer tu contraseña.'**
  String get txt_recuperar_contra;

  /// No description provided for @intro_email.
  ///
  /// In es, this message translates to:
  /// **'Introduce el email'**
  String get intro_email;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @enviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get enviar;

  /// No description provided for @txt_recuperar_contra2.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo para continuar'**
  String get txt_recuperar_contra2;

  /// No description provided for @politica_priv.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get politica_priv;

  /// No description provided for @term_cond.
  ///
  /// In es, this message translates to:
  /// **'Términos y condiciones'**
  String get term_cond;

  /// No description provided for @aviso_legal.
  ///
  /// In es, this message translates to:
  /// **'Aviso legal'**
  String get aviso_legal;

  /// No description provided for @politica_priv_text.
  ///
  /// In es, this message translates to:
  /// **'Esta aplicación recoge y trata datos personales con la finalidad de permitir el uso de sus funcionalidades, en concreto la gestión de cuentas de usuario. El único dato personal almacenado es el correo electrónico, que se utiliza para la autenticación y gestión de la cuenta. Los datos son tratados sobre la base del consentimiento del usuario al registrarse en la aplicación. La información se almacena de forma segura utilizando servicios de terceros, concretamente Supabase, que actúa como encargado del tratamiento. Los datos se conservarán mientras la cuenta permanezca activa o hasta que el usuario solicite su eliminación. El usuario puede solicitar en cualquier momento el acceso, rectificación o eliminación de sus datos. La aplicación puede mantener la sesión iniciada mediante almacenamiento local seguro para mejorar la experiencia de usuario. La aplicación podrá enviar notificaciones relacionadas con el uso del servicio. El usuario podrá aceptar o rechazar este permiso y gestionarlo desde la configuración de su dispositivo. Se aplican las medidas de seguridad necesarias para proteger la información y evitar accesos no autorizados. Para cualquier cuestión relacionada con la privacidad, el usuario puede contactar a través de dego.application@gmail.com'**
  String get politica_priv_text;

  /// No description provided for @term_cond_text.
  ///
  /// In es, this message translates to:
  /// **'El uso de esta aplicación está sujeto a la aceptación de estas condiciones. El usuario se compromete a proporcionar información veraz durante el registro y a utilizar la aplicación de forma responsable. Queda prohibido el uso de la aplicación para fines ilícitos, así como cualquier intento de vulnerar su seguridad o integridad. El titular se reserva el derecho de modificar o interrumpir el servicio en cualquier momento. El incumplimiento de estas condiciones podrá dar lugar a la suspensión o eliminación de la cuenta del usuario.'**
  String get term_cond_text;

  /// No description provided for @aviso_legal_text.
  ///
  /// In es, this message translates to:
  /// **'Esta aplicación es un proyecto de carácter personal y académico desarrollado con fines educativos. El acceso y uso de la aplicación implica la aceptación de las condiciones aquí descritas. El usuario se compromete a hacer un uso adecuado de la aplicación y a no emplearla para actividades ilícitas o contrarias a la buena fe. El titular no garantiza la disponibilidad continua del servicio ni la ausencia de errores, y no se hace responsable de los posibles daños derivados del uso de la aplicación. Todos los contenidos, incluyendo código, diseño y elementos visuales, son propiedad del desarrollador o se utilizan bajo licencia, quedando prohibida su reproducción sin autorización.'**
  String get aviso_legal_text;

  /// No description provided for @username.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get username;

  /// No description provided for @nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nombre;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @repite_contra.
  ///
  /// In es, this message translates to:
  /// **'Repite la contraseña'**
  String get repite_contra;

  /// No description provided for @contras_no_coinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get contras_no_coinciden;

  /// No description provided for @intro_nueva_contra.
  ///
  /// In es, this message translates to:
  /// **'Introduce una nueva contraseña'**
  String get intro_nueva_contra;

  /// No description provided for @confirmar_email.
  ///
  /// In es, this message translates to:
  /// **'Confirmar email'**
  String get confirmar_email;

  /// No description provided for @confirmar_email_text.
  ///
  /// In es, this message translates to:
  /// **'Diríjase a su correo electrónico para confirmar su cuenta.'**
  String get confirmar_email_text;

  /// No description provided for @continuar.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continuar;

  /// No description provided for @contra_cambiada.
  ///
  /// In es, this message translates to:
  /// **'Contraseña cambiada correctamente'**
  String get contra_cambiada;

  /// No description provided for @error_credenciales.
  ///
  /// In es, this message translates to:
  /// **'Error: Credenciales incorrectas'**
  String get error_credenciales;

  /// No description provided for @error_servidor.
  ///
  /// In es, this message translates to:
  /// **'Error interno del servidor'**
  String get error_servidor;

  /// No description provided for @error_username.
  ///
  /// In es, this message translates to:
  /// **'Error: El nombre de usuario ya está en uso'**
  String get error_username;

  /// No description provided for @error_email.
  ///
  /// In es, this message translates to:
  /// **'Error: El email ya está en uso'**
  String get error_email;

  /// No description provided for @error_confirma_email.
  ///
  /// In es, this message translates to:
  /// **'Por favor, confirma tu correo electrónico'**
  String get error_confirma_email;

  /// No description provided for @error_internet.
  ///
  /// In es, this message translates to:
  /// **'Error: No hay conexión a internet'**
  String get error_internet;

  /// No description provided for @error_datos.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar los datos. Inténtalo de nuevo'**
  String get error_datos;

  /// No description provided for @error_inesperado.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error inesperado. Inténtalo más tarde'**
  String get error_inesperado;

  /// No description provided for @buscar_grupos.
  ///
  /// In es, this message translates to:
  /// **'Buscar grupos...'**
  String get buscar_grupos;

  /// No description provided for @crear.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get crear;

  /// No description provided for @crear_grupo.
  ///
  /// In es, this message translates to:
  /// **'Crear grupo'**
  String get crear_grupo;

  /// No description provided for @exito_crear_usuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario creado con éxito'**
  String get exito_crear_usuario;

  /// No description provided for @exito_crear_grupo.
  ///
  /// In es, this message translates to:
  /// **'Grupo creado con éxito'**
  String get exito_crear_grupo;

  /// No description provided for @error_carga_usuario.
  ///
  /// In es, this message translates to:
  /// **'Error: No se ha cargado el usuario correctamente'**
  String get error_carga_usuario;

  /// No description provided for @grupos.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get grupos;

  /// No description provided for @error_carga_grupo.
  ///
  /// In es, this message translates to:
  /// **'Error cargando los datos del grupo. Vuelva a intentarlo'**
  String get error_carga_grupo;

  /// No description provided for @miembros.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get miembros;

  /// No description provided for @buscar_miembros.
  ///
  /// In es, this message translates to:
  /// **'Buscar miembros...'**
  String get buscar_miembros;

  /// No description provided for @anadir_miembro.
  ///
  /// In es, this message translates to:
  /// **'Añadir miembro'**
  String get anadir_miembro;

  /// No description provided for @anadir_miembro_txt.
  ///
  /// In es, this message translates to:
  /// **'Introduce el username del usuario que quieres añadir en el grupo para enviarle una invitación.'**
  String get anadir_miembro_txt;

  /// No description provided for @intro_username.
  ///
  /// In es, this message translates to:
  /// **'Introduce el username'**
  String get intro_username;

  /// No description provided for @invitacion_enviada.
  ///
  /// In es, this message translates to:
  /// **'Invitación enviada'**
  String get invitacion_enviada;

  /// No description provided for @username_no_existe.
  ///
  /// In es, this message translates to:
  /// **'Error: El username ingresado no existe'**
  String get username_no_existe;

  /// No description provided for @usuario_pertenece_grupo.
  ///
  /// In es, this message translates to:
  /// **'Error: El usuario ya pertenece al grupo'**
  String get usuario_pertenece_grupo;

  /// No description provided for @aceptar.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get aceptar;

  /// No description provided for @rechazar.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get rechazar;

  /// No description provided for @notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificaciones;

  /// Notificación para invitar a un grupo
  ///
  /// In es, this message translates to:
  /// **'{user_name} te ha invitado a unirte al grupo {group_name}'**
  String noti_invite_group(String user_name, String group_name);

  /// Notificación para echar de un grupo
  ///
  /// In es, this message translates to:
  /// **'{user_name} te ha echado del grupo {group_name}'**
  String noti_kick_group(String user_name, String group_name);

  /// Terminada votación
  ///
  /// In es, this message translates to:
  /// **'Iniciada votación {dec_name} en el grupo {group_name}'**
  String noti_create_vote(String dec_name, String group_name);

  /// Iniciada propuesta de opciones
  ///
  /// In es, this message translates to:
  /// **'Iniciada propuesta de opciones en {dec_name} en el grupo {group_name}'**
  String noti_create_option(String dec_name, String group_name);

  /// No description provided for @noti_end_vote.
  ///
  /// In es, this message translates to:
  /// **'Terminada votación {dec_name} en el grupo {group_name}'**
  String noti_end_vote(Object dec_name, Object group_name);

  /// No description provided for @eliminar_miembro.
  ///
  /// In es, this message translates to:
  /// **'Eliminar miembro'**
  String get eliminar_miembro;

  /// Eliminar un miembro del grupo
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que quieres eliminar a {user_name} del grupo?'**
  String eliminar_miembro_txt(String user_name);

  /// No description provided for @eliminar_miembro_res.
  ///
  /// In es, this message translates to:
  /// **'Miembro eliminado'**
  String get eliminar_miembro_res;

  /// No description provided for @salir_grupo.
  ///
  /// In es, this message translates to:
  /// **'Salirse del grupo'**
  String get salir_grupo;

  /// No description provided for @salir_grupo_txt.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que quieres abandonar el grupo?'**
  String get salir_grupo_txt;

  /// No description provided for @eliminar_grupo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar grupo'**
  String get eliminar_grupo;

  /// No description provided for @eliminar_grupo_txt.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar el grupo?'**
  String get eliminar_grupo_txt;

  /// No description provided for @editar_grupo.
  ///
  /// In es, this message translates to:
  /// **'Editar grupo'**
  String get editar_grupo;

  /// No description provided for @usuarios.
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get usuarios;

  /// No description provided for @buscar_usuarios.
  ///
  /// In es, this message translates to:
  /// **'Buscar usuarios...'**
  String get buscar_usuarios;

  /// No description provided for @perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get perfil;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @user_edit.
  ///
  /// In es, this message translates to:
  /// **'Usuario modificado'**
  String get user_edit;

  /// No description provided for @cambiar_email.
  ///
  /// In es, this message translates to:
  /// **'Cambiar email'**
  String get cambiar_email;

  /// No description provided for @cambiar_email_text.
  ///
  /// In es, this message translates to:
  /// **'El cambio de email deberá ser confirmado mediante la antigua o nueva cuenta de correo. Para visualizar la actualización en la app es posible que tenga que reiniciar la sesión'**
  String get cambiar_email_text;

  /// No description provided for @editar_usuario.
  ///
  /// In es, this message translates to:
  /// **'Editar usuario'**
  String get editar_usuario;

  /// No description provided for @tipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get tipo;

  /// No description provided for @cliente.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get cliente;

  /// No description provided for @admin.
  ///
  /// In es, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @no_usuario.
  ///
  /// In es, this message translates to:
  /// **'No hay usuario'**
  String get no_usuario;

  /// No description provided for @usuario_eliminado.
  ///
  /// In es, this message translates to:
  /// **'Usuario eliminado'**
  String get usuario_eliminado;

  /// No description provided for @eliminar_usuario.
  ///
  /// In es, this message translates to:
  /// **'Eliminar usuario'**
  String get eliminar_usuario;

  /// No description provided for @eliminar_usuario_text.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar al usuario?'**
  String get eliminar_usuario_text;

  /// No description provided for @eliminar_cuenta.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get eliminar_cuenta;

  /// No description provided for @eliminar_cuenta_text.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar tu cuenta? Perderás todos tus datos'**
  String get eliminar_cuenta_text;

  /// No description provided for @titulo.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titulo;

  /// No description provided for @votacion_unica.
  ///
  /// In es, this message translates to:
  /// **'Votación Única'**
  String get votacion_unica;

  /// No description provided for @votacion_multiple.
  ///
  /// In es, this message translates to:
  /// **'Votación Múltiple'**
  String get votacion_multiple;

  /// No description provided for @ruleta.
  ///
  /// In es, this message translates to:
  /// **'Ruleta'**
  String get ruleta;

  /// No description provided for @ranking.
  ///
  /// In es, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @cientifico.
  ///
  /// In es, this message translates to:
  /// **'Científico'**
  String get cientifico;

  /// No description provided for @crear_decision.
  ///
  /// In es, this message translates to:
  /// **'Crear decisión'**
  String get crear_decision;

  /// No description provided for @opciones.
  ///
  /// In es, this message translates to:
  /// **'Opciones'**
  String get opciones;

  /// No description provided for @abrir_opciones.
  ///
  /// In es, this message translates to:
  /// **'Abrir opciones'**
  String get abrir_opciones;

  /// No description provided for @fecha_final_opciones.
  ///
  /// In es, this message translates to:
  /// **'Fecha de finalización de las opciones'**
  String get fecha_final_opciones;

  /// No description provided for @fecha_final_opciones_min.
  ///
  /// In es, this message translates to:
  /// **'Fecha opciones'**
  String get fecha_final_opciones_min;

  /// No description provided for @fecha_final_votacion.
  ///
  /// In es, this message translates to:
  /// **'Fecha de finalización de la votación'**
  String get fecha_final_votacion;

  /// No description provided for @fecha_final_votacion_min.
  ///
  /// In es, this message translates to:
  /// **'Fecha votación'**
  String get fecha_final_votacion_min;

  /// No description provided for @empezar.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get empezar;

  /// No description provided for @imagen.
  ///
  /// In es, this message translates to:
  /// **'Imagen'**
  String get imagen;

  /// No description provided for @descripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descripcion;

  /// No description provided for @descripcion_txt.
  ///
  /// In es, this message translates to:
  /// **'Escribir una descripción'**
  String get descripcion_txt;

  /// No description provided for @crear_opcion.
  ///
  /// In es, this message translates to:
  /// **'Crear opción'**
  String get crear_opcion;

  /// No description provided for @error_tiempo.
  ///
  /// In es, this message translates to:
  /// **'Error: No puedes seleccionar una fecha u hora que ya ha pasado'**
  String get error_tiempo;

  /// No description provided for @error_num_opciones.
  ///
  /// In es, this message translates to:
  /// **'Error: Hace falta al menos 2 opciones para poder empezar'**
  String get error_num_opciones;

  /// No description provided for @exito_crear_decision.
  ///
  /// In es, this message translates to:
  /// **'Decisión creada con éxito'**
  String get exito_crear_decision;

  /// No description provided for @error_tiempos.
  ///
  /// In es, this message translates to:
  /// **'Error: La fecha de votación debe ser posterior a la de opciones'**
  String get error_tiempos;

  /// No description provided for @dar_opciones.
  ///
  /// In es, this message translates to:
  /// **'Dar opciones'**
  String get dar_opciones;

  /// No description provided for @votar.
  ///
  /// In es, this message translates to:
  /// **'Votar'**
  String get votar;

  /// No description provided for @eliminar_decision.
  ///
  /// In es, this message translates to:
  /// **'Eliminar decisión'**
  String get eliminar_decision;

  /// Eliminar decisión
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar la decisión {titulo}'**
  String eliminar_decision_txt(String titulo);

  /// No description provided for @exito_eliminar_decision.
  ///
  /// In es, this message translates to:
  /// **'Decisión eliminada con éxito'**
  String get exito_eliminar_decision;

  /// No description provided for @empezar_votacion.
  ///
  /// In es, this message translates to:
  /// **'Empezar votación'**
  String get empezar_votacion;

  /// No description provided for @eliminar_opcion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar opción'**
  String get eliminar_opcion;

  /// Eliminar opción
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar la opción {titulo}'**
  String eliminar_opcion_txt(String titulo);

  /// No description provided for @exito_eliminar_opcion.
  ///
  /// In es, this message translates to:
  /// **'Opción eliminada con éxito'**
  String get exito_eliminar_opcion;

  /// No description provided for @editar_opcion.
  ///
  /// In es, this message translates to:
  /// **'Editar opción'**
  String get editar_opcion;

  /// No description provided for @editar_decision.
  ///
  /// In es, this message translates to:
  /// **'Editar decisión'**
  String get editar_decision;

  /// No description provided for @error_ya_votado.
  ///
  /// In es, this message translates to:
  /// **'Error: Ya has votado en esta decisión'**
  String get error_ya_votado;

  /// No description provided for @edit_decision_votos.
  ///
  /// In es, this message translates to:
  /// **'Ya ha votos registrados, solo se puede modificar la fecha de finalización'**
  String get edit_decision_votos;

  /// Votar ranking
  ///
  /// In es, this message translates to:
  /// **'Ordena de {num1} a {num2} en orden de preferencia, siendo {num1} la más preferente'**
  String votar_ranking(int num1, int num2);

  /// No description provided for @error_votar_ranking_no_ops.
  ///
  /// In es, this message translates to:
  /// **'Error: Todas las opciones deben tener un número'**
  String get error_votar_ranking_no_ops;

  /// No description provided for @error_votar_ranking_repe.
  ///
  /// In es, this message translates to:
  /// **'Error: Elige un número distinto para cada opción'**
  String get error_votar_ranking_repe;

  /// No description provided for @error_votar_simple_no_ops.
  ///
  /// In es, this message translates to:
  /// **'Error: Selecciona una opción para votar'**
  String get error_votar_simple_no_ops;

  /// No description provided for @error_votar_multiple_no_ops.
  ///
  /// In es, this message translates to:
  /// **'Error: Selecciona al menos una opción para votar'**
  String get error_votar_multiple_no_ops;

  /// No description provided for @girar.
  ///
  /// In es, this message translates to:
  /// **'Girar'**
  String get girar;

  /// No description provided for @ganador.
  ///
  /// In es, this message translates to:
  /// **'¡Ganador!'**
  String get ganador;

  /// No description provided for @error_ruleta_girar.
  ///
  /// In es, this message translates to:
  /// **'Solo puede decidir el creador en decisiones de tipo ruleta'**
  String get error_ruleta_girar;

  /// No description provided for @aventura.
  ///
  /// In es, this message translates to:
  /// **'Aventura'**
  String get aventura;

  /// No description provided for @animacion.
  ///
  /// In es, this message translates to:
  /// **'Animación'**
  String get animacion;

  /// No description provided for @comedia.
  ///
  /// In es, this message translates to:
  /// **'Comedia'**
  String get comedia;

  /// No description provided for @crimen.
  ///
  /// In es, this message translates to:
  /// **'Crimen'**
  String get crimen;

  /// No description provided for @documental.
  ///
  /// In es, this message translates to:
  /// **'Documental'**
  String get documental;

  /// No description provided for @drama.
  ///
  /// In es, this message translates to:
  /// **'Drama'**
  String get drama;

  /// No description provided for @familia.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get familia;

  /// No description provided for @fantasia.
  ///
  /// In es, this message translates to:
  /// **'Fantasía'**
  String get fantasia;

  /// No description provided for @historia.
  ///
  /// In es, this message translates to:
  /// **'Historia'**
  String get historia;

  /// No description provided for @terror.
  ///
  /// In es, this message translates to:
  /// **'Terror'**
  String get terror;

  /// No description provided for @musica.
  ///
  /// In es, this message translates to:
  /// **'Música'**
  String get musica;

  /// No description provided for @misterio.
  ///
  /// In es, this message translates to:
  /// **'Misterio'**
  String get misterio;

  /// No description provided for @romance.
  ///
  /// In es, this message translates to:
  /// **'Romance'**
  String get romance;

  /// No description provided for @ciencia_ficcion.
  ///
  /// In es, this message translates to:
  /// **'Ciencia ficción'**
  String get ciencia_ficcion;

  /// No description provided for @pelicula_tv.
  ///
  /// In es, this message translates to:
  /// **'Película de TV'**
  String get pelicula_tv;

  /// No description provided for @suspense.
  ///
  /// In es, this message translates to:
  /// **'Suspense'**
  String get suspense;

  /// No description provided for @belica.
  ///
  /// In es, this message translates to:
  /// **'Bélica'**
  String get belica;

  /// No description provided for @western.
  ///
  /// In es, this message translates to:
  /// **'Western'**
  String get western;

  /// No description provided for @accion_aventura.
  ///
  /// In es, this message translates to:
  /// **'Acción y Aventura'**
  String get accion_aventura;

  /// No description provided for @infantil.
  ///
  /// In es, this message translates to:
  /// **'Infantil'**
  String get infantil;

  /// No description provided for @noticias.
  ///
  /// In es, this message translates to:
  /// **'Noticias'**
  String get noticias;

  /// No description provided for @reality_show.
  ///
  /// In es, this message translates to:
  /// **'Reality show'**
  String get reality_show;

  /// No description provided for @scifi_fantasia.
  ///
  /// In es, this message translates to:
  /// **'Sci-Fi y Fantasía'**
  String get scifi_fantasia;

  /// No description provided for @telenovelas.
  ///
  /// In es, this message translates to:
  /// **'Telenovelas'**
  String get telenovelas;

  /// No description provided for @talk_show.
  ///
  /// In es, this message translates to:
  /// **'Talk show'**
  String get talk_show;

  /// No description provided for @guerra_politica.
  ///
  /// In es, this message translates to:
  /// **'Guerra y Políticas'**
  String get guerra_politica;

  /// No description provided for @que_ver.
  ///
  /// In es, this message translates to:
  /// **'¿Qué ver?'**
  String get que_ver;

  /// No description provided for @peli.
  ///
  /// In es, this message translates to:
  /// **'Peli'**
  String get peli;

  /// No description provided for @serie.
  ///
  /// In es, this message translates to:
  /// **'Serie'**
  String get serie;

  /// No description provided for @plataforma.
  ///
  /// In es, this message translates to:
  /// **'Plataforma'**
  String get plataforma;

  /// No description provided for @genero_peli.
  ///
  /// In es, this message translates to:
  /// **'Género Pelis'**
  String get genero_peli;

  /// No description provided for @genero_serie.
  ///
  /// In es, this message translates to:
  /// **'Género Series'**
  String get genero_serie;

  /// No description provided for @puntuacion.
  ///
  /// In es, this message translates to:
  /// **'Puntuación'**
  String get puntuacion;

  /// No description provided for @rango.
  ///
  /// In es, this message translates to:
  /// **'Rango'**
  String get rango;

  /// No description provided for @duracion_peli.
  ///
  /// In es, this message translates to:
  /// **'Duración peli'**
  String get duracion_peli;

  /// No description provided for @estreno.
  ///
  /// In es, this message translates to:
  /// **'Estreno'**
  String get estreno;

  /// No description provided for @tipo_pago.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Pago'**
  String get tipo_pago;

  /// No description provided for @orden.
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get orden;

  /// No description provided for @suscripcion.
  ///
  /// In es, this message translates to:
  /// **'Suscripción'**
  String get suscripcion;

  /// No description provided for @compra.
  ///
  /// In es, this message translates to:
  /// **'Compra'**
  String get compra;

  /// No description provided for @alquiler.
  ///
  /// In es, this message translates to:
  /// **'Alquiler'**
  String get alquiler;

  /// No description provided for @gratis.
  ///
  /// In es, this message translates to:
  /// **'Gratis'**
  String get gratis;

  /// No description provided for @mas_populares.
  ///
  /// In es, this message translates to:
  /// **'Más populares'**
  String get mas_populares;

  /// No description provided for @mas_taquilleras.
  ///
  /// In es, this message translates to:
  /// **'Más taquilleras'**
  String get mas_taquilleras;

  /// No description provided for @mas_recientes.
  ///
  /// In es, this message translates to:
  /// **'Más recientes'**
  String get mas_recientes;

  /// No description provided for @mejor_valoradas.
  ///
  /// In es, this message translates to:
  /// **'Mejor valoradas'**
  String get mejor_valoradas;

  /// No description provided for @mas_vistas.
  ///
  /// In es, this message translates to:
  /// **'Más vistas'**
  String get mas_vistas;

  /// No description provided for @error_opciones_decision_watch.
  ///
  /// In es, this message translates to:
  /// **'Error: Debes seleccionar al menos un apartado de cada categoría'**
  String get error_opciones_decision_watch;

  /// No description provided for @error_titulo.
  ///
  /// In es, this message translates to:
  /// **'Error: Debes introducir un título'**
  String get error_titulo;

  /// No description provided for @generos.
  ///
  /// In es, this message translates to:
  /// **'Géneros'**
  String get generos;

  /// No description provided for @fecha_estreno.
  ///
  /// In es, this message translates to:
  /// **'Fecha de estreno'**
  String get fecha_estreno;

  /// No description provided for @sinopsis.
  ///
  /// In es, this message translates to:
  /// **'Sinopsis'**
  String get sinopsis;

  /// No description provided for @ver_mas.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get ver_mas;

  /// No description provided for @terminar_votacion.
  ///
  /// In es, this message translates to:
  /// **'Terminar votación'**
  String get terminar_votacion;

  /// No description provided for @error_votacion_finalizada.
  ///
  /// In es, this message translates to:
  /// **'Error: La votación ya ha finalizado'**
  String get error_votacion_finalizada;

  /// No description provided for @no_quedan_opciones.
  ///
  /// In es, this message translates to:
  /// **'No quedan opciones por votar'**
  String get no_quedan_opciones;

  /// No description provided for @maximo_resultados.
  ///
  /// In es, this message translates to:
  /// **'Máximo de resultados'**
  String get maximo_resultados;

  /// No description provided for @maximo.
  ///
  /// In es, this message translates to:
  /// **'Máximo'**
  String get maximo;

  /// No description provided for @decision_estandar.
  ///
  /// In es, this message translates to:
  /// **'Decisión estándar'**
  String get decision_estandar;

  /// No description provided for @sugerir_peliculas.
  ///
  /// In es, this message translates to:
  /// **'Sugerir películas o series'**
  String get sugerir_peliculas;

  /// No description provided for @disponible.
  ///
  /// In es, this message translates to:
  /// **'Disponible en'**
  String get disponible;

  /// No description provided for @duracion.
  ///
  /// In es, this message translates to:
  /// **'Duración'**
  String get duracion;

  /// No description provided for @temporadas.
  ///
  /// In es, this message translates to:
  /// **'Temporadas'**
  String get temporadas;

  /// No description provided for @capitulos_totales.
  ///
  /// In es, this message translates to:
  /// **'Capítulos totales'**
  String get capitulos_totales;

  /// No description provided for @duracion_cap.
  ///
  /// In es, this message translates to:
  /// **'Duración media por capítulo'**
  String get duracion_cap;

  /// No description provided for @estado_emision.
  ///
  /// In es, this message translates to:
  /// **'Estado de emisión'**
  String get estado_emision;

  /// No description provided for @fecha_final.
  ///
  /// In es, this message translates to:
  /// **'Fecha de finalización'**
  String get fecha_final;

  /// No description provided for @reparto.
  ///
  /// In es, this message translates to:
  /// **'Reparto principal'**
  String get reparto;

  /// No description provided for @equipo_tecnico.
  ///
  /// In es, this message translates to:
  /// **'Equipo técnico'**
  String get equipo_tecnico;

  /// No description provided for @direccion.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get direccion;

  /// No description provided for @guion.
  ///
  /// In es, this message translates to:
  /// **'Guion'**
  String get guion;

  /// No description provided for @companias_productoras.
  ///
  /// In es, this message translates to:
  /// **'Compañias productoras'**
  String get companias_productoras;

  /// No description provided for @finanzas.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get finanzas;

  /// No description provided for @presupuesto.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get presupuesto;

  /// No description provided for @recaudacion.
  ///
  /// In es, this message translates to:
  /// **'Recaudación mundial'**
  String get recaudacion;

  /// No description provided for @trailer.
  ///
  /// In es, this message translates to:
  /// **'Tráiler'**
  String get trailer;

  /// No description provided for @titulos_similares.
  ///
  /// In es, this message translates to:
  /// **'Título similares'**
  String get titulos_similares;

  /// No description provided for @emision.
  ///
  /// In es, this message translates to:
  /// **'En emisión'**
  String get emision;

  /// No description provided for @finalizada.
  ///
  /// In es, this message translates to:
  /// **'Finalizada'**
  String get finalizada;

  /// No description provided for @cancelada.
  ///
  /// In es, this message translates to:
  /// **'Cancelada'**
  String get cancelada;

  /// No description provided for @piloto.
  ///
  /// In es, this message translates to:
  /// **'Piloto'**
  String get piloto;

  /// No description provided for @historial.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get historial;

  /// No description provided for @desempatar.
  ///
  /// In es, this message translates to:
  /// **'Desempatar'**
  String get desempatar;

  /// No description provided for @decide_creador.
  ///
  /// In es, this message translates to:
  /// **'Decide el creador'**
  String get decide_creador;

  /// No description provided for @error_carga_votos.
  ///
  /// In es, this message translates to:
  /// **'Error en la carga de votos'**
  String get error_carga_votos;

  /// No description provided for @error_carga_decision.
  ///
  /// In es, this message translates to:
  /// **'Error en la carga de la decisión'**
  String get error_carga_decision;

  /// No description provided for @error_carga_datos.
  ///
  /// In es, this message translates to:
  /// **'Error en la carga de datos'**
  String get error_carga_datos;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
