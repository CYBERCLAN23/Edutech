import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';

class TeacherAddQuiz extends StatefulWidget {
  final String courseId;
  const TeacherAddQuiz({super.key, required this.courseId});

  @override
  State<TeacherAddQuiz> createState() => _TeacherAddQuizState();
}

class _TeacherAddQuizState extends State<TeacherAddQuiz> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(text: '10');
  final List<_QuizQuestionField> _questions = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    for (final q in _questions) {
      q.textCtrl.dispose();
      for (final o in q.optionCtrls) {
        o.dispose();
      }
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuizQuestionField(
        textCtrl: TextEditingController(),
        optionCtrls: [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ],
        correctIndex: 0,
      ));
    });
  }

  void _removeQuestion(int index) {
    final q = _questions[index];
    q.textCtrl.dispose();
    for (final o in q.optionCtrls) {
      o.dispose();
    }
    setState(() => _questions.removeAt(index));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ajoute au moins une question'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    HapticFeedback.lightImpact();
    DataStore().quizzes.add(Quiz(
      id: 'quiz-${DateTime.now().millisecondsSinceEpoch}',
      courseId: widget.courseId,
      title: _titleCtrl.text.trim(),
      timeLimitMinutes: int.tryParse(_timeCtrl.text) ?? 10,
      questions: _questions.map((q) => QuizQuestion(
        text: q.textCtrl.text.trim(),
        options: q.optionCtrls.map((o) => o.text.trim()).toList(),
        correctIndex: q.correctIndex,
      )).toList(),
      createdAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quiz cree avec succes'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creer un quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
        backgroundColor: EduCamColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: EduCamColors.primary),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre du quiz', hintText: 'Ex: Quiz sur les derivees'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 140,
                child: TextFormField(
                  controller: _timeCtrl,
                  decoration: const InputDecoration(labelText: 'Temps (min)', hintText: '10'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Questions QCM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                  TextButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Ajouter'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_questions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: const Center(
                    child: Text('Ajoute des questions a ce quiz', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                  ),
                ),
              ..._questions.asMap().entries.map((e) {
                final i = e.key;
                final q = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: EduCamColors.highlight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EduCamColors.highlight))),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(child: Text('Question', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary))),
                          GestureDetector(
                            onTap: () => _removeQuestion(i),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: EduCamColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.delete_rounded, size: 16, color: EduCamColors.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: q.textCtrl,
                        decoration: const InputDecoration(hintText: 'Texte de la question...', contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                        maxLines: 2,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                      ),
                      const SizedBox(height: 12),
                      ...q.optionCtrls.asMap().entries.map((opt) {
                        final oi = opt.key;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => q.correctIndex = oi),
                                child: Container(
                                  width: 24, height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: q.correctIndex == oi ? EduCamColors.success : EduCamColors.cardBorder,
                                  ),
                                  child: q.correctIndex == oi
                                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: opt.value,
                                  decoration: InputDecoration(
                                    hintText: 'Option ${String.fromCharCode(65 + oi)}',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Creer le quiz'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizQuestionField {
  final TextEditingController textCtrl;
  final List<TextEditingController> optionCtrls;
  int correctIndex;
  _QuizQuestionField({
    required this.textCtrl,
    required this.optionCtrls,
    this.correctIndex = 0,
  });
}
