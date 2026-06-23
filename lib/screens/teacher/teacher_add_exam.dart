import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';

class TeacherAddExam extends StatefulWidget {
  final String courseId;
  const TeacherAddExam({super.key, required this.courseId});

  @override
  State<TeacherAddExam> createState() => _TeacherAddExamState();
}

class _TeacherAddExamState extends State<TeacherAddExam> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    _descCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    DataStore().examPapers.add(ExamPaper(
      id: 'exam-${DateTime.now().millisecondsSinceEpoch}',
      courseId: widget.courseId,
      title: _titleCtrl.text.trim(),
      year: _yearCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      pdfUrl: _urlCtrl.text.trim(),
      addedAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Annales ajoutees avec succes"),
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
        title: const Text("Ajouter des annales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
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
                decoration: const InputDecoration(labelText: "Titre de l'epreuve", hintText: 'Ex: BAC Mathematiques 2024'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 140,
                child: TextFormField(
                  controller: _yearCtrl,
                  decoration: const InputDecoration(labelText: 'Annee', hintText: '2024'),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'Sujet de...'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lien PDF',
                  hintText: 'https://...',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Ajouter l'epreuve"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
