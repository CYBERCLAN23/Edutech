import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/correction_result.dart';

class CopyCorrectorScreen extends StatefulWidget {
  const CopyCorrectorScreen({super.key});

  @override
  State<CopyCorrectorScreen> createState() => _CopyCorrectorScreenState();
}

class _CopyCorrectorScreenState extends State<CopyCorrectorScreen> {
  bool _hasResult = false;
  late CorrectionResult _result;

  final _subjects = [
    'Mathématiques',
    'Physique-Chimie',
    'SVT',
    'Français',
    'Anglais',
    'Histoire-Géo',
  ];
  String _selectedSubject = 'Mathématiques';

  @override
  void initState() {
    super.initState();
    _result = CorrectionResult(
      subject: 'Mathématiques',
      score: 14,
      totalPoints: 20,
      corrections: [
        'Exercice 1: La dérivée de f(x)=3x²+2x est correcte (f\'(x)=6x+2) ✓',
        'Exercice 2: Attention au signe dans l\'inéquation - l\'intervalle est ]-∞; -2] ∪ [3; +∞[',
        'Exercice 3: Théorème de Pythagore bien appliqué, mais vérifie l\'arrondi au centième',
        'Exercice 4: La rédaction de la démonstration par récurrence est exemplaire',
      ],
      praises: [
        'Très bonne maîtrise des dérivées et des suites',
        'Raisonnement logique clair dans la démonstration',
      ],
      feedback:
          'Bon travail d\'ensemble ! Tu maîtrises bien les dérivées et les suites. Continue à t\'entraîner sur les inéquations du second degré et les arrondis. Tu es sur la bonne voie pour le BAC !',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _hasResult ? _buildResultView() : _buildCameraView(),
      ),
    );
  }

  Widget _buildCameraView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CopyCorrector',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: EduCamColors.primary,
                    ),
                  ),
                  Text(
                    'Correction instantanée par IA',
                    style: TextStyle(
                      fontSize: 14,
                      color: EduCamColors.secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: EduCamColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: EduCamColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: EduCamColors.success),
                    SizedBox(width: 4),
                    Text(
                      'IA prête',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: EduCamColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
              boxShadow: EduCamTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Matière du devoir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: EduCamColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSubject,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: _subjects.map((s) {
                    return DropdownMenuItem(value: s, child: Text(s));
                  }).toList(),
                  onChanged: (v) =>
                      setState(() => _selectedSubject = v!),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Prends une photo claire du devoir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: EduCamColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cadre bien la feuille, bonne luminosité',
                  style: TextStyle(
                    fontSize: 13,
                    color: EduCamColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              setState(() => _hasResult = true);
            },
            child: Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: EduCamColors.accent.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Prendre une photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ou importe depuis la galerie',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildTipsSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EduCamColors.highlight.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EduCamColors.highlight.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 18, color: EduCamColors.highlight),
              SizedBox(width: 8),
              Text(
                'Conseils pour une bonne correction',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: EduCamColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _tipItem('Cadre la feuille entière'),
          _tipItem('Assure-toi d\'avoir une bonne luminosité'),
          _tipItem('Écris lisiblement (lettres attachées acceptées)'),
          _tipItem('Indique le numéro de l\'exercice'),
        ],
      ),
    );
  }

  Widget _tipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: EduCamColors.highlight)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: EduCamColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final pct = _result.percentage.round();
    final grade = pct >= 80
        ? 'Excellent !'
        : pct >= 60
            ? 'Bien !'
            : pct >= 40
                ? 'Peut mieux faire'
                : 'À travailler';

    final gradeColor = pct >= 80
        ? EduCamColors.success
        : pct >= 60
            ? EduCamColors.accent
            : pct >= 40
                ? EduCamColors.highlight
                : EduCamColors.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _hasResult = false),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: EduCamColors.primary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: EduCamColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: 12, color: EduCamColors.success),
                    SizedBox(width: 4),
                    Text(
                      'Corrigé par IA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: EduCamColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradeColor.withValues(alpha: 0.1),
                  EduCamColors.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gradeColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Résultat',
                  style: TextStyle(
                    fontSize: 14,
                    color: EduCamColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$_result.score/${_result.totalPoints}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: gradeColor,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grade,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: gradeColor,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    backgroundColor: EduCamColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_result.subject',
                  style: const TextStyle(
                    fontSize: 13,
                    color: EduCamColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Corrections détaillées',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: EduCamColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ..._result.corrections.map((c) => _CorrectionItem(text: c)),
          if (_result.praises.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Points positifs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: EduCamColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ..._result.praises.map((p) => _PraiseItem(text: p)),
          ],
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: EduCamColors.accent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: EduCamColors.accent.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome,
                        size: 16, color: EduCamColors.accent),
                    SizedBox(width: 8),
                    Text(
                      'Feedback IA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EduCamColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _result.feedback,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: EduCamColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.replay_rounded, size: 18),
              label: const Text('Corriger un autre devoir'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CorrectionItem extends StatelessWidget {
  final String text;

  const _CorrectionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final isCorrect = text.contains('✓');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCorrect
                  ? EduCamColors.success.withValues(alpha: 0.1)
                  : EduCamColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              size: 14,
              color: isCorrect ? EduCamColors.success : EduCamColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: EduCamColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PraiseItem extends StatelessWidget {
  final String text;

  const _PraiseItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: EduCamColors.highlight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 14,
              color: EduCamColors.highlight,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: EduCamColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
