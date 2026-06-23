import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/screens/teacher/teacher_add_lesson.dart';
import 'package:educam_ai/screens/teacher/teacher_add_exercise.dart';
import 'package:educam_ai/screens/teacher/teacher_add_quiz.dart';
import 'package:educam_ai/screens/teacher/teacher_add_exam.dart';

class TeacherCourseDetail extends StatefulWidget {
  final TeacherCourse course;
  const TeacherCourseDetail({super.key, required this.course});

  @override
  State<TeacherCourseDetail> createState() => _TeacherCourseDetailState();
}

class _TeacherCourseDetailState extends State<TeacherCourseDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _store = DataStore();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.subjectName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
            Text(c.className, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText, fontWeight: FontWeight.w400)),
          ],
        ),
        backgroundColor: EduCamColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: EduCamColors.primary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: EduCamColors.accent,
          unselectedLabelColor: EduCamColors.secondaryText,
          indicatorColor: EduCamColors.accent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Lecons', icon: Icon(Icons.menu_book_rounded, size: 18)),
            Tab(text: 'Exercices', icon: Icon(Icons.edit_note_rounded, size: 18)),
            Tab(text: 'Quiz', icon: Icon(Icons.quiz_rounded, size: 18)),
            Tab(text: 'Annales', icon: Icon(Icons.history_edu_rounded, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LessonsTab(courseId: c.id, store: _store),
          _ExercisesTab(courseId: c.id, store: _store),
          _QuizzesTab(courseId: c.id, store: _store),
          _ExamsTab(courseId: c.id, store: _store),
        ],
      ),
    );
  }
}

class _LessonsTab extends StatelessWidget {
  final String courseId;
  final DataStore store;
  const _LessonsTab({required this.courseId, required this.store});

  @override
  Widget build(BuildContext context) {
    final items = store.getMaterialsForCourse(courseId);
    return _ContentList(
      items: items,
      emptyIcon: Icons.video_library_rounded,
      emptyTitle: 'Aucune lecon',
      emptySubtitle: 'Ajoute des videos et PDF pour tes eleves',
      onAdd: () => _navigateTo(context, TeacherAddLesson(courseId: courseId)),
      itemBuilder: (m) => _MaterialTile(material: m),
    );
  }
}

class _ExercisesTab extends StatelessWidget {
  final String courseId;
  final DataStore store;
  const _ExercisesTab({required this.courseId, required this.store});

  @override
  Widget build(BuildContext context) {
    final items = store.getExercisesForCourse(courseId);
    return _ContentList(
      items: items,
      emptyIcon: Icons.edit_note_rounded,
      emptyTitle: 'Aucun exercice',
      emptySubtitle: 'Cree des exercices pour tes eleves',
      onAdd: () => _navigateTo(context, TeacherAddExercise(courseId: courseId)),
      itemBuilder: (e) => _ExerciseTile(exercise: e),
    );
  }
}

class _QuizzesTab extends StatelessWidget {
  final String courseId;
  final DataStore store;
  const _QuizzesTab({required this.courseId, required this.store});

  @override
  Widget build(BuildContext context) {
    final items = store.getQuizzesForCourse(courseId);
    return _ContentList(
      items: items,
      emptyIcon: Icons.quiz_rounded,
      emptyTitle: 'Aucun quiz',
      emptySubtitle: 'Cree des mini-quiz QCM pour tes eleves',
      onAdd: () => _navigateTo(context, TeacherAddQuiz(courseId: courseId)),
      itemBuilder: (q) => _QuizTile(quiz: q),
    );
  }
}

class _ExamsTab extends StatelessWidget {
  final String courseId;
  final DataStore store;
  const _ExamsTab({required this.courseId, required this.store});

  @override
  Widget build(BuildContext context) {
    final items = store.getExamsForCourse(courseId);
    return _ContentList(
      items: items,
      emptyIcon: Icons.history_edu_rounded,
      emptyTitle: "Aucune annaLe",
      emptySubtitle: 'Ajoute des annales et sujets d\'examen',
      onAdd: () => _navigateTo(context, TeacherAddExam(courseId: courseId)),
      itemBuilder: (e) => _ExamTile(exam: e),
    );
  }
}

void _navigateTo(BuildContext context, Widget screen) {
  HapticFeedback.lightImpact();
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => screen),
  );
}

class _ContentList extends StatelessWidget {
  final List<dynamic> items;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final VoidCallback onAdd;
  final Widget Function(dynamic) itemBuilder;

  const _ContentList({
    required this.items,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onAdd,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduCamColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        backgroundColor: EduCamColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: EduCamColors.accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(emptyIcon, size: 36, color: EduCamColors.accent.withValues(alpha: 0.5)),
                    ),
                    const SizedBox(height: 20),
                    Text(emptyTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                    const SizedBox(height: 8),
                    Text(emptySubtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StaggerItem(index: index, child: itemBuilder(items[index])),
                );
              },
            ),
    );
  }
}

class _MaterialTile extends StatelessWidget {
  final CourseMaterial material;
  const _MaterialTile({required this.material});

  @override
  Widget build(BuildContext context) {
    final isVideo = material.type == ContentType.video;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: (isVideo ? EduCamColors.accent : EduCamColors.highlight).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(isVideo ? Icons.play_circle_rounded : Icons.picture_as_pdf_rounded, size: 22, color: isVideo ? EduCamColors.accent : EduCamColors.highlight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(material.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                const SizedBox(height: 2),
                Text(material.description, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(isVideo ? 'Video' : 'PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isVideo ? EduCamColors.accent : EduCamColors.highlight)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: EduCamColors.subjectMaths.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note_rounded, size: 22, color: EduCamColors.subjectMaths),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                const SizedBox(height: 2),
                Text('${exercise.questions.length} questions - ${exercise.totalPoints} pts', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
        ],
      ),
    );
  }
}

class _QuizTile extends StatelessWidget {
  final Quiz quiz;
  const _QuizTile({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: EduCamColors.highlight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.quiz_rounded, size: 22, color: EduCamColors.highlight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quiz.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                const SizedBox(height: 2),
                Text('${quiz.questions.length} questions - ${quiz.timeLimitMinutes} min', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
        ],
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  final ExamPaper exam;
  const _ExamTile({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: EduCamColors.subjectSVT.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.history_edu_rounded, size: 22, color: EduCamColors.subjectSVT),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                const SizedBox(height: 2),
                Text('${exam.year}${exam.description != null ? ' - ${exam.description}' : ''}', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
        ],
      ),
    );
  }
}
