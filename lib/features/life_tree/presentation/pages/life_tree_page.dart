import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/life_tree_widget.dart';

/// Hayat Ağacı sayfası - Gamification
class LifeTreePage extends StatelessWidget {
  const LifeTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    const productiveDays = 5;
    final treeLevel = _getTreeLevel(productiveDays);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Hayat Ağacın'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Main tree display
            _buildTreeDisplay(productiveDays, treeLevel),
            const SizedBox(height: 32),

            // Progress to next level
            _buildProgressCard(productiveDays, treeLevel),
            const SizedBox(height: 24),

            // Stats
            _buildStatsRow(productiveDays),
            const SizedBox(height: 24),

            // Level descriptions
            _buildLevelDescriptions(treeLevel),
            const SizedBox(height: 24),

            // How it works
            _buildHowItWorks(),
          ],
        ),
      ),
    );
  }

  TreeLevel _getTreeLevel(int days) {
    if (days >= 30) return TreeLevel.flourishing;
    if (days >= 15) return TreeLevel.mature;
    if (days >= 8) return TreeLevel.growing;
    if (days >= 3) return TreeLevel.small;
    return TreeLevel.sprout;
  }

  Widget _buildTreeDisplay(int productiveDays, TreeLevel level) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            level.color.withOpacity(0.15),
            level.color.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: level.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          LifeTreeWidget(
            productiveDays: productiveDays,
            size: 150,
          ),
          const SizedBox(height: 24),
          Text(
            level.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int productiveDays, TreeLevel currentLevel) {
    final nextLevel = _getNextLevel(currentLevel);
    final daysToNext = nextLevel.minDays - productiveDays;
    final progress = productiveDays / nextLevel.minDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sonraki Seviye',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    nextLevel.emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    nextLevel.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: nextLevel.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(currentLevel.color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$daysToNext verimli gün daha gerekiyor',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  TreeLevel _getNextLevel(TreeLevel current) {
    switch (current) {
      case TreeLevel.sprout:
        return TreeLevel.small;
      case TreeLevel.small:
        return TreeLevel.growing;
      case TreeLevel.growing:
        return TreeLevel.mature;
      case TreeLevel.mature:
        return TreeLevel.flourishing;
      case TreeLevel.flourishing:
        return TreeLevel.flourishing;
    }
  }

  Widget _buildStatsRow(int productiveDays) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Verimli Gün',
            productiveDays.toString(),
            LucideIcons.calendar,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'En Uzun Seri',
            '3',
            LucideIcons.flame,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Bu Hafta',
            '4',
            LucideIcons.trendingUp,
            AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelDescriptions(TreeLevel currentLevel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seviyeler',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...TreeLevel.values.map((level) {
            final isCurrentOrPast =
                level.index <= currentLevel.index;
            return _buildLevelItem(level, isCurrentOrPast);
          }),
        ],
      ),
    );
  }

  Widget _buildLevelItem(TreeLevel level, bool isUnlocked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? level.color.withOpacity(0.1)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                level.emoji,
                style: TextStyle(
                  fontSize: 20,
                  color: isUnlocked ? null : AppColors.textTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                Text(
                  '${level.minDays}+ gün',
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle,
              color: level.color,
              size: 20,
            )
          else
            Icon(
              Icons.lock_outline,
              color: AppColors.textTertiary,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.info, color: AppColors.info, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Nasıl Çalışır?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Uygulamayı açtığın, en az bir mini görevi tamamladığın ve büyük bir sapma yaşamadığın her gün "verimli gün" sayılır ve ağacın büyümeye devam eder.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
