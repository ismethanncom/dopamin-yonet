/// Bağımlılık türleri enum'u
enum AddictionType {
  pornography,
  socialMedia,
  gaming,
  phoneUsage,
  sugarAddiction,
  caffeineAddiction,
}

extension AddictionTypeExtension on AddictionType {
  /// Türkçe görünen isim
  String get displayName {
    switch (this) {
      case AddictionType.pornography:
        return 'Pornografi';
      case AddictionType.socialMedia:
        return 'Sosyal Medya / Reels';
      case AddictionType.gaming:
        return 'Oyun Bağımlılığı';
      case AddictionType.phoneUsage:
        return 'Aşırı Telefon Kullanımı';
      case AddictionType.sugarAddiction:
        return 'Şeker/Tatlı Bağımlılığı';
      case AddictionType.caffeineAddiction:
        return 'Kafein + Gece Uyanıklığı';
    }
  }

  /// Emoji ikonu
  String get emoji {
    switch (this) {
      case AddictionType.pornography:
        return '🔞';
      case AddictionType.socialMedia:
        return '📱';
      case AddictionType.gaming:
        return '🎮';
      case AddictionType.phoneUsage:
        return '📵';
      case AddictionType.sugarAddiction:
        return '🍬';
      case AddictionType.caffeineAddiction:
        return '☕';
    }
  }

  /// Kurtarma modu aksiyonu
  String get rescueAction {
    switch (this) {
      case AddictionType.pornography:
        return '60 saniyelik yönlendirme';
      case AddictionType.socialMedia:
        return 'Ekran dondurma';
      case AddictionType.gaming:
        return 'Oyun molası hatırlatıcı';
      case AddictionType.phoneUsage:
        return 'Focus Mode onay pop-up';
      case AddictionType.sugarAddiction:
        return '120 saniyelik geciktirme';
      case AddictionType.caffeineAddiction:
        return 'Nefes egzersizi';
    }
  }

  /// Açıklama metni
  String get description {
    switch (this) {
      case AddictionType.pornography:
        return 'Cinsel içerik tüketimi ve bağımlılığı';
      case AddictionType.socialMedia:
        return 'Instagram, TikTok, Reels gibi platformlar';
      case AddictionType.gaming:
        return 'Video oyunları ve mobil oyunlar';
      case AddictionType.phoneUsage:
        return 'Sürekli telefon kontrolü ve kullanımı';
      case AddictionType.sugarAddiction:
        return 'Tatlı ve şekerli gıda tüketimi';
      case AddictionType.caffeineAddiction:
        return 'Kahve/enerji içeceği ve uyku düzensizliği';
    }
  }

  /// Varsayılan günlük tetikleyici saatleri
  List<int> get triggerHours {
    switch (this) {
      case AddictionType.pornography:
        return [22, 23, 0, 1];
      case AddictionType.socialMedia:
        return [9, 12, 15, 21, 22];
      case AddictionType.gaming:
        return [18, 19, 20, 21, 22];
      case AddictionType.phoneUsage:
        return [8, 12, 18, 21, 22];
      case AddictionType.sugarAddiction:
        return [14, 15, 21, 22];
      case AddictionType.caffeineAddiction:
        return [9, 14, 22, 23];
    }
  }
}
