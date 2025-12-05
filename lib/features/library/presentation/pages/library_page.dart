import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

/// Kütüphane sayfası - Öğrenme Merkezi
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kütüphane'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Recommendations
            _buildMonthlyRecommendations(),
            const SizedBox(height: 24),

            // Relaxing Sounds
            _buildRelaxingSounds(),
            const SizedBox(height: 24),

            // Next Lesson
            _buildNextLesson(context),
            const SizedBox(height: 24),

            // AI Coach Card
            _buildAICoachCard(context),
            const SizedBox(height: 24),

            // Life Tree Card
            _buildLifeTreeCard(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRecommendations() {
    final recommendations = [
      _ContentCard(
        title: 'Dopamin Döngüsünü Anlamak',
        subtitle: 'Kısa açıklayıcı bir içerik',
        type: 'Video',
        duration: '8 dk',
        imageEmoji: '🧠',
      ),
      _ContentCard(
        title: 'Odak Kaybının Gerçek Sebepleri',
        subtitle: 'Modern dikkat dağınıklığı',
        type: 'Video',
        duration: '12 dk',
        imageEmoji: '🎯',
      ),
      _ContentCard(
        title: 'Dürtü Anlarında Beyin',
        subtitle: 'Bilimsel ama sade anlatım',
        type: 'Video',
        duration: '6 dk',
        imageEmoji: '⚡',
      ),
      _ContentCard(
        title: 'Dopamin Tabanı Nasıl Yükselir?',
        subtitle: 'Kısa bir anlatım',
        type: 'Podcast',
        duration: '15 dk',
        imageEmoji: '🎧',
      ),
      _ContentCard(
        title: 'Disiplini Kalıcı Hale Getirmek',
        subtitle: 'Günlük hayata uygulanabilir',
        type: 'Podcast',
        duration: '20 dk',
        imageEmoji: '💪',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ayın Tavsiyeleri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Bu ay dopamin, odaklanma ve alışkanlık yönetimi üzerine seçilmiş içerikler',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildContentCard(recommendations[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(_ContentCard card) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with emoji
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                card.imageEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: card.type == 'Video'
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${card.type} • ${card.duration}',
              style: TextStyle(
                fontSize: 9,
                color: card.type == 'Video'
                    ? AppColors.primary
                    : AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRelaxingSounds() {
    final sounds = [
      _SoundItem('Okyanus Dalgaları', '🌊', AppColors.info),
      _SoundItem('Yağmur', '🌧️', AppColors.secondary),
      _SoundItem('Orman', '🌲', AppColors.success),
      _SoundItem('Derin Okyanus', '🐋', AppColors.primary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Düzenleyici Sesler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: sounds.map((sound) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: sounds.indexOf(sound) < sounds.length - 1 ? 8 : 0,
                ),
                child: _buildSoundItem(sound),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSoundItem(_SoundItem sound) {
    return GestureDetector(
      onTap: () {
        // TODO: Play sound
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: sound.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sound.color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              sound.emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              sound.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextLesson(BuildContext context) {
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.graduationCap,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sıradaki Dersin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3/20 • Dopamin ve Bağımlılık',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.15,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Start lesson
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Derse Başla'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICoachCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ai-coach'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.success.withOpacity(0.15),
              AppColors.success.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dopamin Koçu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Yapay zekâ ile bire bir destek ve yönlendirme',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeTreeCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/life-tree'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.treeGrowing.withOpacity(0.15),
              AppColors.treeGrowing.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.treeGrowing.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.treeGrowing.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('🌳', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hayat Ağacın',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dopamin dengenle birlikte büyüyen yaşam ağacı',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.treeGrowing,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard {
  final String title;
  final String subtitle;
  final String type;
  final String duration;
  final String imageEmoji;

  _ContentCard({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.duration,
    required this.imageEmoji,
  });
}

class _SoundItem {
  final String name;
  final String emoji;
  final Color color;

  _SoundItem(this.name, this.emoji, this.color);
}
