import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

/// DeepWork Modu sayfası - 40 dakika odaklanma
class DeepWorkPage extends StatefulWidget {
  const DeepWorkPage({super.key});

  @override
  State<DeepWorkPage> createState() => _DeepWorkPageState();
}

class _DeepWorkPageState extends State<DeepWorkPage>
    with TickerProviderStateMixin {
  static const int _totalSeconds = 40 * 60; // 40 minutes
  int _remainingSeconds = _totalSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeSession();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  void _completeSession() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎉', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Harika İş!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '40 dakikalık DeepWork seansını tamamladın!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '+10 Odak Puanı kazandın',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Tamamla'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get _progress => 1 - (_remainingSeconds / _totalSeconds);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('DeepWork Modu'),
        actions: [
          if (_remainingSeconds < _totalSeconds)
            TextButton(
              onPressed: _resetTimer,
              child: const Text('Sıfırla'),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Timer display
              _buildTimerDisplay(),

              const SizedBox(height: 48),

              // Status text
              Text(
                _isRunning
                    ? 'Odaklanma modundasın'
                    : _isCompleted
                        ? 'Tebrikler!'
                        : 'Başlamaya hazır mısın?',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              // Tips
              if (!_isRunning) _buildTips(),

              const SizedBox(height: 24),

              // Control buttons
              _buildControlButtons(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        SizedBox(
          width: 260,
          height: 260,
          child: CircularProgressIndicator(
            value: 1,
            strokeWidth: 8,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.surfaceLight),
          ),
        ),
        // Progress circle
        SizedBox(
          width: 260,
          height: 260,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 8,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              _isRunning ? AppColors.primary : AppColors.primary.withOpacity(0.5),
            ),
            strokeCap: StrokeCap.round,
          ),
        ),
        // Pulse effect when running
        if (_isRunning)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 220 + (_pulseController.value * 10),
                height: 220 + (_pulseController.value * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.05 * _pulseController.value),
                ),
              );
            },
          ),
        // Timer text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
            if (_isRunning)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Aktif',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.lightbulb, color: AppColors.warning, size: 18),
              const SizedBox(width: 8),
              const Text(
                'İpuçları',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Telefonunu sessize al veya başka odaya koy'),
          _buildTipItem('Tek bir göreve odaklan'),
          _buildTipItem('Su şişeni yanında bulundur'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.textTertiary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    if (_isRunning) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _pauseTimer,
          icon: const Icon(LucideIcons.pause),
          label: const Text('Duraklat'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _startTimer,
        icon: const Icon(LucideIcons.play),
        label: Text(_remainingSeconds < _totalSeconds ? 'Devam Et' : 'Başlat'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}
