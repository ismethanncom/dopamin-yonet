import '../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Stability Score modeli - İstikrar puanı
class StabilityScoreModel {
  final String id;
  final DateTime date;
  final int sleepScore; // Uyku kalitesi (0-100)
  final int eatingScore; // Beslenme düzeni (0-100)
  final int urgeIntensity; // İstek yoğunluğu (0-100, düşük = iyi)
  final int phoneUsageScore; // Telefon kullanım kontrolü (0-100)
  final int emotionalScore; // Duygusal denge (0-100)
  final int focusScore; // Odak seviyesi (0-100)

  StabilityScoreModel({
    required this.id,
    required this.date,
    required this.sleepScore,
    required this.eatingScore,
    required this.urgeIntensity,
    required this.phoneUsageScore,
    required this.emotionalScore,
    required this.focusScore,
  });

  /// Toplam stability score hesaplar
  int get totalScore {
    final adjustedUrge = 100 - urgeIntensity; // Düşük istek = yüksek puan
    final total = sleepScore +
        eatingScore +
        adjustedUrge +
        phoneUsageScore +
        emotionalScore +
        focusScore;
    return (total / 6).round().clamp(0, 100);
  }

  /// Seviye metni
  String get level {
    if (totalScore >= 80) return 'Mükemmel';
    if (totalScore >= 60) return 'İyi';
    if (totalScore >= 40) return 'Orta';
    if (totalScore >= 20) return 'Düşük';
    return 'Kritik';
  }

  /// Seviye rengi
  Color get levelColor {
    return AppColors.getStabilityColor(totalScore);
  }

  /// En zayıf alan
  String get weakestArea {
    final scores = {
      'Uyku': sleepScore,
      'Beslenme': eatingScore,
      'İstek Kontrolü': 100 - urgeIntensity,
      'Telefon Kullanımı': phoneUsageScore,
      'Duygusal Denge': emotionalScore,
      'Odak': focusScore,
    };

    final weakest = scores.entries.reduce(
      (a, b) => a.value < b.value ? a : b,
    );
    return weakest.key;
  }

  /// En güçlü alan
  String get strongestArea {
    final scores = {
      'Uyku': sleepScore,
      'Beslenme': eatingScore,
      'İstek Kontrolü': 100 - urgeIntensity,
      'Telefon Kullanımı': phoneUsageScore,
      'Duygusal Denge': emotionalScore,
      'Odak': focusScore,
    };

    final strongest = scores.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return strongest.key;
  }

  StabilityScoreModel copyWith({
    String? id,
    DateTime? date,
    int? sleepScore,
    int? eatingScore,
    int? urgeIntensity,
    int? phoneUsageScore,
    int? emotionalScore,
    int? focusScore,
  }) {
    return StabilityScoreModel(
      id: id ?? this.id,
      date: date ?? this.date,
      sleepScore: sleepScore ?? this.sleepScore,
      eatingScore: eatingScore ?? this.eatingScore,
      urgeIntensity: urgeIntensity ?? this.urgeIntensity,
      phoneUsageScore: phoneUsageScore ?? this.phoneUsageScore,
      emotionalScore: emotionalScore ?? this.emotionalScore,
      focusScore: focusScore ?? this.focusScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'sleepScore': sleepScore,
        'eatingScore': eatingScore,
        'urgeIntensity': urgeIntensity,
        'phoneUsageScore': phoneUsageScore,
        'emotionalScore': emotionalScore,
        'focusScore': focusScore,
      };

  factory StabilityScoreModel.fromJson(Map<String, dynamic> json) {
    return StabilityScoreModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      sleepScore: json['sleepScore'],
      eatingScore: json['eatingScore'],
      urgeIntensity: json['urgeIntensity'],
      phoneUsageScore: json['phoneUsageScore'],
      emotionalScore: json['emotionalScore'],
      focusScore: json['focusScore'],
    );
  }

  /// Varsayılan boş model
  factory StabilityScoreModel.empty() {
    return StabilityScoreModel(
      id: '',
      date: DateTime.now(),
      sleepScore: 50,
      eatingScore: 50,
      urgeIntensity: 50,
      phoneUsageScore: 50,
      emotionalScore: 50,
      focusScore: 50,
    );
  }
}
