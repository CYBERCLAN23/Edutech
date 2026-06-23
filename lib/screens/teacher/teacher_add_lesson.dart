import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';

class TeacherAddLesson extends StatefulWidget {
  final String courseId;
  const TeacherAddLesson({super.key, required this.courseId});

  @override
  State<TeacherAddLesson> createState() => _TeacherAddLessonState();
}

class _TeacherAddLessonState extends State<TeacherAddLesson> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  ContentType _type = ContentType.video;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    DataStore().materials.add(CourseMaterial(
      id: 'mat-${DateTime.now().millisecondsSinceEpoch}',
      courseId: widget.courseId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      type: _type,
      url: _urlCtrl.text.trim(),
      addedAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lecon ajoutee avec succes'),
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
        title: const Text('Ajouter une lecon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
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
              const Text('Type de contenu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.play_circle_rounded,
                      label: 'Video',
                      selected: _type == ContentType.video,
                      onTap: () => setState(() => _type = ContentType.video),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.picture_as_pdf_rounded,
                      label: 'PDF',
                      selected: _type == ContentType.pdf,
                      onTap: () => setState(() => _type = ContentType.pdf),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre de la lecon', hintText: 'Ex: Equations du 2nd degre'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'Resume du contenu...'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlCtrl,
                decoration: InputDecoration(
                  labelText: _type == ContentType.video ? 'Lien video (YouTube, etc.)' : 'Lien PDF',
                  hintText: _type == ContentType.video ? 'https://youtube.com/...' : 'https://...',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Ajouter la lecon'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon; final String label; final bool selected; final VoidCallback onTap;
  const _TypeCard({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected ? EduCamColors.accent.withValues(alpha: 0.08) : EduCamColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? EduCamColors.accent : EduCamColors.cardBorder,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: selected ? EduCamColors.accent : EduCamColors.secondaryText),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? EduCamColors.accent : EduCamColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}
