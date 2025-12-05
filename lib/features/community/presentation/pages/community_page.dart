import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

/// Topluluk sayfası - Forum, Gruplar, Arkadaşlar
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Topluluk'),
        backgroundColor: AppColors.background,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Forum'),
            Tab(text: 'Gruplar'),
            Tab(text: 'Arkadaşlar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ForumTab(),
          _GroupsTab(),
          _FriendsTab(),
        ],
      ),
    );
  }
}

class _ForumTab extends StatelessWidget {
  final List<_ForumCategory> categories = [
    _ForumCategory('Günlük Paylaşım', LucideIcons.messageSquare, 128),
    _ForumCategory('Soru – Cevap', LucideIcons.helpCircle, 56),
    _ForumCategory('İlerleme Paylaşımları', LucideIcons.trendingUp, 89),
    _ForumCategory('Destek İste', LucideIcons.heart, 34),
    _ForumCategory('Taktikler & Yöntemler', LucideIcons.lightbulb, 67),
  ];

  final List<_ForumPost> recentPosts = [
    _ForumPost(
      username: 'KullanıcıA',
      title: '7. günümü tamamladım!',
      preview: 'Bugün yedinci günümü tamamladım ve kendimi çok daha iyi hissediyorum...',
      category: 'İlerleme',
      likes: 24,
      comments: 8,
      timeAgo: '2 saat önce',
    ),
    _ForumPost(
      username: 'KullanıcıB',
      title: 'Akşamları çok zorlanıyorum',
      preview: 'Özellikle saat 10\'dan sonra dürtüler çok artıyor. Ne yapmalıyım?',
      category: 'Destek',
      likes: 12,
      comments: 15,
      timeAgo: '4 saat önce',
    ),
    _ForumPost(
      username: 'KullanıcıC',
      title: 'Soğuk duş gerçekten işe yarıyor',
      preview: 'İstek anında 30 saniye soğuk duş almayı denedim ve...',
      category: 'Taktik',
      likes: 45,
      comments: 12,
      timeAgo: '6 saat önce',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          const Text(
            'Kategoriler',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((cat) => _buildCategoryItem(cat)),
          const SizedBox(height: 24),

          // Recent Posts
          const Text(
            'Son Paylaşımlar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...recentPosts.map((post) => _buildPostCard(post)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(_ForumCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${category.postCount}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(_ForumPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    post.username[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      post.timeAgo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  post.category,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.preview,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(LucideIcons.heart, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                '${post.likes}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(LucideIcons.messageCircle,
                  size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                '${post.comments}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  final List<_Group> groups = [
    _Group('Dopamin Yönet Resmi', 'Resmi destek grubu', 1250, true),
    _Group('Yeni Başlayanlar', 'İlk 7 gün için', 456, false),
    _Group('Streak 7+ Gün', '7 günü geçenler için', 234, false),
    _Group('Odak & Çalışma', 'DeepWork odaklı', 189, false),
    _Group('Sabah Rutini', 'Erken kalkanlar', 167, false),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gruplar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Amaç odaklı sohbet alanları',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ...groups.map((group) => _buildGroupCard(group)),
        ],
      ),
    );
  }

  Widget _buildGroupCard(_Group group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: group.isOfficial
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: group.isOfficial
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              group.isOfficial ? LucideIcons.crown : LucideIcons.users,
              color: group.isOfficial
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (group.isOfficial) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  group.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.memberCount} üye',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Katıl',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.userPlus,
              color: AppColors.textTertiary,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Henüz arkadaşın yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Forum ve gruplarda tanıştığın kişileri\narkadaş olarak ekleyebilirsin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Search friends
            },
            icon: const Icon(LucideIcons.search, size: 18),
            label: const Text('Arkadaş Ara'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumCategory {
  final String name;
  final IconData icon;
  final int postCount;

  _ForumCategory(this.name, this.icon, this.postCount);
}

class _ForumPost {
  final String username;
  final String title;
  final String preview;
  final String category;
  final int likes;
  final int comments;
  final String timeAgo;

  _ForumPost({
    required this.username,
    required this.title,
    required this.preview,
    required this.category,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}

class _Group {
  final String name;
  final String description;
  final int memberCount;
  final bool isOfficial;

  _Group(this.name, this.description, this.memberCount, this.isOfficial);
}
