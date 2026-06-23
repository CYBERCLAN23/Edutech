import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/screens/teacher/teacher_add_exercise.dart';
import 'package:educam_ai/screens/teacher/teacher_add_quiz.dart';

class TeacherStudentDashboard extends StatefulWidget {
  final Student student;
  final String courseId;

  const TeacherStudentDashboard({
    super.key,
    required this.student,
    required this.courseId,
  });

  @override
  State<TeacherStudentDashboard> createState() => _TeacherStudentDashboardState();
}

class _TeacherStudentDashboardState extends State<TeacherStudentDashboard> {
  final _store = DataStore();
  late StudentGrade? _grade;
  late List<StudentRecommendation> _recs;

  @override
  void initState() {
    super.initState();
    _grade = _store.getGrade(widget.student.id, widget.courseId);
    _recs = _store.analyzeStudent(
      studentId: widget.student.id,
      courseId: widget.courseId,
      studentName: widget.student.name,
      subjectName: _grade?.subjectName ?? '',
    );
  }

  Color _statusColor(double avg) {
    if (avg >= 14) return EduCamColors.success;
    if (avg >= 10) return EduCamColors.highlight;
    return EduCamColors.error;
  }

  String _statusLabel(double avg) {
    if (avg >= 16) return 'Excellent';
    if (avg >= 14) return 'Tres bien';
    if (avg >= 12) return 'Bien';
    if (avg >= 10) return 'Moyen';
    if (avg >= 8) return 'En difficulte';
    return 'Critique';
  }

