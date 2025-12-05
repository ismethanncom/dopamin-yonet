import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Hayat Ağacı widget'ı
class LifeTreeWidget extends StatelessWidget {
  final int productiveDays;
  final double size;
  final bool showLabel;

  const LifeTreeWidget({
    super.key,
    required this.productiveDays,
    this.size = 150,
    this.showLabel = true,
  });

  TreeLevel get _treeLevel {
    if (productiveDays >= 30) return TreeLevel.flourishing;
    if (productiveDays >= 15) return TreeLevel.mature;
    if (productiveDays >= 8) return TreeLevel.growing;
    if (productiveDays >= 3) return TreeLevel.small;
    return TreeLevel.sprout;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                _treeLevel.color.withOpacity(0.2),
                _treeLevel.color.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: _TreeIcon(level: _treeLevel, size: size * 0.6),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 12),
          Text(
            _treeLevel.displayName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _treeLevel.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$productiveDays verimli gün',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _TreeIcon extends StatelessWidget {
  final TreeLevel level;
  final double size;

  const _TreeIcon({required this.level, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      level.emoji,
      style: TextStyle(fontSize: size * 0.8),
    );
  }
}

enum TreeLevel {
  sprout,
  small,
  growing,
  mature,
  flourishing,
}

extension TreeLevelExtension on TreeLevel {
  String get displayName {
    switch (this) {
      case TreeLevel.sprout:
        return 'Filiz';
      case TreeLevel.small:
        return 'Küçük Ağaç';
      case TreeLevel.growing:
        return 'Büyüyen Ağaç';
      case TreeLevel.mature:
        return 'Olgun Ağaç';
      case TreeLevel.flourishing:
        return 'Çiçek Açan Ağaç';
    }
  }

  String get emoji {
    switch (this) {
      case TreeLevel.sprout:
        return '🌱';
      case TreeLevel.small:
        return '🌿';
      case TreeLevel.growing:
        return '🌳';
      case TreeLevel.mature:
        return '🌲';
      case TreeLevel.flourishing:
        return '🌸';
    }
  }

  Color get color {
    switch (this) {
      case TreeLevel.sprout:
        return AppColors.treeSprout;
      case TreeLevel.small:
        return AppColors.treeGrowing;
      case TreeLevel.growing:
        return AppColors.treeGrowing;
      case TreeLevel.mature:
        return AppColors.treeMature;
      case TreeLevel.flourishing:
        return AppColors.treeFlourishing;
    }
  }

  int get minDays {
    switch (this) {
      case TreeLevel.sprout:
        return 0;
      case TreeLevel.small:
        return 3;
      case TreeLevel.growing:
        return 8;
      case TreeLevel.mature:
        return 15;
      case TreeLevel.flourishing:
        return 30;
    }
  }

  String get description {
    switch (this) {
      case TreeLevel.sprout:
        return 'Yolculuğun yeni başlıyor. Her adım önemli.';
      case TreeLevel.small:
        return 'İlk kökler atılıyor. Devam et!';
      case TreeLevel.growing:
        return 'Dalların güçleniyor. İstikrar kazanıyorsun.';
      case TreeLevel.mature:
        return 'Olgunlaşıyorsun. Sistem kurucusu oluyorsun.';
      case TreeLevel.flourishing:
        return 'Çiçek açtın! Artık bir Dopamin Ustasısın.';
    }
  }
}

/// Kompakt Hayat Ağacı kartı
class LifeTreeCard extends StatelessWidget {
  final int productiveDays;
  final VoidCallback? onTap;

  const LifeTreeCard({
    super.key,
    required this.productiveDays,
    this.onTap,
  });

  TreeLevel get _treeLevel {
    if (productiveDays >= 30) return TreeLevel.flourishing;
    if (productiveDays >= 15) return TreeLevel.mature;
    if (productiveDays >= 8) return TreeLevel.growing;
    if (productiveDays >= 3) return TreeLevel.small;
    return TreeLevel.sprout;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _treeLevel.color.withOpacity(0.15),
              ),
              child: Center(
                child: Text(
                  _treeLevel.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hayat Ağacın',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _treeLevel.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _treeLevel.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$productiveDays verimli gün',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
