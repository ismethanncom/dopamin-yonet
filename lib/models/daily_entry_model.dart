/// Günlük giriş modeli - Dopamin Günlüğü
class DailyEntryModel {
  final String id;
  final DateTime date;
  final int energyLevel; // 0-100
  final int focusLevel; // 0-100
  final int desireLevel; // İstek seviyesi 0-100
  final int anxietyLevel; // 0-100
  final int motivationLevel; // 0-100
  final String? note; // Kısa not (20-100 karakter)
  final List<String> completedTasks; // Tamamlanan mini görevler
  final bool hadUrge; // Bugün istek yaşandı mı
  final bool resistedUrge; // İsteğe direnildi mi
  final DateTime? createdAt;

  DailyEntryModel({
    required this.id,
    required this.date,
    required this.energyLevel,
    required this.focusLevel,
    required this.desireLevel,
    required this.anxietyLevel,
    required this.motivationLevel,
    this.note,
    this.completedTasks = const [],
    this.hadUrge = false,
    this.resistedUrge = false,
    this.createdAt,
  });

  /// Genel dopamin skoru hesaplar
  int get dopamineScore {
    // Yüksek enerji, odak, motivasyon = iyi
    // Düşük istek, anksiyete = iyi
    final positives = energyLevel + focusLevel + motivationLevel;
    final negatives = (100 - desireLevel) + (100 - anxietyLevel);
    return ((positives + negatives) / 5).round().clamp(0, 100);
  }

  /// Verimli gün mü kontrol eder
  /// Kriterler:
  /// 1. En az bir mini görev tamamlanmış
  /// 2. Dopamin skoru 50 üzeri
  /// 3. İstek yaşanmadı VEYA direnildi
  bool get isProductiveDay {
    final hasCompletedTask = completedTasks.isNotEmpty;
    final goodScore = dopamineScore >= 50;
    final managedUrge = !hadUrge || resistedUrge;

    // 3 kriterden en az 2'si karşılanmalı
    int metCriteria = 0;
    if (hasCompletedTask) metCriteria++;
    if (goodScore) metCriteria++;
    if (managedUrge) metCriteria++;

    return metCriteria >= 2;
  }

  /// Gün durumu açıklaması
  String get dayStatus {
    if (dopamineScore >= 80) return 'Harika bir gün!';
    if (dopamineScore >= 60) return 'İyi gidiyorsun';
    if (dopamineScore >= 40) return 'Orta seviye';
    if (dopamineScore >= 20) return 'Zor bir gün';
    return 'Desteğe ihtiyacın var';
  }

  /// En güçlü alan
  String get strongestArea {
    final scores = {
      'Enerji': energyLevel,
      'Odak': focusLevel,
      'Motivasyon': motivationLevel,
      'Sakinlik': 100 - anxietyLevel,
      'Kontrol': 100 - desireLevel,
    };

    final strongest = scores.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return strongest.key;
  }

  /// En zayıf alan
  String get weakestArea {
    final scores = {
      'Enerji': energyLevel,
      'Odak': focusLevel,
      'Motivasyon': motivationLevel,
      'Sakinlik': 100 - anxietyLevel,
      'Kontrol': 100 - desireLevel,
    };

    final weakest = scores.entries.reduce(
      (a, b) => a.value < b.value ? a : b,
    );
    return weakest.key;
  }

  DailyEntryModel copyWith({
    String? id,
    DateTime? date,
    int? energyLevel,
    int? focusLevel,
    int? desireLevel,
    int? anxietyLevel,
    int? motivationLevel,
    String? note,
    List<String>? completedTasks,
    bool? hadUrge,
    bool? resistedUrge,
    DateTime? createdAt,
  }) {
    return DailyEntryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      energyLevel: energyLevel ?? this.energyLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      desireLevel: desireLevel ?? this.desireLevel,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      motivationLevel: motivationLevel ?? this.motivationLevel,
      note: note ?? this.note,
      completedTasks: completedTasks ?? this.completedTasks,
      hadUrge: hadUrge ?? this.hadUrge,
      resistedUrge: resistedUrge ?? this.resistedUrge,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'energyLevel': energyLevel,
        'focusLevel': focusLevel,
        'desireLevel': desireLevel,
        'anxietyLevel': anxietyLevel,
        'motivationLevel': motivationLevel,
        'note': note,
        'completedTasks': completedTasks,
        'hadUrge': hadUrge,
        'resistedUrge': resistedUrge,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory DailyEntryModel.fromJson(Map<String, dynamic> json) {
    return DailyEntryModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      energyLevel: json['energyLevel'],
      focusLevel: json['focusLevel'],
      desireLevel: json['desireLevel'],
      anxietyLevel: json['anxietyLevel'],
      motivationLevel: json['motivationLevel'],
      note: json['note'],
      completedTasks: List<String>.from(json['completedTasks'] ?? []),
      hadUrge: json['hadUrge'] ?? false,
      resistedUrge: json['resistedUrge'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
