import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';

class StudentTakeQuiz extends StatefulWidget {
  final Quiz quiz;
  final Color courseColor;

  const StudentTakeQuiz({super.key, required this.quiz, required this.courseColor});

  @override
  State<StudentTakeQuiz> createState() => _StudentTakeQuizState();
}

class _StudentTakeQuizState extends State<StudentTakeQuiz> {
  int _currentQ = 0;
  final Map<int, int> _answers = {};
  bool _submitted = false;
  int _score = 0;

  Quiz get _quiz => widget.quiz;
  Color get _cc => widget.courseColor;

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _quiz.questions.length; i++) {
      if (_answers[i] == _quiz.questions[i].correctIndex) correct++;
    }
    setState(() {
      _submitted = true;
      _score = (correct / _quiz.questions.length * 20).round();
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final qs = _quiz.questions;
    final total = qs.length;

    if (_submitted) {
      final passed = _score >= 10;
      return Scaffold(
        backgroundColor: EduCamColors.background,
        appBar: AppBar(
          backgroundColor: EduCamColors.background, elevation: 0,
          leading: GestureDetector(
            onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
            child: const Padding(padding: EdgeInsets.all(16), child: Icon(Icons.close_rounded, color: EduCamColors.primary)),
          ),
          title: const Text('Resultat', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: passed ? EduCamColors.success.withValues(alpha: 0.1) : EduCamColors.error.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text('$_score/20', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
                      color: passed ? EduCamColors.success : EduCamColors.error)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(passed ? 'Bien joue !' : 'Tu peux mieux faire',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: passed ? EduCamColors.success : EduCamColors.error)),
                const SizedBox(height: 4),
                Text('${_score >= 10 ? _score ~/ 2 : _score} bonnes reponses sur $total questions',
                  style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                if (!passed) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: EduCamColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: EduCamColors.error.withValues(alpha: 0.2), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: EduCamColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.auto_awesome_rounded, size: 16, color: EduCamColors.error),
                          ),
                          const SizedBox(width: 8),
                          const Text('Correction video', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EduCamColors.error)),
                        ]),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity, height: 160,
                          decoration: BoxDecoration(
                            color: EduCamColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle_rounded, size: 48, color: EduCamColors.error.withValues(alpha: 0.4)),
                                const SizedBox(height: 8),
                                Text('Video explicative disponible', style: TextStyle(fontSize: 13, color: EduCamColors.error.withValues(alpha: 0.6))),
                                const SizedBox(height: 4),
                                Text('Correction detaillee pas-a-pas', style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Correction textuelle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                        const SizedBox(height: 8),
                        ...List.generate(qs.length, (i) {
                          final q = qs[i];
                          final userAns = _answers[i] ?? -1;
                          final correct = userAns == q.correctIndex;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: EduCamColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: correct ? EduCamColors.success.withValues(alpha: 0.3) : EduCamColors.error.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Icon(correct ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 16,
                                      color: correct ? EduCamColors.success : EduCamColors.error),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text('Q${i + 1}: ${q.text}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EduCamColors.primary))),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text('Reponse: ${q.options[q.correctIndex]}', style: const TextStyle(fontSize: 12, color: EduCamColors.success)),
                                  if (!correct)
                                    Text('Ta reponse: ${userAns >= 0 ? q.options[userAns] : "Pas de reponse"}',
                                      style: const TextStyle(fontSize: 12, color: EduCamColors.error)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _cc.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('Retour aux cours', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _cc))),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = qs[_currentQ];
    return Scaffold(
      backgroundColor: EduCamColors.background,
      appBar: AppBar(
        backgroundColor: EduCamColors.background, elevation: 0,
        leading: GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
          child: const Padding(padding: EdgeInsets.all(16), child: Icon(Icons.close_rounded, color: EduCamColors.primary)),
        ),
        title: Column(children: [
          Text(_quiz.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          Text('Question ${_currentQ + 1}/$total', style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
        ]),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentQ + 1) / total,
                  backgroundColor: EduCamColors.progressTrack,
                  valueColor: AlwaysStoppedAnimation(_cc),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _cc.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('Question ${_currentQ + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _cc)),
              ),
              const SizedBox(height: 12),
              Text(q.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: EduCamColors.primary, height: 1.3)),
              const SizedBox(height: 24),
              ...List.generate(q.options.length, (i) {
                final selected = _answers[_currentQ] == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _answers[_currentQ] = i);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected ? _cc.withValues(alpha: 0.06) : EduCamColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? _cc.withValues(alpha: 0.3) : EduCamColors.cardBorder,
                          width: selected ? 1 : 0.5,
                        ),
                      ),
                      child: Row(children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? _cc : Colors.transparent,
                            border: Border.all(color: selected ? _cc : EduCamColors.cardBorder, width: 2),
                          ),
                          child: selected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(q.options[i], style: TextStyle(fontSize: 14, color: selected ? EduCamColors.primary : EduCamColors.secondaryText))),
                      ]),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Row(children: [
                if (_currentQ > 0)
                  Expanded(
                    child: GestureDetector(
                      onTap: () { HapticFeedback.lightImpact(); setState(() => _currentQ--); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: EduCamColors.surface, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                        ),
                        child: const Center(child: Text('Precedent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary))),
                      ),
                    ),
                  ),
                if (_currentQ > 0) const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentQ < total - 1) {
                        HapticFeedback.lightImpact();
                        setState(() => _currentQ++);
                      } else {
                        _submit();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _cc, borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text(
                        _currentQ < total - 1 ? 'Suivant' : 'Terminer',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
