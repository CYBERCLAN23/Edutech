import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';

class TeacherAddExercise extends StatefulWidget {
  final String courseId;
  const TeacherAddExercise({super.key, required this.courseId});

  @override
  State<TeacherAddExercise> createState() => _TeacherAddExerciseState();
}

class _TeacherAddExerciseState extends State<TeacherAddExercise> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();
  final List<_QuestionField> _questions = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _instrCtrl.dispose();
    for (final q in _questions) {
      q.textCtrl.dispose();
      q.pointsCtrl.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuestionField(
        textCtrl: TextEditingController(),
        pointsCtrl: TextEditingController(text: '2'),
      ));
    });
  }

  void _removeQuestion(int index) {
    final q = _questions[index];
    q.textCtrl.dispose();
    q.pointsCtrl.dispose();
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
    DataStore().exercises.add(Exercise(
      id: 'ex-${DateTime.now().millisecondsSinceEpoch}',
      courseId: widget.courseId,
      title: _titleCtrl.text.trim(),
      instructions: _instrCtrl.text.trim(),
      questions: _questions.map((q) => ExerciseQuestion(
        text: q.textCtrl.text.trim(),
        points: int.tryParse(q.pointsCtrl.text) ?? 2,
      )).toList(),
      createdAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exercice cree avec succes'),
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
        title: const Text('Creer un exercice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
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
                decoration: const InputDecoration(labelText: "Titre de l'exercice", hintText: 'Ex: Derivation - Exercices'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instrCtrl,
                decoration: const InputDecoration(labelText: 'Instructions', hintText: 'Consignes pour les eleves...'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
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
                    child: Text('Ajoute des questions a cet exercice', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                  ),
                ),
              ..._questions.asMap().entries.map((e) {
                final i = e.key;
                final q = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                              color: EduCamColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EduCamColors.accent))),
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
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: q.pointsCtrl,
                          decoration: const InputDecoration(hintText: 'Points', contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Creer l\'exercice'),
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

class _QuestionField {
  final TextEditingController textCtrl;
  final TextEditingController pointsCtrl;
  _QuestionField({required this.textCtrl, required this.pointsCtrl});
}
