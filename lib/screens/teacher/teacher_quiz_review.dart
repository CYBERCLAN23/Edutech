import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/screens/teacher/teacher_add_quiz.dart';

class TeacherQuizReview extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String title;
  final String subject;
  final int duration;
  final int questionCount;
  final List<QItem> questions;

  const TeacherQuizReview({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.title,
    required this.subject,
    required this.duration,
    required this.questionCount,
    required this.questions,
  });

  @override
  State<TeacherQuizReview> createState() => _TeacherQuizReviewState();
}

class _TeacherQuizReviewState extends State<TeacherQuizReview> {
  bool _randomize = true;
  bool _allowLate = false;
  double _weight = 15;

  void _publish() {
    HapticFeedback.mediumImpact();
    final store = DataStore();
    store.quizzes.add(Quiz(
      id: 'quiz-${DateTime.now().millisecondsSinceEpoch}',
      courseId: widget.courseId,
      title: widget.title,
      subject: widget.subject,
      questions: widget.questions.map((q) => QuizQuestion(
        text: q.textCtrl.text.trim(),
        options: q.optionCtrls.map((o) => o.text.trim()).toList(),
        correctIndex: q.correctIndex,
      )).toList(),
      timeLimitMinutes: widget.duration,
      status: QuizStatus.active,
      avgScore: 0,
      studentCount: 0,
      totalStudents: 32,
      createdAt: DateTime.now(),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quiz published successfully!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF406900),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      ),
    );
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB).withValues(alpha: 0.7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.arrow_back_rounded, color: Color(0xFF00677F)),
          ),
        ),
        title: const Text('Final Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00D2FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.rocket_launch_rounded, size: 14, color: Color(0xFF00677F)),
                SizedBox(width: 6),
                Text('Publish Quiz', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBreadcrumbs(),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildExamConfig(),
                  const SizedBox(height: 24),
                  _buildClassAssignment(),
                  const SizedBox(height: 32),
                  _buildQuestionsPreview(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: constraints.maxWidth * 0.42 - 24,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  _buildSummaryCard(),
                  const SizedBox(height: 16),
                  _buildProcessingChip(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumbs(),
        _buildHeader(),
        const SizedBox(height: 24),
        _buildExamConfig(),
        const SizedBox(height: 24),
        _buildClassAssignment(),
        const SizedBox(height: 24),
        _buildSummaryCard(),
        const SizedBox(height: 16),
        _buildProcessingChip(),
        const SizedBox(height: 32),
        _buildQuestionsPreview(),
      ],
    );
  }

  Widget _buildBreadcrumbs() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, size: 14, color: Color(0xFF6C797F)),
          const SizedBox(width: 4),
          Text(widget.courseName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6C797F), letterSpacing: 1)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF6C797F)),
          const SizedBox(width: 4),
          const Text('Final Review', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00677F), letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Publish Quiz:',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
        Text(widget.title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
        const SizedBox(height: 8),
        Text('Review your questions and configure final administration settings before sending this assessment to your students.',
          style: const TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
      ],
    );
  }

  Widget _buildExamConfig() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB6EBFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings_rounded, size: 20, color: Color(0xFF00677F)),
              ),
              const SizedBox(width: 12),
              const Text('Exam Configuration',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 24),
          _buildToggleTile(
            icon: Icons.shuffle_rounded,
            title: 'Question Randomization',
            subtitle: 'Shuffle question order and answer choices for each student.',
            value: _randomize,
            onChanged: (v) => setState(() => _randomize = v),
          ),
          const SizedBox(height: 12),
          _buildToggleTile(
            icon: Icons.update_rounded,
            title: 'Late Submissions',
            subtitle: 'Allow students to submit after the deadline with a penalty.',
            value: _allowLate,
            onChanged: (v) => setState(() => _allowLate = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.percent_rounded, size: 20, color: Color(0xFF3C494E)),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Grading Weight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
                        Text('Relative importance of this quiz in the final grade.', style: TextStyle(fontSize: 12, color: Color(0xFF3C494E))),
                      ],
                    )),
                    Text('${_weight.round()}%',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF00677F),
                    inactiveTrackColor: const Color(0xFFBBC9CF).withValues(alpha: 0.3),
                    thumbColor: const Color(0xFF00677F),
                    overlayColor: const Color(0xFF00677F).withValues(alpha: 0.1),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _weight,
                    min: 5,
                    max: 50,
                    divisions: 9,
                    label: '${_weight.round()}%',
                    onChanged: (v) => setState(() => _weight = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Light (5%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                      const Text('Standard (20%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                      Text('High Impact (50%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon, required String title, required String subtitle,
    required bool value, required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF00677F).withValues(alpha: 0.04) : const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF00677F).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF3C494E)),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF3C494E))),
            ],
          )),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00677F),
            activeTrackColor: const Color(0xFF00677F).withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildClassAssignment() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB6EBFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.groups_rounded, size: 20, color: Color(0xFF00677F)),
              ),
              const SizedBox(width: 12),
              const Text('Class Destination',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00677F), width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF00677F).withValues(alpha: 0.06),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 24, color: const Color(0xFF00677F)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.courseName, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                          const Text('32 Students Enrolled', style: TextStyle(fontSize: 12, color: Color(0xFF3C494E))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF00677F), Color(0xFF055DB6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('QUIZ SUMMARY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Colors.white70)),
                  SizedBox(height: 4),
                  Text('Final Pre-Check', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _SummaryRow(label: 'Questions', value: '${widget.questionCount} Items'),
                _SummaryRow(label: 'Est. Duration', value: '${widget.duration} Minutes'),
                _SummaryRow(label: 'Difficulty Level', value: 'Intermediate',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) => Icon(
                      i < 3 ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 16, color: const Color(0xFF406900),
                    )),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E3E5).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBC9CF).withValues(alpha: 0.5), style: BorderStyle.solid),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI INSIGHTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: Color(0xFF3C494E))),
                      const SizedBox(height: 6),
                      Text('"The quiz focuses heavily on ${widget.subject}. Ensure students have reviewed the relevant notes."',
                        style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: const Color(0xFF191C1E).withValues(alpha: 0.8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _publish,
                    icon: const Icon(Icons.rocket_launch_rounded, size: 22),
                    label: const Text('Publish to Class', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00677F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 8,
                      shadowColor: const Color(0xFF00677F).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => HapticFeedback.lightImpact(),
                    icon: const Icon(Icons.visibility_rounded, size: 20),
                    label: const Text('Student Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3C494E),
                      backgroundColor: const Color(0xFFE0E3E5),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingChip() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00677F).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF00677F).withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00677F),
              ),
            ),
            const SizedBox(width: 8),
            const Text('AI Optimization Ready',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00677F), letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Questions Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                const SizedBox(height: 4),
                const Text('Tap any card to quick-edit text or images.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
              ],
            ),
            GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: const Row(
                children: [
                  Text('View All Items', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF00677F)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              ...widget.questions.asMap().entries.map((e) {
                final q = e.value;
                return Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 16),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB6EBFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Q${e.key + 1} - ${q.isMultipleChoice ? 'Multiple Choice' : 'True/False'}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF004E60)),
                            ),
                          ),
                          const Text('4 pts', style: TextStyle(fontSize: 11, color: Color(0xFF3C494E))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q.textCtrl.text.isEmpty ? 'Enter question text...' : q.textCtrl.text,
                        maxLines: 3, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                      const SizedBox(height: 12),
                      ...q.optionCtrls.take(2).toList().asMap().entries.map((oe) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: oe.key == q.correctIndex ? const Color(0xFF406900).withValues(alpha: 0.1) : const Color(0xFFF2F4F6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: oe.key == q.correctIndex ? const Color(0xFF406900).withValues(alpha: 0.2) : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            oe.value.text.isEmpty ? 'Option ${String.fromCharCode(65 + oe.key)}' : oe.value.text,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: oe.key == q.correctIndex ? FontWeight.w600 : FontWeight.w400,
                              color: oe.key == q.correctIndex ? const Color(0xFF406900) : const Color(0xFF3C494E),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                );
              }),
              Container(
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFBBC9CF).withValues(alpha: 0.3), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline_rounded, size: 32, color: Color(0xFF6C797F)),
                        SizedBox(height: 8),
                        Text('Add New', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label; final String value; final Widget? trailing;
  const _SummaryRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
          trailing ?? Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
        ],
        ),
    );
  }
}
