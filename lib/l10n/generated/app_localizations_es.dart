// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Politia';

  @override
  String get copticOrthodox => 'COPTO ORTODOXO';

  @override
  String get welcomeMessage => 'Bienvenido a Politia';

  @override
  String get statusRunning => 'Motor de plataforma operativo';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get selectLanguage => 'SELECCIONAR IDIOMA';

  @override
  String get welcome => 'BIENVENIDO';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signIn => 'INICIAR SESIÓN';

  @override
  String get signUp => 'REGISTRARSE';

  @override
  String get signInDescription =>
      'Ingrese su correo electrónico o número de teléfono registrado para continuar.';

  @override
  String get helloSignIn => 'Hola\n¡Inicia sesión!';

  @override
  String get createYourAccount => 'Crea tu\ncuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailOrUsername => 'Correo electrónico o usuario';

  @override
  String get phoneOrEmail => 'Teléfono o correo electrónico';

  @override
  String get emailOrMobile => 'Correo o número de teléfono';

  @override
  String get emailOrMobileHint => 'webx@gmail.com o 010XXXXXXXX';

  @override
  String get supportedEgyptianCarriers =>
      'Operadores egipcios compatibles: 010, 011, 012, 015';

  @override
  String get continueText => 'Continuar';

  @override
  String get orDivider => 'O';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithFacebook => 'Continuar con Facebook';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get invalidEmail => 'Por favor ingresa un correo válido';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get nameRequired => 'El nombre completo es obligatorio';

  @override
  String get back => 'Atrás';

  @override
  String get enterEmailOrPhone =>
      'Por favor ingresa tu correo o número de teléfono';

  @override
  String get invalidIdentityError =>
      'Por favor ingresa un correo válido o número egipcio (010, 011, 012, 015)';

  @override
  String get userNotRegistered =>
      'Correo electrónico o teléfono no registrado.';

  @override
  String get enterPassword => 'Por favor ingresa tu contraseña';

  @override
  String get incorrectPassword => 'Contraseña incorrecta.';

  @override
  String attemptsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intentos restantes.',
      one: '1 intento restante.',
    );
    return '$_temp0';
  }

  @override
  String get maxAttemptsOtp =>
      'Se alcanzó el número máximo de intentos (10/10). Código OTP activado.';

  @override
  String get enterOtpCode => 'Ingresa el código de verificación (6 dígitos)';

  @override
  String get enterFullOtp =>
      'Por favor ingresa el código completo de 6 dígitos';

  @override
  String otpSent(String identity) {
    return 'Código de verificación enviado a $identity';
  }

  @override
  String resendCodeIn(int seconds) {
    return 'Reenviar código en ${seconds}s';
  }

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get switchAccount => 'Cambiar de cuenta';

  @override
  String get verifyAndSignIn => 'Verificar e iniciar sesión';

  @override
  String get usePasswordInstead => 'Usar contraseña en su lugar';

  @override
  String get contactAdminForgot =>
      'Comuníquese con el administrador para restablecer la contraseña o use OTP';

  @override
  String get registeredMember => 'Miembro registrado';

  @override
  String comingSoon(String provider) {
    return 'Inicio de sesión con $provider próximamente';
  }

  @override
  String get verseText =>
      '\"Porque donde están dos o tres congregados en mi nombre, allí estoy yo en medio de ellos.\" — Mateo 18:20';
}
