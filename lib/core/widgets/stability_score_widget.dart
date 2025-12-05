import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants/app_colors.dart';

/// Stability Score gösterge widget'ı
class StabilityScoreWidget extends StatelessWidget {
  final int score;
  final double size;
  final bool showLabel;
  final bool animated;

  const StabilityScoreWidget({
    super.key,
    required this.score,
    this.size = 120,
    this.showLabel = true,
    this.animated = true,
  });

  Color get _scoreColor => AppColors.getStabilityColor(score);

  String get _levelText {
    if (score >= 80) return 'Mükemmel';
    if (score >= 60) return 'İyi';
    if (score >= 40) return 'Orta';
    if (score >= 20) return 'Düşük';
    return 'Kritik';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: size / 2,
          lineWidth: size * 0.08,
          percent: (score / 100).clamp(0.0, 1.0),
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (showLabel)
                Text(
                  _levelText,
                  style: TextStyle(
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.w500,
                    color: _scoreColor,
                  ),
                ),
            ],
          ),
          progressColor: _scoreColor,
          backgroundColor: AppColors.surfaceLight,
          circularStrokeCap: CircularStrokeCap.round,
          animation: animated,
          animationDuration: 1000,
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            'Stability Score',
            style: TextStyle(
              fontSize: size * 0.11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Kompakt Stability Score kartı
class StabilityScoreCard extends StatelessWidget {
  final int score;
  final VoidCallback? onTap;

  const StabilityScoreCard({
    super.key,
    required this.score,
    this.onTap,
  });

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
            StabilityScoreWidget(
              score: score,
              size: 80,
              showLabel: false,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stability Score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'İrade değil, istikrar',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: AppColors.getStabilityColor(score),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getLevelText(score),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getStabilityColor(score),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelText(int score) {
    if (score >= 80) return 'Mükemmel seviye';
    if (score >= 60) return 'İyi gidiyorsun';
    if (score >= 40) return 'Gelişme alanı var';
    if (score >= 20) return 'Desteğe ihtiyacın var';
    return 'Bugün zor';
  }
}
