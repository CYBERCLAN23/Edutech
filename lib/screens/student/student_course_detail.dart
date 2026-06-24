import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/widgets/offline_pill.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/services/local_storage_service.dart';
import 'package:educam_ai/screens/student/student_take_quiz.dart';

class StudentCourseDetail extends StatefulWidget {
  final String courseName;
  final Color courseColor;
  final IconData courseIcon;
  final String courseId;

  const StudentCourseDetail({
    super.key,
    required this.courseName,
    required this.courseColor,
    required this.courseIcon,
    required this.courseId,
  });

  @override
  State<StudentCourseDetail> createState() => _StudentCourseDetailState();
}

class _StudentCourseDetailState extends State<StudentCourseDetail> {
  final _store = DataStore();
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final materials = _store.getMaterialsForCourse(widget.courseId);
    final exercises = _store.getExercisesForCourse(widget.courseId);
    final quizzes = _store.getQuizzesForCourse(widget.courseId);
    final exams = _store.getExamsForCourse(widget.courseId);

    return Scaffold(
      backgroundColor: EduCamColors.background,
      appBar: AppBar(
        backgroundColor: EduCamColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
          child: const Padding(padding: EdgeInsets.all(16), child: Icon(Icons.arrow_back_rounded, color: EduCamColors.primary)),
        ),
        title: Text(widget.courseName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: ['Lecons', 'Exercices', 'Quiz', 'Annales'].asMap().entries.map((e) {
                  final i = e.key; final label = e.value;
                  final sel = _tab == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () { HapticFeedback.lightImpact(); setState(() => _tab = i); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: sel ? widget.courseColor : Colors.transparent, width: 2)),
                        ),
                        child: Text(label, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                            color: sel ? widget.courseColor : EduCamColors.secondaryText)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: _tab == 0 ? _buildLessons(materials)
                    : _tab == 1 ? _buildExercises(exercises)
                    : _tab == 2 ? _buildQuizzes(quizzes)
                    : _buildExams(exams),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessons(List<CourseMaterial> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lecons disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
        const SizedBox(height: 4),
        Text('${items.length} lecons', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
        const SizedBox(height: 16),
        if (items.isEmpty)
          _emptyState('Aucune lecon pour le moment')
        else
          ...items.asMap().entries.map((e) {
            final m = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: widget.courseColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(m.type == ContentType.video ? Icons.play_circle_rounded : Icons.picture_as_pdf_rounded, size: 18, color: widget.courseColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(m.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary))),
                    ]),
                    if (m.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(m.description, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    ],
                    const SizedBox(height: 12),
                    Row(children: [
                      _ActionChip(icon: Icons.visibility_rounded, label: 'Voir', color: widget.courseColor),
                      const SizedBox(width: 8),
                      _ActionChip(icon: Icons.videocam_rounded, label: 'Convertir en video', color: EduCamColors.highlight),
                    ]),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildExercises(List<Exercise> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Exercices a faire', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
        const SizedBox(height: 4),
        Text('${items.length} exercices', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
        const SizedBox(height: 16),
        if (items.isEmpty)
          _emptyState('Aucun exercice pour le moment')
        else
          ...items.asMap().entries.map((e) {
            final ex = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                    const SizedBox(height: 4),
                    Text('${ex.questions.length} questions - ${ex.totalPoints} pts', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    if (ex.instructions.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(ex.instructions, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText, height: 1.3)),
                    ],
                    const SizedBox(height: 12),
                    Row(children: [
                      _ActionChip(icon: Icons.play_arrow_rounded, label: 'Commencer', color: widget.courseColor),
                    ]),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildQuizzes(List<Quiz> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quiz disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
        const SizedBox(height: 4),
        Text('${items.length} quiz', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
        const SizedBox(height: 16),
        if (items.isEmpty)
          _emptyState('Aucun quiz pour le moment')
        else
          ...items.asMap().entries.map((e) {
            final q = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => StudentTakeQuiz(
                          quiz: q,
                          courseColor: widget.courseColor,
                          courseId: widget.courseId,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: EduCamColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(color: widget.courseColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.quiz_rounded, size: 18, color: widget.courseColor),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(q.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                              const SizedBox(height: 2),
                              Text('${q.questions.length} questions - ${q.timeLimitMinutes} min', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                            ])),
                            const Icon(Icons.chevron_right_rounded, size: 18, color: EduCamColors.secondaryText),
                          ]),
                          const SizedBox(height: 8),
                          _buildResourceOfflineIndicator(q.id),
                        ],
                      ),
                    ),
                  ),
            );
          }),
      ],
    );
  }

