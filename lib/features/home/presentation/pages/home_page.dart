import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/stability_score_widget.dart';
import '../../../../core/widgets/life_tree_widget.dart';
import '../../../../core/widgets/panic_button.dart';
import '../../../../core/widgets/mini_task_card.dart';
import '../../../../models/mini_task_model.dart';
import 'dart:math';

/// Ana sayfa
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Demo data
  final int _stabilityScore = 68;
  final int _productiveDays = 5;
  final double _brainRewiringProgress = 0.35;
  late MiniTaskModel _dailyTask;
  late String _motivationalQuote;

  @override
  void initState() {
    super.initState();
    _dailyTask = MiniTaskModel.defaultTasks[
        DateTime.now().day % MiniTaskModel.defaultTasks.length];
    _motivationalQuote = AppStrings.motivationalQuotes[
        Random().nextInt(AppStrings.motivationalQuotes.length)];
  }

  void _showPanicHelp() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PanicHelpModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Stability Score + Life Tree Row
              Row(
                children: [
                  Expanded(child: _buildStabilityCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildLifeTreeCard()),
                ],
              ),
              const SizedBox(height: 16),

              // Brain Rewiring Progress
              _buildBrainRewiringCard(),
              const SizedBox(height: 16),

              // Daily Task
              DailyMiniTaskCard(
                task: _dailyTask,
                onTap: () {
                  // TODO: Navigate to task
                },
              ),
              const SizedBox(height: 16),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 16),

              // Journal Entry
              _buildJournalCard(),
              const SizedBox(height: 16),

              // Motivational Quote
              _buildMotivationalCard(),
              const SizedBox(height: 24),

              // Panic Button
              Center(
                child: PanicButton(
                  onPressed: _showPanicHelp,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Günaydın';
    } else if (hour < 18) {
      greeting = 'İyi günler';
    } else {
      greeting = 'İyi akşamlar';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dopamin Yönet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.user,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStabilityCard() {
    return GestureDetector(
      onTap: () => context.push('/analytics'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            StabilityScoreWidget(
              score: _stabilityScore,
              size: 80,
              showLabel: false,
            ),
            const SizedBox(height: 8),
            const Text(
              'Stability Score',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getScoreLevel(_stabilityScore),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.getStabilityColor(_stabilityScore),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeTreeCard() {
    return GestureDetector(
      onTap: () => context.push('/life-tree'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            LifeTreeWidget(
              productiveDays: _productiveDays,
              size: 80,
              showLabel: false,
            ),
            const SizedBox(height: 8),
            const Text(
              'Hayat Ağacın',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$_productiveDays verimli gün',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrainRewiringCard() {
    final percentage = (_brainRewiringProgress * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.brain,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Beyin Yeniden Yapılanma',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '%$percentage',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _brainRewiringProgress,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '7 günlük hedefin %$percentage tamamlandı',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.zap,
            label: 'İstek Geldi',
            color: AppColors.warning,
            onTap: () => context.push('/urge'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.focus,
            label: 'DeepWork',
            color: AppColors.primary,
            onTap: () => context.push('/deep-work'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.messageCircle,
            label: 'AI Koç',
            color: AppColors.success,
            onTap: () => context.push('/ai-coach'),
          ),
        ),
      ],
    );
  }

  Widget _buildJournalCard() {
    return GestureDetector(
      onTap: () => context.push('/journal'),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.bookOpen,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dopamin Günlüğü',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+ Yeni Girdi Ekle',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text(
            '💡',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _motivationalQuote,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreLevel(int score) {
    if (score >= 80) return 'Mükemmel';
    if (score >= 60) return 'İyi';
    if (score >= 40) return 'Orta';
    if (score >= 20) return 'Düşük';
    return 'Kritik';
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
