/// Uygulama asset yolları
class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';
  static const String _soundsPath = 'assets/sounds';

  // Images
  static const String logo = '$_imagesPath/logo.png';
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  // Life Tree Images
  static const String treeSprout = '$_imagesPath/tree_sprout.png';
  static const String treeGrowing = '$_imagesPath/tree_growing.png';
  static const String treeMature = '$_imagesPath/tree_mature.png';
  static const String treeFlourishing = '$_imagesPath/tree_flourishing.png';

  // Icons
  static const String iconHome = '$_iconsPath/home.svg';
  static const String iconAnalytics = '$_iconsPath/analytics.svg';
  static const String iconLibrary = '$_iconsPath/library.svg';
  static const String iconCommunity = '$_iconsPath/community.svg';
  static const String iconProfile = '$_iconsPath/profile.svg';

  // Animations (Lottie)
  static const String animLoading = '$_animationsPath/loading.json';
  static const String animSuccess = '$_animationsPath/success.json';
  static const String animBreathing = '$_animationsPath/breathing.json';
  static const String animTree = '$_animationsPath/tree.json';
  static const String animFire = '$_animationsPath/fire.json';

  // Sounds
  static const String soundOcean = '$_soundsPath/ocean.mp3';
  static const String soundRain = '$_soundsPath/rain.mp3';
  static const String soundForest = '$_soundsPath/forest.mp3';
  static const String soundDeepOcean = '$_soundsPath/deep_ocean.mp3';
  static const String soundNotification = '$_soundsPath/notification.mp3';
}
