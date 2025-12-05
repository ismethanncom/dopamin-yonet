import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

/// İstek Yönetimi sayfası - Dürtü geldiğinde destek
class UrgePage extends StatefulWidget {
  const UrgePage({super.key});

  @override
  State<UrgePage> createState() => _UrgePageState();
}

class _UrgePageState extends State<UrgePage> with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _isBreathing = false;
  int _breathingSeconds = 60;
  Timer? _breathingTimer;
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _breathAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
    });
    _breathController.repeat(reverse: true);
    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_breathingSeconds > 0) {
        setState(() {
          _breathingSeconds--;
        });
      } else {
        _completeBreathing();
      }
    });
  }

  void _completeBreathing() {
    _breathingTimer?.cancel();
    _breathController.stop();
    setState(() {
      _currentStep = 2;
      _isBreathing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('İstek Yönetimi'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildAcknowledgeStep();
      case 1:
        return _buildBreathingStep();
      case 2:
        return _buildSuccessStep();
      default:
        return _buildAcknowledgeStep();
    }
  }

  Widget _buildAcknowledgeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('⚡', style: TextStyle(fontSize: 56)),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'İstek geldi mi?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Sakin ol, bu his geçici.\nBirlikte yönetelim.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        // Quick tips
        _buildQuickTip(
          '🧠',
          'Bu dürtü 90 saniye içinde zayıflar',
        ),
        const SizedBox(height: 12),
        _buildQuickTip(
          '💨',
          'Derin nefes almak dopamini dengeler',
        ),
        const SizedBox(height: 12),
        _buildQuickTip(
          '🚶',
          'Odayı değiştirmek tetikleyiciyi kırar',
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
              _startBreathing();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Nefes Egzersizi Başlat'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Şimdilik İyiyim'),
        ),
      ],
    );
  }

  Widget _buildQuickTip(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Nefes Egzersizi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$_breathingSeconds saniye kaldı',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        // Breathing animation
        AnimatedBuilder(
          animation: _breathAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _breathAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        _getBreathingText(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _buildBreathingInstruction('4 saniye', 'Nefes al', AppColors.info),
              const SizedBox(height: 8),
              _buildBreathingInstruction('7 saniye', 'Tut', AppColors.warning),
              const SizedBox(height: 8),
              _buildBreathingInstruction('8 saniye', 'Nefes ver', AppColors.success),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: _completeBreathing,
          child: const Text('Atla'),
        ),
      ],
    );
  }

  String _getBreathingText() {
    final phase = (_breathingSeconds % 19);
    if (phase >= 15) return 'Nefes Al';
    if (phase >= 8) return 'Tut';
    return 'Nefes Ver';
  }

  Widget _buildBreathingInstruction(String duration, String action, Color color) {
    return Row(
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            duration,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          action,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('💪', style: TextStyle(fontSize: 56)),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Harika!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'İsteğin üstesinden geldin.\nHer başarı beynini yeniden şekillendiriyor.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.trophy, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                '+5 Stability Puanı',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Tamamla'),
          ),
        ),
      ],
    );
  }
}
