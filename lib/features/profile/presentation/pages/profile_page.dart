import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/life_tree_widget.dart';

/// Profil sayfası - Kimlik, Ayarlar
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ben'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open settings
            },
            icon: const Icon(LucideIcons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Card
            _buildProfileCard(),
            const SizedBox(height: 24),

            // Identity Level
            _buildIdentityCard(),
            const SizedBox(height: 24),

            // Stats Grid
            _buildStatsGrid(),
            const SizedBox(height: 24),

            // Settings List
            _buildSettingsList(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🧠',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          const Text(
            'Dopamin Yolcusu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.trophy,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Seviye 2 • Tomurcuk',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Member since
          Text(
            'Üyelik: 5 Aralık 2024\'ten beri',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            children: [
              const LifeTreeWidget(
                productiveDays: 5,
                size: 80,
                showLabel: false,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kimlik Dönüşümün',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLevelProgress('Filiz', 'Tomurcuk', 0.6),
                    const SizedBox(height: 8),
                    const Text(
                      '2 gün sonra Tomurcuk seviyesine ulaşacaksın',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress(String current, String next, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              current,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              next,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.treeGrowing),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      _StatItem('Verimli Gün', '5', LucideIcons.calendar, AppColors.success),
      _StatItem('Toplam Görev', '23', LucideIcons.checkCircle, AppColors.primary),
      _StatItem('DeepWork', '12 saat', LucideIcons.focus, AppColors.info),
      _StatItem('AI Sohbet', '8', LucideIcons.messageCircle, AppColors.secondary),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat.icon, color: stat.color, size: 20),
              const SizedBox(height: 8),
              Text(
                stat.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                stat.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final settings = [
      _SettingItem('Bildirimler', LucideIcons.bell, () {}),
      _SettingItem('Bağımlılık Türlerim', LucideIcons.listChecks, () {}),
      _SettingItem('Reset Geçmişi', LucideIcons.history, () {}),
      _SettingItem('Veri Dışa Aktar', LucideIcons.download, () {}),
      _SettingItem('Yardım & Destek', LucideIcons.helpCircle, () {}),
      _SettingItem('Hakkında', LucideIcons.info, () {}),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: settings.map((setting) {
          final isLast = settings.indexOf(setting) == settings.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  setting.icon,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                title: Text(
                  setting.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
                onTap: setting.onTap,
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.cardBorder,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _StatItem(this.label, this.value, this.icon, this.color);
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SettingItem(this.title, this.icon, this.onTap);
}