  Widget _buildExams(List<ExamPaper> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Annales et examens', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
              const SizedBox(height: 4),
              Text('${items.length} sujets', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: EduCamColors.highlight.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: const Text('NOUVEAU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EduCamColors.highlight)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          _emptyState('Aucune annales disponibles')
        else
          ...items.asMap().entries.map((e) {
            final exam = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: EduCamColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.assignment_rounded, size: 18, color: EduCamColors.error),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(exam.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                      const SizedBox(height: 2),
                      Text('${exam.year} - ${exam.description ?? "Annales BAC"}', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    ])),
                  ]),
                  const SizedBox(height: 10),
                  _ActionChip(icon: Icons.download_rounded, label: 'Telecharger le PDF', color: widget.courseColor),
                ]),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildResourceOfflineIndicator(String resourceId) {
    final resource = LocalStorageService().getResource(resourceId);
    final isOffline = resource != null;
    return Row(
      children: [
        if (isOffline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: EduCamColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.offline_pin_rounded, size: 10, color: EduCamColors.success),
                const SizedBox(width: 3),
                Text('Disponible hors ligne', style: TextStyle(fontSize: 9, color: EduCamColors.success)),
              ],
            ),
          )
        else
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              final storage = LocalStorageService();
              await storage.saveResource({
                'id': resourceId,
                'type': 'quiz',
                'download_time': DateTime.now().toIso8601String(),
              });
              if (mounted) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Quiz disponible hors ligne'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: EduCamColors.success,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: EduCamColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded, size: 10, color: EduCamColors.accent),
                  const SizedBox(width: 3),
                  Text('Hors ligne', style: TextStyle(fontSize: 9, color: EduCamColors.accent)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyState(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(child: Column(children: [
        Icon(Icons.inbox_rounded, size: 48, color: EduCamColors.secondaryText.withOpacity(0.3)),
        const SizedBox(height: 12),
        Text(msg, style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText.withOpacity(0.6))),
      ])),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _ActionChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (label == 'Convertir en video') {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: EduCamColors.cardBorder, borderRadius: BorderRadius.circular(2))),
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(color: EduCamColors.highlight.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.auto_awesome_rounded, size: 28, color: EduCamColors.highlight),
                  ),
                  const SizedBox(height: 16),
                  const Text('Conversion en cours...', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  const SizedBox(height: 8),
                  const Text('Notre IA prepare une version video de ce cours', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(backgroundColor: EduCamColors.progressTrack, valueColor: AlwaysStoppedAnimation(EduCamColors.highlight)),
                  const SizedBox(height: 8),
                  const Text('Generation en cours...', style: TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                    child: Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: EduCamColors.highlight.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('Fermer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.highlight))),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (label == 'Voir') {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: EduCamColors.cardBorder, borderRadius: BorderRadius.circular(2))),
                  const Text('Contenu du cours', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity, height: 180,
                    decoration: BoxDecoration(
                      color: EduCamColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_rounded, size: 48, color: color.withOpacity(0.4)),
                          const SizedBox(height: 8),
                          Text('Apercu du cours', style: TextStyle(fontSize: 13, color: color.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () { Navigator.pop(context); },
                    child: Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text('Continuer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color))),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(label.startsWith('Telecharger') ? 'Telechargement en cours...' : 'Action en cours...'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: EduCamColors.primary,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
