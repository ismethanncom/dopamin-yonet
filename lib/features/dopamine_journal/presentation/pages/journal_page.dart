import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

/// Dopamin Günlüğü sayfası - 12 saniyelik günlük tarama
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _currentStep = 0;
  final Map<String, double> _values = {
    'energy': 50,
    'focus': 50,
    'desire': 50,
    'anxiety': 50,
    'motivation': 50,
  };
  final TextEditingController _noteController = TextEditingController();

  final List<_JournalStep> _steps = [
    _JournalStep(
      key: 'energy',
      title: 'Enerji Seviyen',
      emoji: '⚡',
      lowLabel: 'Düşük',
      highLabel: 'Yüksek',
      color: AppColors.warning,
    ),
    _JournalStep(
      key: 'focus',
      title: 'Odak Seviyen',
      emoji: '🎯',
      lowLabel: 'Dağınık',
      highLabel: 'Odaklı',
      color: AppColors.primary,
    ),
    _JournalStep(
      key: 'desire',
      title: 'İstek Yoğunluğu',
      emoji: '🔥',
      lowLabel: 'Sakin',
      highLabel: 'Yoğun',
      color: AppColors.error,
    ),
    _JournalStep(
      key: 'anxiety',
      title: 'Anksiyete Seviyesi',
      emoji: '😰',
      lowLabel: 'Huzurlu',
      highLabel: 'Kaygılı',
      color: AppColors.info,
    ),
    _JournalStep(
      key: 'motivation',
      title: 'Motivasyon',
      emoji: '💪',
      lowLabel: 'Düşük',
      highLabel: 'Yüksek',
      color: AppColors.success,
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _saveEntry() {
    // TODO: Save journal entry
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlük kaydedildi!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Dopamin Günlüğü'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            Expanded(
              child: _currentStep < _steps.length
                  ? _buildSliderStep(_steps[_currentStep])
                  : _buildNoteStep(),
            ),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentStep + 1} / ${_steps.length + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Text(
                '12 saniyelik tarama',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / (_steps.length + 1),
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderStep(_JournalStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            step.emoji,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 24),
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 48),
          // Value display
          Text(
            _values[step.key]!.toInt().toString(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: step.color,
            ),
          ),
          const SizedBox(height: 24),
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: step.color,
              inactiveTrackColor: step.color.withOpacity(0.2),
              thumbColor: step.color,
              overlayColor: step.color.withOpacity(0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: _values[step.key]!,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _values[step.key] = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step.lowLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                step.highLabel,
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

  Widget _buildNoteStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📝',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 24),
          const Text(
            'Kısa Bir Not',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bugün nasıl hissediyorsun? (Opsiyonel)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _noteController,
            maxLength: 100,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Notunu buraya yaz...',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterStyle: const TextStyle(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 24),
          // Summary
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final dopamineScore = _calculateDopamineScore();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Dopamin Skoru', dopamineScore.toString(), AppColors.primary),
          Container(width: 1, height: 40, color: AppColors.cardBorder),
          _buildSummaryItem(
            'Durum',
            _getStatusText(dopamineScore),
            AppColors.getStabilityColor(dopamineScore),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  int _calculateDopamineScore() {
    final energy = _values['energy']!;
    final focus = _values['focus']!;
    final motivation = _values['motivation']!;
    final desire = 100 - _values['desire']!; // Lower desire = better
    final anxiety = 100 - _values['anxiety']!; // Lower anxiety = better

    return ((energy + focus + motivation + desire + anxiety) / 5).round();
  }

  String _getStatusText(int score) {
    if (score >= 80) return 'Mükemmel';
    if (score >= 60) return 'İyi';
    if (score >= 40) return 'Orta';
    if (score >= 20) return 'Düşük';
    return 'Zor';
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Geri'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentStep < _steps.length ? _nextStep : _saveEntry,
              child: Text(
                _currentStep < _steps.length ? 'Devam' : 'Kaydet',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalStep {
  final String key;
  final String title;
  final String emoji;
  final String lowLabel;
  final String highLabel;
  final Color color;

  _JournalStep({
    required this.key,
    required this.title,
    required this.emoji,
    required this.lowLabel,
    required this.highLabel,
    required this.color,
  });
}
