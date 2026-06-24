import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/screens/teacher/teacher_add_quiz.dart';

class TeacherQuizLibrary extends StatefulWidget {
  final String? courseId;
  final String? courseName;
  const TeacherQuizLibrary({super.key, this.courseId, this.courseName});

  @override
  State<TeacherQuizLibrary> createState() => _TeacherQuizLibraryState();
}

class _TeacherQuizLibraryState extends State<TeacherQuizLibrary> {
  final _store = DataStore();
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<Quiz> get _quizzes {
    final all = widget.courseId != null
        ? _store.getQuizzesForCourse(widget.courseId!)
        : _store.quizzes;
    if (_searchQuery.isEmpty) return all;
    return all.where((q) =>
      q.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      q.subject.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Color _statusBg(QuizStatus s) {
    switch (s) {
      case QuizStatus.active: return const Color(0xFF87D600).withValues(alpha: 0.15);
      case QuizStatus.draft: return const Color(0xFFE0E3E5);
      case QuizStatus.completed: return const Color(0xFF00D2FF).withValues(alpha: 0.15);
    }
  }

  Color _statusText(QuizStatus s) {
    switch (s) {
      case QuizStatus.active: return const Color(0xFF355800);
      case QuizStatus.draft: return const Color(0xFF3C494E);
      case QuizStatus.completed: return const Color(0xFF004E60);
    }
  }

  IconData _quizIcon(String subject) {
    switch (subject) {
      case 'Biology': return Icons.biotech;
      case 'History': return Icons.history_edu;
      case 'Mathematics': return Icons.functions;
      default: return Icons.quiz_rounded;
    }
  }

  Color _quizColor(String subject) {
    switch (subject) {
      case 'Biology': return const Color(0xFF00677F);
      case 'History': return const Color(0xFF055DB6);
      case 'Mathematics': return const Color(0xFF406900);
      default: return const Color(0xFF00677F);
    }
  }

  Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = _quizzes;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggerItem(index: 0, child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.courseName ?? 'Quiz Library',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
                        const SizedBox(height: 4),
                        const Text('Manage your assessments and track student performance in real-time.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => TeacherAddQuiz(
                            courseId: widget.courseId ?? '',
                            courseName: widget.courseName,
                          ),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00677F), Color(0xFF055DB6)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00677F).withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle_rounded, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Create New Quiz',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 24),
                StaggerItem(index: 1, child: _buildStatsBento()),
                const SizedBox(height: 24),
                StaggerItem(index: 2, child: _buildSearchFilter()),
                const SizedBox(height: 20),
                if (quizzes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.quiz_outlined, size: 56, color: const Color(0xFF6C797F).withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          const Text('No quizzes found',
                            style: TextStyle(fontSize: 15, color: Color(0xFF3C494E))),
                        ],
                      ),
                    ),
                  )
                else
                  ...quizzes.asMap().entries.map((e) {
                    final i = e.key;
                    final q = e.value;
                    final sbg = _statusBg(q.status);
                    final stxt = _statusText(q.status);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: StaggerItem(
                        index: i + 3,
                        child: GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 40,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 64, height: 64,
                                      decoration: BoxDecoration(
                                        color: _quizColor(q.subject).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(_quizIcon(q.subject), size: 28, color: _quizColor(q.subject)),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(child: Text(q.title,
                                                style: const TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF191C1E)))),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: sbg,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(q.statusLabel,
                                                  style: TextStyle(
                                                    fontSize: 12, fontWeight: FontWeight.w700, color: stxt)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${q.questions.length} Questions${q.dueDate != null ? ' \u2022 Due: ${q.dueDate}' : ''}',
                                            style: const TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('${q.avgScore.toStringAsFixed(0)}%',
                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                                          const Text('Avg. Score', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('${q.studentCount}/${q.totalStudents}',
                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                                          const Text('Students', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE0E3E5),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Icon(Icons.bar_chart_rounded, size: 20,
                                            color: const Color(0xFF191C1E).withValues(alpha: 0.7)),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE0E3E5),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: Icon(Icons.edit_rounded, size: 20,
                                            color: const Color(0xFF191C1E).withValues(alpha: 0.7)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildStatsBento() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Column(
          children: [
            if (isWide)
              Row(
                children: [
                  Expanded(child: _StatCard(
                    icon: Icons.trending_up_rounded,
                    iconColor: const Color(0xFF00D2FF),
                    label: 'Avg. Class Score',
                    value: '84.2%',
                    progress: 0.84,
                    progressColor: const Color(0xFF00D2FF),
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _StatCard(
                    icon: Icons.group_rounded,
                    iconColor: const Color(0xFF65A1FE),
                    label: 'Participation Rate',
                    value: '92.5%',
                    progress: 0.92,
                    progressColor: const Color(0xFF65A1FE),
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _StatCard(
                    icon: Icons.task_alt_rounded,
                    iconColor: const Color(0xFF87D600),
                    label: 'Quizzes Completed',
                    value: '128',
                    badge: '+12 this month',
                    badgeColor: const Color(0xFF406900),
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _AISuggestionCard()),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _StatCard(
                        icon: Icons.trending_up_rounded,
                        iconColor: const Color(0xFF00D2FF),
                        label: 'Avg. Class Score',
                        value: '84.2%',
                        progress: 0.84,
                        progressColor: const Color(0xFF00D2FF),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(
                        icon: Icons.group_rounded,
                        iconColor: const Color(0xFF65A1FE),
                        label: 'Participation Rate',
                        value: '92.5%',
                        progress: 0.92,
                        progressColor: const Color(0xFF65A1FE),
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _StatCard(
                        icon: Icons.task_alt_rounded,
                        iconColor: const Color(0xFF87D600),
                        label: 'Quizzes Completed',
                        value: '128',
                        badge: '+12 this month',
                        badgeColor: const Color(0xFF406900),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _AISuggestionCard()),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 22, color: Color(0xFF6C797F)),
                const SizedBox(width: 12),
                Expanded(child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Search quizzes by title or topic...',
                    hintStyle: TextStyle(color: Color(0xFF6C797F), fontSize: 16),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _FilterButton(icon: Icons.filter_list_rounded, label: 'Filter'),
        const SizedBox(width: 8),
        _FilterButton(icon: Icons.sort_rounded, label: 'Sort'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String label; final String value;
  final double? progress; final Color? progressColor;
  final String? badge; final Color? badgeColor;

  const _StatCard({
    required this.icon, required this.iconColor,
    required this.label, required this.value,
    this.progress, this.progressColor,
    this.badge, this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF3C494E), letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
          if (badge != null) ...[
            const SizedBox(height: 4),
            Text(badge!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: badgeColor)),
          ],
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: progressColor!.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor!),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AISuggestionCard extends StatelessWidget {
  const _AISuggestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00677F).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, size: 36, color: Color(0xFF00677F)),
              const Spacer(),
              Icon(Icons.auto_awesome_rounded, size: 80, color: const Color(0xFF00677F).withValues(alpha: 0.08)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('AI Insight', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF3C494E), letterSpacing: 1.5)),
          const SizedBox(height: 4),
          const Text('Engagement is 15% higher on visual-based questions.',
            style: TextStyle(fontSize: 14, color: Color(0xFF00566A))),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon; final String label;
  const _FilterButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E8EA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF191C1E)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
          ],
        ),
      ),
    );
  }
}
