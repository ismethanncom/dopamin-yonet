import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/addiction_type.dart';

/// Bağımlılık türü seçim sayfası
class AddictionSelectionPage extends StatefulWidget {
  const AddictionSelectionPage({super.key});

  @override
  State<AddictionSelectionPage> createState() => _AddictionSelectionPageState();
}

class _AddictionSelectionPageState extends State<AddictionSelectionPage> {
  final Set<AddictionType> _selectedAddictions = {};

  void _toggleAddiction(AddictionType type) {
    setState(() {
      if (_selectedAddictions.contains(type)) {
        _selectedAddictions.remove(type);
      } else {
        _selectedAddictions.add(type);
      }
    });
  }

  void _continue() {
    if (_selectedAddictions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En az bir alan seçmelisin'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // TODO: Save selected addictions
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              const Text(
                'Hangi alanlarda\ndestek istiyorsun?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Birden fazla seçebilirsin. Seni yargılamıyoruz.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Selection grid
              Expanded(
                child: ListView.separated(
                  itemCount: AddictionType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final type = AddictionType.values[index];
                    final isSelected = _selectedAddictions.contains(type);

                    return _AddictionCard(
                      type: type,
                      isSelected: isSelected,
                      onTap: () => _toggleAddiction(type),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAddictions.isEmpty
                        ? AppColors.surfaceLight
                        : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Devam Et (${_selectedAddictions.length} seçili)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedAddictions.isEmpty
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddictionCard extends StatelessWidget {
  final AddictionType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddictionCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  type.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: AppColors.textPrimary,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
