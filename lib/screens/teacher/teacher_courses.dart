import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/screens/teacher/teacher_course_detail.dart';

class TeacherCourses extends StatelessWidget {
  const TeacherCourses({super.key});

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final courses = DataStore().courses;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggerItem(
                  index: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mes cours', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                          SizedBox(height: 4),
                          Text('4 classes, 6 matieres', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Ajouter un cours - Bientot disponible'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              duration: const Duration(milliseconds: 1500),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: EduCamColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded, size: 20, color: EduCamColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...courses.asMap().entries.map((e) {
                  final i = e.key;
                  final course = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: StaggerItem(
                      index: i + 1,
                      child: _CourseCard(
                        course: course,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TeacherCourseDetail(course: course),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final TeacherCourse course;
  final VoidCallback onTap;
  const _CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = course.progress;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: course.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(course.icon, size: 22, color: course.color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.subjectName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                      const SizedBox(height: 2),
                      Text('${course.className} - ${course.completedLessons}/${course.totalLessons} lecons', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${course.completedLessons}/${course.totalLessons} lecons', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: course.color)),
                Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: course.color)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: EduCamColors.progressTrack,
                valueColor: AlwaysStoppedAnimation<Color>(course.color),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ActionChip(icon: Icons.menu_book_rounded, label: 'Lecons', color: course.color),
                const SizedBox(width: 8),
                _ActionChip(icon: Icons.edit_note_rounded, label: 'Exercices', color: course.color),
                const SizedBox(width: 8),
                _ActionChip(icon: Icons.quiz_rounded, label: 'Quiz', color: course.color),
                const SizedBox(width: 8),
                _ActionChip(icon: Icons.history_edu_rounded, label: 'Annales', color: course.color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _ActionChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
