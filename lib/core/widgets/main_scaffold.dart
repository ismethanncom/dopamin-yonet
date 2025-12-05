import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/app_colors.dart';

/// Ana uygulama scaffold'u - Bottom navigation ile
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _getSelectedIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/library')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: LucideIcons.home,
                  label: 'Ana Sayfa',
                  isSelected: selectedIndex == 0,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: LucideIcons.barChart3,
                  label: 'Analizler',
                  isSelected: selectedIndex == 1,
                  onTap: () => context.go('/analytics'),
                ),
                _NavItem(
                  icon: LucideIcons.bookOpen,
                  label: 'Kütüphane',
                  isSelected: selectedIndex == 2,
                  onTap: () => context.go('/library'),
                ),
                _NavItem(
                  icon: LucideIcons.users,
                  label: 'Topluluk',
                  isSelected: selectedIndex == 3,
                  onTap: () => context.go('/community'),
                ),
                _NavItem(
                  icon: LucideIcons.user,
                  label: 'Ben',
                  isSelected: selectedIndex == 4,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