  void _onAction(String type) {
    HapticFeedback.mediumImpact();
    switch (type) {
      case 'remedial_test':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Test de rattrapage cree et assigne a l\'eleve'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: EduCamColors.primary,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          ),
        );
      case 'more_exercises':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => TeacherAddExercise(courseId: widget.courseId),
        ));
      case 'quiz':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => TeacherAddQuiz(courseId: widget.courseId),
        ));
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Recommandation envoyee au module pedagogique'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: EduCamColors.primary,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final g = _grade;
    final avg = g?.average ?? 0;
    final sc = _statusColor(avg);
    final initials = s.name.split(' ').map((e) => e[0]).join();
    final activities = _store.getRecentActivities(s.id);
    final needsHelp = _recs.isNotEmpty;

    return Scaffold(
      backgroundColor: EduCamColors.background,
      appBar: AppBar(
        backgroundColor: EduCamColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.arrow_back_rounded, color: EduCamColors.primary),
          ),
        ),
        title: const Text('Tableau de bord', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggerItem(
                index: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [sc.withValues(alpha: 0.15), sc.withValues(alpha: 0.05)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(initials, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: sc)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                            const SizedBox(height: 4),
                            Text('${s.className} - ${g?.subjectName ?? ''}', style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: sc.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_statusLabel(avg), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sc)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: StaggerItem(index: 1, child: _StatCard(label: 'Moyenne', value: avg.toStringAsFixed(1), suffix: '/20', color: sc))),
                  const SizedBox(width: 10),
                  Expanded(child: StaggerItem(index: 2, child: _StatCard(
                    label: 'Exercices',
                    value: '${g?.exercisesCompleted ?? 0}',
                    suffix: '/${g?.exercisesAssigned ?? 0}',
                    color: EduCamColors.accent,
                  ))),
                  const SizedBox(width: 10),
                  Expanded(child: StaggerItem(index: 3, child: _StatCard(
                    label: 'Quiz',
                    value: '${g?.quizzesCompleted ?? 0}',
                    suffix: '/${g?.quizzesAssigned ?? 0}',
                    color: EduCamColors.highlight,
                  ))),
                ],
              ),
              if (needsHelp) ...[
                const SizedBox(height: 24),
                StaggerItem(
                  index: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: EduCamColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, size: 16, color: EduCamColors.error),
                          ),
                          const SizedBox(width: 8),
                          const Text('Recommandations IA', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_recs.length, (i) {
                        final r = _recs[i];
                        final color = r.urgency >= 3 ? EduCamColors.error
                            : r.urgency >= 2 ? EduCamColors.highlight
                            : EduCamColors.accent;
                        return Padding(
                          padding: EdgeInsets.only(bottom: i < _recs.length - 1 ? 10 : 0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: EduCamColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: color.withValues(alpha: 0.2),
                                width: r.urgency >= 3 ? 1 : 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32, height: 32,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(r.icon, size: 16, color: color),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(r.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                                          const SizedBox(height: 4),
                                          Text(r.description, style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText, height: 1.4)),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: EduCamColors.accent.withValues(alpha: 0.06),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Sujet: ${r.topic}',
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: EduCamColors.accent.withValues(alpha: 0.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () => _onAction(r.type),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(r.icon, size: 14, color: color),
                                          const SizedBox(width: 6),
                                          Text(
                                            r.actionLabel,
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
              StaggerItem(
                index: needsHelp ? _recs.length + 4 : 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Progression', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: EduCamColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                      ),
                      child: Column(
                        children: [
                          ...List.generate(g?.recentScores.length ?? 0, (i) {
                            final raw = g!.recentScores[i];
                            final pct = raw / 20;
                            final barColor = raw >= 14 ? EduCamColors.success
                                : raw >= 10 ? EduCamColors.highlight
                                : EduCamColors.error;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText, fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: pct,
                                        minHeight: 18,
                                        backgroundColor: EduCamColors.background,
                                        valueColor: AlwaysStoppedAnimation(barColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 36,
                                    child: Text('${raw.toInt()}/20', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: barColor)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StaggerItem(
                index: needsHelp ? _recs.length + 5 : 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Activite recente', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                    const SizedBox(height: 12),
                    if (activities.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: EduCamColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                        ),
                        child: const Center(child: Text('Aucune activite recente', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText))),
                      )
                    else
                      ...List.generate(activities.length, (i) {
                        final a = activities[i];
                        final icon = a.type == 'exercice' ? Icons.edit_note_rounded
                            : a.type == 'quiz' ? Icons.quiz_rounded
                            : Icons.menu_book_rounded;
                        final statusColor = a.total > 0 && a.score / a.total >= 0.7 ? EduCamColors.success
                            : a.total > 0 && a.score / a.total >= 0.5 ? EduCamColors.highlight
                            : EduCamColors.secondaryText;
                        return Padding(
                          padding: EdgeInsets.only(bottom: i < activities.length - 1 ? 8 : 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: EduCamColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(icon, size: 16, color: statusColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(a.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                                      const SizedBox(height: 2),
                                      Text(a.dateStr, style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
                                    ],
                                  ),
                                ),
                                if (a.total > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${a.score.toInt()}/${a.total.toInt()}',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StaggerItem(
                index: needsHelp ? _recs.length + 6 : 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Statistiques globales', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: EduCamColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                      ),
                      child: Column(
                        children: [
                          _GlobalStatRow(label: 'Exercices completes', value: '${g?.exercisesCompleted ?? 0}', total: '${g?.exercisesAssigned ?? 0}',
                            pct: g != null && g.exercisesAssigned > 0 ? g.exercisesCompleted / g.exercisesAssigned : 0, color: EduCamColors.accent),
                          const SizedBox(height: 14),
                          _GlobalStatRow(label: 'Quiz completes', value: '${g?.quizzesCompleted ?? 0}', total: '${g?.quizzesAssigned ?? 0}',
                            pct: g != null && g.quizzesAssigned > 0 ? g.quizzesCompleted / g.quizzesAssigned : 0, color: EduCamColors.highlight),
                          const SizedBox(height: 14),
                          _GlobalStatRow(label: 'Derniere activite', value: g?.lastActive ?? '-', total: '',
                            pct: 0, color: EduCamColors.secondaryText, showBar: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.suffix, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
              if (suffix.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 2),
                  child: Text(suffix, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.6))),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlobalStatRow extends StatelessWidget {
  final String label;
  final String value;
  final String total;
  final double pct;
  final Color color;
  final bool showBar;

  const _GlobalStatRow({
    required this.label,
    required this.value,
    required this.total,
    required this.pct,
    required this.color,
    this.showBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13, color: EduCamColors.primary)),
        ),
        if (showBar)
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: EduCamColors.background,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        const SizedBox(width: 12),
        Text(
          total.isNotEmpty ? '$value/$total' : value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
