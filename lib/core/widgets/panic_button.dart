import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// Acil yardım butonu - Panic Button
class PanicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;

  const PanicButton({
    super.key,
    required this.onPressed,
    this.size = 70,
  });

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: widget.size + (20 * _pulseAnimation.value),
              height: widget.size + (20 * _pulseAnimation.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.2 * (1 - _pulseAnimation.value)),
              ),
            ),
            // Main button
            Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.onPressed();
                },
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.dangerGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.textPrimary,
                        size: widget.size * 0.35,
                      ),
                      Text(
                        'YARDIM',
                        style: TextStyle(
                          fontSize: widget.size * 0.12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Panic button ile acil yardım modalı
class PanicHelpModal extends StatelessWidget {
  const PanicHelpModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.error,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Zor bir an yaşıyorsun',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bu his geçici. Birlikte atlatalım.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _HelpOption(
            icon: Icons.air,
            title: 'Nefes Egzersizi',
            subtitle: '60 saniyelik sakinleştirici nefes',
            onTap: () {
              Navigator.pop(context);
              // Navigate to breathing exercise
            },
          ),
          const SizedBox(height: 12),
          _HelpOption(
            icon: Icons.chat_bubble_outline,
            title: 'AI Koç ile Konuş',
            subtitle: 'Yapay zekâ destekli sohbet',
            onTap: () {
              Navigator.pop(context);
              // Navigate to AI coach
            },
          ),
          const SizedBox(height: 12),
          _HelpOption(
            icon: Icons.timer,
            title: '5 Dakika Bekle',
            subtitle: 'Dürtü geçene kadar sayaç başlat',
            onTap: () {
              Navigator.pop(context);
              // Start timer
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Şimdilik İyiyim'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HelpOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
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
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
