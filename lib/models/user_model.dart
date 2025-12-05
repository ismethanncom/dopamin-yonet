import 'addiction_type.dart';

/// Kullanıcı modeli
class UserModel {
  final String id;
  final String? name;
  final DateTime createdAt;
  final List<AddictionType> selectedAddictions;
  final int currentLevel;
  final String levelTitle;
  final int productiveDays;
  final DateTime? lastActiveDate;
  final bool hasCompletedOnboarding;

  UserModel({
    required this.id,
    this.name,
    required this.createdAt,
    this.selectedAddictions = const [],
    this.currentLevel = 1,
    this.levelTitle = 'Filiz',
    this.productiveDays = 0,
    this.lastActiveDate,
    this.hasCompletedOnboarding = false,
  });

  /// Seviye başlıkları
  static const Map<int, String> levelTitles = {
    1: 'Filiz',
    2: 'Tomurcuk',
    3: 'Büyüyen Ağaç',
    4: 'Odaklı Birey',
    5: 'Sistem Kurucusu',
    6: 'Dopamin Ustası',
  };

  /// Seviyeye göre başlık döndürür
  static String getTitleForLevel(int level) {
    if (level >= 6) return levelTitles[6]!;
    return levelTitles[level] ?? levelTitles[1]!;
  }

  /// Sonraki seviyeye gereken gün sayısı
  int get daysToNextLevel {
    switch (currentLevel) {
      case 1:
        return 3 - productiveDays;
      case 2:
        return 7 - productiveDays;
      case 3:
        return 14 - productiveDays;
      case 4:
        return 30 - productiveDays;
      case 5:
        return 60 - productiveDays;
      default:
        return 0;
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<AddictionType>? selectedAddictions,
    int? currentLevel,
    String? levelTitle,
    int? productiveDays,
    DateTime? lastActiveDate,
    bool? hasCompletedOnboarding,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      selectedAddictions: selectedAddictions ?? this.selectedAddictions,
      currentLevel: currentLevel ?? this.currentLevel,
      levelTitle: levelTitle ?? this.levelTitle,
      productiveDays: productiveDays ?? this.productiveDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'selectedAddictions':
            selectedAddictions.map((e) => e.index).toList(),
        'currentLevel': currentLevel,
        'levelTitle': levelTitle,
        'productiveDays': productiveDays,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'hasCompletedOnboarding': hasCompletedOnboarding,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      selectedAddictions: (json['selectedAddictions'] as List)
          .map((e) => AddictionType.values[e])
          .toList(),
      currentLevel: json['currentLevel'] ?? 1,
      levelTitle: json['levelTitle'] ?? 'Filiz',
      productiveDays: json['productiveDays'] ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : null,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
    );
  }
}
