/// Mini görev modeli - 2 dakikalık görevler
class MiniTaskModel {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int durationMinutes;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime? completedAt;

  MiniTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.durationMinutes,
    required this.category,
    this.isCompleted = false,
    this.completedAt,
  });

  MiniTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? durationMinutes,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return MiniTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'emoji': emoji,
        'durationMinutes': durationMinutes,
        'category': category.index,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory MiniTaskModel.fromJson(Map<String, dynamic> json) {
    return MiniTaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      emoji: json['emoji'],
      durationMinutes: json['durationMinutes'],
      category: TaskCategory.values[json['category']],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  /// Varsayılan mini görevler listesi
  static List<MiniTaskModel> get defaultTasks => [
        MiniTaskModel(
          id: 'cold_water',
          title: '2 Dakika Soğuk Su',
          description: 'Yüzüne soğuk su çarp veya soğuk duş al',
          emoji: '💧',
          durationMinutes: 2,
          category: TaskCategory.physical,
        ),
        MiniTaskModel(
          id: 'reading',
          title: '10 Sayfa Okuma',
          description: 'Kitabından 10 sayfa oku',
          emoji: '📖',
          durationMinutes: 10,
          category: TaskCategory.mental,
        ),
        MiniTaskModel(
          id: 'breathing',
          title: '1 Dakika Derin Nefes',
          description: '4-7-8 nefes tekniği uygula',
          emoji: '🌬️',
          durationMinutes: 1,
          category: TaskCategory.mental,
        ),
        MiniTaskModel(
          id: 'walking',
          title: '5 Dakika Yürüyüş',
          description: 'Kısa bir yürüyüşe çık',
          emoji: '🚶',
          durationMinutes: 5,
          category: TaskCategory.physical,
        ),
        MiniTaskModel(
          id: 'journaling',
          title: 'Sabah 3 Cümle Yaz',
          description: 'Bugün için 3 niyet cümlesi yaz',
          emoji: '✍️',
          durationMinutes: 2,
          category: TaskCategory.mental,
        ),
        MiniTaskModel(
          id: 'plank',
          title: '1 Dakika Plank',
          description: 'Core kaslarını çalıştır',
          emoji: '💪',
          durationMinutes: 1,
          category: TaskCategory.physical,
        ),
        MiniTaskModel(
          id: 'stretching',
          title: '3 Dakika Esneme',
          description: 'Vücudunu esnet ve gevşet',
          emoji: '🧘',
          durationMinutes: 3,
          category: TaskCategory.physical,
        ),
        MiniTaskModel(
          id: 'meditation',
          title: '5 Dakika Meditasyon',
          description: 'Sessizce otur ve nefesine odaklan',
          emoji: '🧘‍♂️',
          durationMinutes: 5,
          category: TaskCategory.mental,
        ),
        MiniTaskModel(
          id: 'gratitude',
          title: '3 Şükür Yaz',
          description: 'Minnettar olduğun 3 şeyi yaz',
          emoji: '🙏',
          durationMinutes: 2,
          category: TaskCategory.mental,
        ),
        MiniTaskModel(
          id: 'no_phone',
          title: '30 Dakika Telefonsuz',
          description: 'Telefonunu uzağa koy',
          emoji: '📵',
          durationMinutes: 30,
          category: TaskCategory.discipline,
        ),
      ];
}

enum TaskCategory {
  physical,
  mental,
  discipline,
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.physical:
        return 'Fiziksel';
      case TaskCategory.mental:
        return 'Zihinsel';
      case TaskCategory.discipline:
        return 'Disiplin';
    }
  }
}
