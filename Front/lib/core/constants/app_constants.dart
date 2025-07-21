class AppConstants {
  // App Info
  static const String appName = 'Anotation AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicativo inteligente para anotações com suporte a mídia';

  // Media Constants
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;
  static const int maxVideoDurationMinutes = 5;
  static const int maxAudioDurationMinutes = 10;
  static const int audioSampleRate = 44100;
  static const int audioBitRate = 128000;

  // UI Constants
  static const double defaultAnimationDuration = 300.0;
  static const double defaultPagePadding = 16.0;
  static const double defaultCardElevation = 2.0;

  // Network Constants
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String sessionsKey = 'sessions_data';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String settingsRoute = '/settings';

  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String serverErrorMessage = 'Erro no servidor. Tente novamente mais tarde.';
  static const String unknownErrorMessage = 'Erro inesperado. Tente novamente.';
  static const String validationErrorMessage = 'Dados inválidos. Verifique os campos.';
  static const String permissionErrorMessage = 'Permissões necessárias não concedidas.';

  // Success Messages
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String registerSuccessMessage = 'Conta criada com sucesso!';
  static const String saveSuccessMessage = 'Salvo com sucesso!';
  static const String deleteSuccessMessage = 'Excluído com sucesso!';

  // Validation
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;
  static const int maxSessionTitleLength = 100;
  static const int maxNoteLength = 1000;

  // File Extensions
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
  static const List<String> audioExtensions = ['mp3', 'aac', 'wav', 'ogg', 'm4a'];
}
