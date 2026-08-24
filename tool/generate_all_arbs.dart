// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    print('lib/l10n does not exist');
    return;
  }

  // Base English strings
  final baseEn = {
    "appTitle": "Politia",
    "welcomeMessage": "Welcome to Politia",
    "statusRunning": "Platform Engine & Localization Operational",
    "changeLanguage": "Language",
    "welcomeBack": "Welcome Back",
    "signIn": "SIGN IN",
    "signUp": "SIGN UP",
    "helloSignIn": "Hello\nSign in!",
    "createYourAccount": "Create Your\nAccount",
    "email": "Email",
    "emailOrUsername": "Email or Username",
    "phoneOrEmail": "Phone or Email",
    "password": "Password",
    "confirmPassword": "Confirm Password",
    "fullName": "Full Name",
    "forgotPassword": "Forgot password?",
    "dontHaveAccount": "Don't have an account?",
    "alreadyHaveAccount": "Already have an account?",
    "invalidEmail": "Please enter a valid email",
    "passwordTooShort": "Password must be at least 6 characters",
    "passwordsDoNotMatch": "Passwords do not match",
    "nameRequired": "Full name is required"
  };

  // Base Arabic strings
  final baseAr = {
    "appTitle": "بوليتيا",
    "welcomeMessage": "مرحبًا بك في بوليتيا",
    "statusRunning": "محرك المنصة ونظام التعريب يعملان بكفاءة",
    "changeLanguage": "اللغة",
    "welcomeBack": "مرحبًا بك مجددًا",
    "signIn": "تسجيل الدخول",
    "signUp": "إنشاء حساب",
    "helloSignIn": "أهلاً بك\nسجل الدخول!",
    "createYourAccount": "أنشئ\nحسابك الجديد",
    "email": "البريد الإلكتروني",
    "emailOrUsername": "البريد الإلكتروني أو اسم المستخدم",
    "phoneOrEmail": "رقم الهاتف أو البريد الإلكتروني",
    "password": "كلمة المرور",
    "confirmPassword": "تأكيد كلمة المرور",
    "fullName": "الاسم الكامل",
    "forgotPassword": "هل نسيت كلمة المرور؟",
    "dontHaveAccount": "ليس لديك حساب؟",
    "alreadyHaveAccount": "لديك حساب بالفعل؟",
    "invalidEmail": "يرجى إدخال بريد إلكتروني صحيح",
    "passwordTooShort": "كلمة المرور يجب أن لا تقل عن 6 أحرف",
    "passwordsDoNotMatch": "كلمتا المرور غير متطابقتين",
    "nameRequired": "الاسم الكامل مطلوب"
  };

  // Base French strings
  final baseFr = {
    "appTitle": "Politia",
    "welcomeMessage": "Bienvenue sur Politia",
    "statusRunning": "Moteur de plateforme opérationnel",
    "changeLanguage": "Langue",
    "welcomeBack": "Bienvenue à nouveau",
    "signIn": "SE CONNECTER",
    "signUp": "S'INSCRIRE",
    "helloSignIn": "Bonjour\nConnectez-vous!",
    "createYourAccount": "Créez votre\ncompte",
    "email": "E-mail",
    "emailOrUsername": "E-mail ou nom d'utilisateur",
    "phoneOrEmail": "Téléphone ou E-mail",
    "password": "Mot de passe",
    "confirmPassword": "Confirmez le mot de passe",
    "fullName": "Nom complet",
    "forgotPassword": "Mot de passe oublié?",
    "dontHaveAccount": "Vous n'avez pas de compte?",
    "alreadyHaveAccount": "Vous avez déjà un compte?",
    "invalidEmail": "Veuillez saisir un e-mail valide",
    "passwordTooShort": "Le mot de passe doit comporter au moins 6 caractères",
    "passwordsDoNotMatch": "Les mots de passe ne correspondent pas",
    "nameRequired": "Le nom complet est requis"
  };

  // Base Spanish strings
  final baseEs = {
    "appTitle": "Politia",
    "welcomeMessage": "Bienvenido a Politia",
    "statusRunning": "Motor de plataforma y localización operativos",
    "changeLanguage": "Idioma",
    "welcomeBack": "Bienvenido de nuevo",
    "signIn": "INICIAR SESIÓN",
    "signUp": "REGISTRARSE",
    "helloSignIn": "¡Hola!\nInicia sesión",
    "createYourAccount": "Crea tu\ncuenta",
    "email": "Correo electrónico",
    "emailOrUsername": "Correo o nombre de usuario",
    "phoneOrEmail": "Teléfono o correo",
    "password": "Contraseña",
    "confirmPassword": "Confirmar contraseña",
    "fullName": "Nombre completo",
    "forgotPassword": "¿Olvidaste tu contraseña?",
    "dontHaveAccount": "¿No tienes una cuenta?",
    "alreadyHaveAccount": "¿Ya tienes una cuenta?",
    "invalidEmail": "Por favor ingresa un correo válido",
    "passwordTooShort": "La contraseña debe tener al menos 6 caracteres",
    "passwordsDoNotMatch": "Las contraseñas no coinciden",
    "nameRequired": "El nombre completo es obligatorio"
  };

  // Base German strings
  final baseDe = {
    "appTitle": "Politia",
    "welcomeMessage": "Willkommen bei Politia",
    "statusRunning": "Plattform-Engine & Lokalisierung einsatzbereit",
    "changeLanguage": "Sprache",
    "welcomeBack": "Willkommen zurück",
    "signIn": "ANMELDEN",
    "signUp": "REGISTRIEREN",
    "helloSignIn": "Hallo!\nMelde dich an",
    "createYourAccount": "Erstelle dein\nKonto",
    "email": "E-Mail",
    "emailOrUsername": "E-Mail oder Benutzername",
    "phoneOrEmail": "Telefon oder E-Mail",
    "password": "Passwort",
    "confirmPassword": "Passwort bestätigen",
    "fullName": "Vollständiger Name",
    "forgotPassword": "Passwort vergessen?",
    "dontHaveAccount": "Noch kein Konto?",
    "alreadyHaveAccount": "Bereits registriert?",
    "invalidEmail": "Bitte eine gültige E-Mail eingeben",
    "passwordTooShort": "Passwort muss mindestens 6 Zeichen lang sein",
    "passwordsDoNotMatch": "Passwörter stimmen nicht überein",
    "nameRequired": "Vollständiger Name erforderlich"
  };

  // Base Portuguese strings
  final basePt = {
    "appTitle": "Politia",
    "welcomeMessage": "Bem-vindo ao Politia",
    "statusRunning": "Motor da plataforma e localização operacionais",
    "changeLanguage": "Idioma",
    "welcomeBack": "Bem-vindo de volta",
    "signIn": "ENTRAR",
    "signUp": "CADASTRAR",
    "helloSignIn": "Olá!\nEntre na sua conta",
    "createYourAccount": "Crie sua\nconta",
    "email": "E-mail",
    "emailOrUsername": "E-mail ou nome de usuário",
    "phoneOrEmail": "Telefone ou E-mail",
    "password": "Senha",
    "confirmPassword": "Confirmar senha",
    "fullName": "Nome completo",
    "forgotPassword": "Esqueceu a senha?",
    "dontHaveAccount": "Não tem uma conta?",
    "alreadyHaveAccount": "Já tem uma conta?",
    "invalidEmail": "Insira um e-mail válido",
    "passwordTooShort": "A senha deve ter pelo menos 6 caracteres",
    "passwordsDoNotMatch": "As senhas não coincidem",
    "nameRequired": "Nome completo é obrigatório"
  };

  // Base Italian strings
  final baseIt = {
    "appTitle": "Politia",
    "welcomeMessage": "Benvenuto su Politia",
    "statusRunning": "Motore della piattaforma operativo",
    "changeLanguage": "Lingua",
    "welcomeBack": "Bentornato",
    "signIn": "ACCEDI",
    "signUp": "REGISTRATI",
    "helloSignIn": "Ciao!\nAccedi",
    "createYourAccount": "Crea il tuo\naccount",
    "email": "Email",
    "emailOrUsername": "Email o nome utente",
    "phoneOrEmail": "Telefono o Email",
    "password": "Password",
    "confirmPassword": "Conferma password",
    "fullName": "Nome completo",
    "forgotPassword": "Password dimenticata?",
    "dontHaveAccount": "Non hai un account?",
    "alreadyHaveAccount": "Hai già un account?",
    "invalidEmail": "Inserisci un'email valida",
    "passwordTooShort": "La password deve contenere almeno 6 caratteri",
    "passwordsDoNotMatch": "Le password non corrispondono",
    "nameRequired": "Il nome completo è obbligatorio"
  };

  // Base Dutch strings
  final baseNl = {
    "appTitle": "Politia",
    "welcomeMessage": "Welkom bij Politia",
    "statusRunning": "Platformengine en lokalisatie operationeel",
    "changeLanguage": "Taal",
    "welcomeBack": "Welkom terug",
    "signIn": "INLOGGEN",
    "signUp": "REGISTREREN",
    "helloSignIn": "Hallo!\nLog in",
    "createYourAccount": "Maak jouw\naccount aan",
    "email": "E-mail",
    "emailOrUsername": "E-mail of gebruikersnaam",
    "phoneOrEmail": "Telefoon of E-mail",
    "password": "Wachtwoord",
    "confirmPassword": "Bevestig wachtwoord",
    "fullName": "Volledige naam",
    "forgotPassword": "Wachtwoord vergeten?",
    "dontHaveAccount": "Nog geen account?",
    "alreadyHaveAccount": "Heb je al een account?",
    "invalidEmail": "Voer een geldig e-mailadres in",
    "passwordTooShort": "Wachtwoord moet minimaal 6 tekens bevatten",
    "passwordsDoNotMatch": "Wachtwoorden komen niet overeen",
    "nameRequired": "Volledige naam is verplicht"
  };

  // Base Russian strings
  final baseRu = {
    "appTitle": "Politia",
    "welcomeMessage": "Добро пожаловать в Politia",
    "statusRunning": "Платформа и локализация работают стабильно",
    "changeLanguage": "Язык",
    "welcomeBack": "С возвращением",
    "signIn": "ВОЙТИ",
    "signUp": "РЕГИСТРАЦИЯ",
    "helloSignIn": "Привет!\nВойдите в аккаунт",
    "createYourAccount": "Создайте свой\nаккаунт",
    "email": "Эл. почта",
    "emailOrUsername": "Эл. почта или имя пользователя",
    "phoneOrEmail": "Телефон или эл. почта",
    "password": "Пароль",
    "confirmPassword": "Подтвердите пароль",
    "fullName": "Полное имя",
    "forgotPassword": "Забыли пароль?",
    "dontHaveAccount": "Нет аккаунта?",
    "alreadyHaveAccount": "Уже есть аккаунт?",
    "invalidEmail": "Введите корректный адрес эл. почты",
    "passwordTooShort": "Пароль должен быть не менее 6 символов",
    "passwordsDoNotMatch": "Пароли не совпадают",
    "nameRequired": "Требуется указать полное имя"
  };

  // Base Chinese Simplified
  final baseZhHans = {
    "appTitle": "Politia",
    "welcomeMessage": "欢迎使用 Politia",
    "statusRunning": "平台引擎与本地化运行正常",
    "changeLanguage": "语言",
    "welcomeBack": "欢迎回来",
    "signIn": "登录",
    "signUp": "注册",
    "helloSignIn": "您好！\n请登录",
    "createYourAccount": "创建您的\n账户",
    "email": "电子邮箱",
    "emailOrUsername": "电子邮箱或用户名",
    "phoneOrEmail": "手机号或邮箱",
    "password": "密码",
    "confirmPassword": "确认密码",
    "fullName": "全名",
    "forgotPassword": "忘记密码？",
    "dontHaveAccount": "还没有账号？",
    "alreadyHaveAccount": "已有账号？",
    "invalidEmail": "请输入有效的电子邮箱",
    "passwordTooShort": "密码长度至少为 6 位",
    "passwordsDoNotMatch": "两次输入的密码不一致",
    "nameRequired": "请输入全名"
  };

  // Base Chinese Traditional
  final baseZhHant = {
    "appTitle": "Politia",
    "welcomeMessage": "歡迎使用 Politia",
    "statusRunning": "平台引擎與本地化運行正常",
    "changeLanguage": "語言",
    "welcomeBack": "歡迎回來",
    "signIn": "登入",
    "signUp": "註冊",
    "helloSignIn": "您好！\n請登入",
    "createYourAccount": "建立您的\n帳戶",
    "email": "電子郵件",
    "emailOrUsername": "電子郵件或使用者名稱",
    "phoneOrEmail": "電話或電子郵件",
    "password": "密碼",
    "confirmPassword": "確認密碼",
    "fullName": "全名",
    "forgotPassword": "忘記密碼？",
    "dontHaveAccount": "還沒有帳號？",
    "alreadyHaveAccount": "已有帳號？",
    "invalidEmail": "請輸入有效的電子郵件",
    "passwordTooShort": "密碼長度至少為 6 位",
    "passwordsDoNotMatch": "兩次輸入的密碼不相符",
    "nameRequired": "請輸入全名"
  };

  // Base Japanese
  final baseJa = {
    "appTitle": "Politia",
    "welcomeMessage": "Politia へようこそ",
    "statusRunning": "プラットフォームエンジンとローカリゼーションが稼働中",
    "changeLanguage": "言語",
    "welcomeBack": "お帰りなさい",
    "signIn": "サインイン",
    "signUp": "新規登録",
    "helloSignIn": "こんにちは！\nサインイン",
    "createYourAccount": "アカウントを\n作成する",
    "email": "メールアドレス",
    "emailOrUsername": "メールアドレスまたはユーザー名",
    "phoneOrEmail": "電話番号またはメールアドレス",
    "password": "パスワード",
    "confirmPassword": "パスワードの確認",
    "fullName": "氏名",
    "forgotPassword": "パスワードをお忘れですか？",
    "dontHaveAccount": "アカウントをお持ちでないですか？",
    "alreadyHaveAccount": "すでにアカウントをお持ちですか？",
    "invalidEmail": "有効なメールアドレスを入力してください",
    "passwordTooShort": "パスワードは6文字以上である必要があります",
    "passwordsDoNotMatch": "パスワードが一致しません",
    "nameRequired": "氏名を入力してください"
  };

  // Base Korean
  final baseKo = {
    "appTitle": "Politia",
    "welcomeMessage": "Politia에 오신 것을 환영합니다",
    "statusRunning": "플랫폼 엔진 및 현지화 정상 작동 중",
    "changeLanguage": "언어",
    "welcomeBack": "다시 오신 것을 환영합니다",
    "signIn": "로그인",
    "signUp": "회원가입",
    "helloSignIn": "안녕하세요!\n로그인하세요",
    "createYourAccount": "계정을\n생성하세요",
    "email": "이메일",
    "emailOrUsername": "이메일 또는 사용자 이름",
    "phoneOrEmail": "전화번호 또는 이메일",
    "password": "비밀번호",
    "confirmPassword": "비밀번호 확인",
    "fullName": "성명",
    "forgotPassword": "비밀번호를 잊으셨나요?",
    "dontHaveAccount": "계정이 없으신가요?",
    "alreadyHaveAccount": "이미 계정이 있으신가요?",
    "invalidEmail": "올바른 이메일을 입력하세요",
    "passwordTooShort": "비밀번호는 최소 6자 이상이어야 합니다",
    "passwordsDoNotMatch": "비밀번호가 일치하지 않습니다",
    "nameRequired": "성명을 입력해야 합니다"
  };

  // Base Hindi
  final baseHi = {
    "appTitle": "Politia",
    "welcomeMessage": "Politia में आपका स्वागत है",
    "statusRunning": "प्लेटफ़ॉर्म इंजन और स्थानीयकरण सक्रिय है",
    "changeLanguage": "भाषा",
    "welcomeBack": "वापसी पर स्वागत है",
    "signIn": "साइन इन करें",
    "signUp": "साइन अप करें",
    "helloSignIn": "नमस्ते!\nसाइन इन करें",
    "createYourAccount": "अपना खाता\nबनाएं",
    "email": "ईमेल",
    "emailOrUsername": "ईमेल या उपयोगकर्ता नाम",
    "phoneOrEmail": "फ़ोन या ईमेल",
    "password": "पासवर्ड",
    "confirmPassword": "पासवर्ड की पुष्टि करें",
    "fullName": "पूरा नाम",
    "forgotPassword": "पासवर्ड भूल गए?",
    "dontHaveAccount": "खाता नहीं है?",
    "alreadyHaveAccount": "पहले से खाता है?",
    "invalidEmail": "कृपया एक मान्य ईमेल दर्ज करें",
    "passwordTooShort": "पासवर्ड कम से कम 6 अक्षरों का होना चाहिए",
    "passwordsDoNotMatch": "पासवर्ड मेल नहीं खाते",
    "nameRequired": "पूरा नाम आवश्यक है"
  };

  // Base Turkish
  final baseTr = {
    "appTitle": "Politia",
    "welcomeMessage": "Politia'ya Hoş Geldiniz",
    "statusRunning": "Platform Motoru ve Yerelleştirme Çalışıyor",
    "changeLanguage": "Dil",
    "welcomeBack": "Tekrar Hoş Geldiniz",
    "signIn": "GİRİŞ YAP",
    "signUp": "KAYIT OL",
    "helloSignIn": "Merhaba!\nGiriş Yapın",
    "createYourAccount": "Hesabınızı\nOluşturun",
    "email": "E-posta",
    "emailOrUsername": "E-posta veya Kullanıcı Adı",
    "phoneOrEmail": "Telefon veya E-posta",
    "password": "Şifre",
    "confirmPassword": "Şifreyi Onayla",
    "fullName": "Tam İsim",
    "forgotPassword": "Şifrenizi mi unuttunuz?",
    "dontHaveAccount": "Hesabınız yok mu?",
    "alreadyHaveAccount": "Zaten hesabınız var mı?",
    "invalidEmail": "Lütfen geçerli bir e-posta girin",
    "passwordTooShort": "Şifre en az 6 karakter olmalıdır",
    "passwordsDoNotMatch": "Şifreler eşleşmiyor",
    "nameRequired": "Tam isim gereklidir"
  };

  // Base Greek
  final baseEl = {
    "appTitle": "Politia",
    "welcomeMessage": "Καλώς ήρθατε στο Politia",
    "statusRunning": "Η μηχανή πλατφόρμας λειτουργεί κανονικά",
    "changeLanguage": "Γλώσσα",
    "welcomeBack": "Καλώς ήρθατε πίσω",
    "signIn": "ΣΥΝΔΕΣΗ",
    "signUp": "ΕΓΓΡΑΦΗ",
    "helloSignIn": "Γεια σας!\nΣυνδεθείτε",
    "createYourAccount": "Δημιουργήστε τον\nλογαριασμό σας",
    "email": "Email",
    "emailOrUsername": "Email ή Όνομα χρήστη",
    "phoneOrEmail": "Τηλέφωνο ή Email",
    "password": "Κωδικός πρόσβασης",
    "confirmPassword": "Επιβεβαίωση κωδικού",
    "fullName": "Ονοματεπώνυμο",
    "forgotPassword": "Ξεχάσατε τον κωδικό πρόσβασης;",
    "dontHaveAccount": "Δεν έχετε λογαριασμό;",
    "alreadyHaveAccount": "Έχετε ήδη λογαριασμό;",
    "invalidEmail": "Παρακαλούμε εισάγετε ένα έγκυρο email",
    "passwordTooShort": "Ο κωδικός πρέπει να έχει τουλάχιστον 6 χαρακτήρες",
    "passwordsDoNotMatch": "Οι κωδικοί πρόσβασης δεν ταιριάζουν",
    "nameRequired": "Το ονοματεπώνυμο είναι απαραίτητο"
  };

  // Base Coptic
  final baseCop = {
    "appTitle": "Politia",
    "welcomeMessage": "Ⲛⲟϥⲣⲓ ϧⲉⲛ Politia",
    "statusRunning": "Platform Engine Operational",
    "changeLanguage": "Ϯⲁⲥⲡⲓ",
    "welcomeBack": "Ⲛⲟϥⲣⲓ ⲟⲛ",
    "signIn": "Ϣⲉ ⲉϧⲟⲩⲛ",
    "signUp": "Ⲑⲁⲙⲓⲟ ⲛ̀ⲟⲩϩⲩⲡⲟⲧⲁⲥⲓⲥ",
    "helloSignIn": "Ⲛⲟϥⲣⲓ\nϢⲉ ⲉϧⲟⲩⲛ!",
    "createYourAccount": "Ⲑⲁⲙⲓⲟ\nⲛ̀ⲧⲉⲕϩⲩⲡⲟⲧⲁⲥⲓⲥ",
    "email": "Email",
    "emailOrUsername": "Email / Ⲣⲁⲛ",
    "phoneOrEmail": "Phone / Email",
    "password": "Password",
    "confirmPassword": "Confirm Password",
    "fullName": "Ⲣⲁⲛ ⲧⲏⲣϥ",
    "forgotPassword": "Forgot password?",
    "dontHaveAccount": "Don't have an account?",
    "alreadyHaveAccount": "Already have an account?",
    "invalidEmail": "Please enter a valid email",
    "passwordTooShort": "Password must be at least 6 characters",
    "passwordsDoNotMatch": "Passwords do not match",
    "nameRequired": "Name is required"
  };

  // Base Syriac
  final baseSyc = {
    "appTitle": "Politia",
    "welcomeMessage": "ܒܫܝܢܐ ܠ Politia",
    "statusRunning": "Platform Engine Operational",
    "changeLanguage": "ܠܫܢܐ",
    "welcomeBack": "ܒܫܝܢܐ ܡܢ ܪܝܫ",
    "signIn": "ܥܘܠ",
    "signUp": "ܥܒܕ ܚܘܫܒܢܐ",
    "helloSignIn": "ܫܠܡܐ\nܥܘܠ!",
    "createYourAccount": "ܥܒܕ\nܚܘܫܒܢܟ",
    "email": "Email",
    "emailOrUsername": "Email / ܫܡܐ",
    "phoneOrEmail": "Phone / Email",
    "password": "Password",
    "confirmPassword": "Confirm Password",
    "fullName": "ܫܡܐ ܟܠܗ",
    "forgotPassword": "Forgot password?",
    "dontHaveAccount": "Don't have an account?",
    "alreadyHaveAccount": "Already have an account?",
    "invalidEmail": "Please enter a valid email",
    "passwordTooShort": "Password must be at least 6 characters",
    "passwordsDoNotMatch": "Passwords do not match",
    "nameRequired": "Name is required"
  };

  // Base Aramaic
  final baseArc = {
    "appTitle": "Politia",
    "welcomeMessage": "שלמא ב Politia",
    "statusRunning": "Platform Engine Operational",
    "changeLanguage": "לשנא",
    "welcomeBack": "שלמא תו",
    "signIn": "עול",
    "signUp": "ברי חשבונא",
    "helloSignIn": "שלמא\nעול!",
    "createYourAccount": "ברי\nחשבונך",
    "email": "Email",
    "emailOrUsername": "Email / שמא",
    "phoneOrEmail": "Phone / Email",
    "password": "Password",
    "confirmPassword": "Confirm Password",
    "fullName": "שמא כלה",
    "forgotPassword": "Forgot password?",
    "dontHaveAccount": "Don't have an account?",
    "alreadyHaveAccount": "Already have an account?",
    "invalidEmail": "Please enter a valid email",
    "passwordTooShort": "Password must be at least 6 characters",
    "passwordsDoNotMatch": "Passwords do not match",
    "nameRequired": "Name is required"
  };

  // All 131 locales
  final allTags = [
    // 1. Liturgical & Biblical Languages (4)
    'arc',
    'cop', // base
    'cop_EG',
    'syc',

    // 2. Arabic (16 Locales) + base
    'ar',
    'ar_AE',
    'ar_BH',
    'ar_DZ',
    'ar_EG',
    'ar_IQ',
    'ar_JO',
    'ar_KW',
    'ar_LB',
    'ar_LY',
    'ar_MA',
    'ar_OM',
    'ar_QA',
    'ar_SA',
    'ar_SY',
    'ar_TN',
    'ar_YE',

    // Spanish (20 Locales) + base
    'es',
    'es_AR',
    'es_BO',
    'es_CL',
    'es_CO',
    'es_CR',
    'es_DO',
    'es_EC',
    'es_ES',
    'es_GT',
    'es_HN',
    'es_MX',
    'es_NI',
    'es_PA',
    'es_PE',
    'es_PR',
    'es_PY',
    'es_SV',
    'es_US',
    'es_UY',
    'es_VE',

    // English (9 Locales) + base
    'en',
    'en_AU',
    'en_CA',
    'en_GB',
    'en_IE',
    'en_IN',
    'en_NZ',
    'en_SG',
    'en_US',
    'en_ZA',

    // French (5 Locales) + base
    'fr',
    'fr_BE',
    'fr_CA',
    'fr_CH',
    'fr_FR',
    'fr_LU',

    // Chinese (4 Locales) + base
    'zh',
    'zh_CN',
    'zh_HK',
    'zh_SG',
    'zh_TW',

    // German (3 Locales) + base
    'de',
    'de_AT',
    'de_CH',
    'de_DE',

    // Portuguese (2 Locales) + base
    'pt',
    'pt_BR',
    'pt_PT',

    // Italian (2 Locales) + base
    'it',
    'it_CH',
    'it_IT',

    // Dutch (2 Locales) + base
    'nl',
    'nl_BE',
    'nl_NL',

    // Bengali & Tamil (4 Locales) + base
    'bn',
    'bn_BD',
    'bn_IN',
    'ta',
    'ta_IN',
    'ta_LK',

    // 3. European & Regional Locales (34)
    'af', 'af_ZA',
    'sq', 'sq_AL',
    'hy', 'hy_AM',
    'az', 'az_AZ',
    'eu', 'eu_ES',
    'be', 'be_BY',
    'bs', 'bs_BA',
    'bg', 'bg_BG',
    'ca', 'ca_ES',
    'hr', 'hr_HR',
    'cs', 'cs_CZ',
    'da', 'da_DK',
    'et', 'et_EE',
    'fi', 'fi_FI',
    'gl', 'gl_ES',
    'ka', 'ka_GE',
    'el', 'el_GR',
    'hu', 'hu_HU',
    'is', 'is_IS',
    'lv', 'lv_LV',
    'lt', 'lt_LT',
    'mk', 'mk_MK',
    'nb', 'nb_NO',
    'pl', 'pl_PL',
    'ro', 'ro_RO',
    'ru', 'ru_RU',
    'sr', 'sr_RS',
    'sk', 'sk_SK',
    'sl', 'sl_SI',
    'sv', 'sv_SE',
    'tr', 'tr_TR',
    'uk', 'uk_UA',
    'uz', 'uz_UZ',
    'cy', 'cy_GB',

    // 4. Asian, Middle Eastern & African Locales (28)
    'am', 'am_ET',
    'my', 'my_MM',
    'fil', 'fil_PH',
    'gu', 'gu_IN',
    'he', 'he_IL',
    'hi', 'hi_IN',
    'id', 'id_ID',
    'ja', 'ja_JP',
    'kn', 'kn_IN',
    'kk', 'kk_KZ',
    'km', 'km_KH',
    'ko', 'ko_KR',
    'lo', 'lo_LA',
    'ms', 'ms_MY',
    'ml', 'ml_IN',
    'mr', 'mr_IN',
    'mn', 'mn_MN',
    'ne', 'ne_NP',
    'fa', 'fa_IR',
    'pa', 'pa_IN',
    'si', 'si_LK',
    'sw', 'sw_KE',
    'te', 'te_IN',
    'th', 'th_TH',
    'ur', 'ur_PK',
    'vi', 'vi_VN',
  ];

  final uniqueTags = allTags.toSet();

  for (final tag in uniqueTags) {
    final fileName = 'app_$tag.arb';
    final file = File('lib/l10n/$fileName');

    final baseLang = tag.split('_').first;

    Map<String, dynamic> sourceStrings;
    if (baseLang == 'ar') {
      sourceStrings = baseAr;
    } else if (baseLang == 'fr') {
      sourceStrings = baseFr;
    } else if (baseLang == 'es') {
      sourceStrings = baseEs;
    } else if (baseLang == 'de') {
      sourceStrings = baseDe;
    } else if (baseLang == 'pt') {
      sourceStrings = basePt;
    } else if (baseLang == 'it') {
      sourceStrings = baseIt;
    } else if (baseLang == 'nl') {
      sourceStrings = baseNl;
    } else if (baseLang == 'ru') {
      sourceStrings = baseRu;
    } else if (tag == 'zh_CN' || tag == 'zh_SG' || tag == 'zh') {
      sourceStrings = baseZhHans;
    } else if (tag == 'zh_HK' || tag == 'zh_TW') {
      sourceStrings = baseZhHant;
    } else if (baseLang == 'ja') {
      sourceStrings = baseJa;
    } else if (baseLang == 'ko') {
      sourceStrings = baseKo;
    } else if (baseLang == 'hi') {
      sourceStrings = baseHi;
    } else if (baseLang == 'tr') {
      sourceStrings = baseTr;
    } else if (baseLang == 'el') {
      sourceStrings = baseEl;
    } else if (baseLang == 'cop') {
      sourceStrings = baseCop;
    } else if (baseLang == 'syc') {
      sourceStrings = baseSyc;
    } else if (baseLang == 'arc') {
      sourceStrings = baseArc;
    } else {
      sourceStrings = baseEn;
    }

    final Map<String, dynamic> arbContent = {
      "@@locale": tag,
    };

    if (tag == 'en') {
      // Add metadata for template arb
      for (final entry in sourceStrings.entries) {
        arbContent[entry.key] = entry.value;
        arbContent['@${entry.key}'] = {
          "description": "Localization for ${entry.key}"
        };
      }
    } else {
      for (final entry in sourceStrings.entries) {
        arbContent[entry.key] = entry.value;
      }
    }

    // Preserve special customizations if file already has them
    if (tag == 'ar_EG') {
      arbContent['welcomeMessage'] = "أهلاً بك في بوليتيا (مصر)";
      arbContent['statusRunning'] = "محرك المنصة يعمل بنجاح (مصر)";
      arbContent['phoneOrEmail'] = "رقم الموبايل أو البريد الإلكتروني";
      arbContent['password'] = "كلمة السر";
      arbContent['confirmPassword'] = "تأكيد كلمة السر";
      arbContent['fullName'] = "الاسم بالكامل";
      arbContent['forgotPassword'] = "نسيت كلمة السر؟";
      arbContent['passwordTooShort'] = "كلمة السر يجب أن لا تقل عن 6 أحرف";
      arbContent['passwordsDoNotMatch'] = "كلمتا السر غير متطابقتين";
      arbContent['nameRequired'] = "الاسم بالكامل مطلوب";
    }

    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(arbContent));
  }

  print('Successfully created ARB files for ${uniqueTags.length} locales.');
}
