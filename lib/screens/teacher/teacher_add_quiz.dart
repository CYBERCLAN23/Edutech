import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/screens/teacher/teacher_quiz_review.dart';

class TeacherAddQuiz extends StatefulWidget {
  final String courseId;
  final String? courseName;
  const TeacherAddQuiz({super.key, required this.courseId, this.courseName});

  @override
  State<TeacherAddQuiz> createState() => _TeacherAddQuizState();
}

class _TeacherAddQuizState extends State<TeacherAddQuiz> {
  final _titleCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '30');
  final _subjectCtrl = TextEditingController();
  final _aiTopicCtrl = TextEditingController();

  final _questions = <QItem>[];
  int _nextId = 1;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _durationCtrl.dispose();
    _subjectCtrl.dispose();
    _aiTopicCtrl.dispose();
    for (final q in _questions) {
      q.textCtrl.dispose();
      for (final o in q.optionCtrls) o.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    HapticFeedback.lightImpact();
    setState(() {
      _questions.add(QItem(
        id: _nextId++,
        isMultipleChoice: true,
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

  void _removeQuestion(int id) {
    HapticFeedback.lightImpact();
    final q = _questions.firstWhere((e) => e.id == id);
    q.textCtrl.dispose();
    for (final o in q.optionCtrls) o.dispose();
    setState(() => _questions.removeWhere((e) => e.id == id));
  }

  void _addTrueFalse() {
    HapticFeedback.lightImpact();
    setState(() {
      _questions.add(QItem(
        id: _nextId++,
        isMultipleChoice: false,
        textCtrl: TextEditingController(),
        optionCtrls: [
          TextEditingController(text: 'True'),
          TextEditingController(text: 'False'),
        ],
        correctIndex: 0,
      ));
    });
  }

  void _publish() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a quiz title'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF191C1E),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => TeacherQuizReview(
        courseId: widget.courseId,
        courseName: widget.courseName ?? '',
        title: _titleCtrl.text.trim(),
        subject: _subjectCtrl.text.trim().isEmpty ? 'Science' : _subjectCtrl.text.trim(),
        duration: int.tryParse(_durationCtrl.text) ?? 30,
        questionCount: _questions.length,
        questions: _questions,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final subjects = ['Science', 'Mathematics', 'Literature', 'History'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(24, 16, 24, isWide ? 32 : 120),
                child: isWide ? _buildWideLayout(subjects) : _buildNarrowLayout(subjects),
              ),
            ),
            _buildBottomBar(isWide),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(List<String> subjects) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 24),
                  _buildBasicInfo(subjects),
                  const SizedBox(height: 24),
                  _buildAIMagicSection(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: constraints.maxWidth * 0.58 - 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
                  _buildQuestionList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNarrowLayout(List<String> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        const SizedBox(height: 24),
        _buildBasicInfo(subjects),
        const SizedBox(height: 24),
        _buildAIMagicSection(),
        const SizedBox(height: 32),
        _buildQuestionList(),
      ],
    );
  }

  Widget _buildTopBar() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00677F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 22, color: Color(0xFF00677F)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Create Quiz',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(List<String> subjects) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 32, decoration: BoxDecoration(color: const Color(0xFF00677F), borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 12),
              const Text('Basic Info', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('Quiz Title'),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. Introduction to Quantum Physics',
                hintStyle: const TextStyle(color: Color(0xFF6C797F)),
                filled: true,
                fillColor: const Color(0xFFF2F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Subject'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: DropdownButtonFormField<String>(
                      value: _subjectCtrl.text.isEmpty ? null : _subjectCtrl.text,
                      decoration: InputDecoration(
                        hintText: 'Science',
                        hintStyle: const TextStyle(color: Color(0xFF6C797F)),
                        filled: true,
                        fillColor: const Color(0xFFF2F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) {
                        if (v != null) _subjectCtrl.text = v;
                      },
                    ),
                  ),
                ],
              )),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Duration (Min)'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: TextField(
                      controller: _durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
    );
  }

  Widget _buildAIMagicSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF00D2FF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00677F).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 28, color: Color(0xFF00677F)),
              const SizedBox(width: 12),
              const Text('AI Magic Generator',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF00566A))),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Paste a topic or upload a lecture PDF, and EduCam AI will draft professional questions instantly.',
            style: TextStyle(fontSize: 14, color: Color(0xFF00566A))),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: TextField(
              controller: _aiTopicCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter topic or keywords...',
                hintStyle: TextStyle(color: const Color(0xFF00677F).withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.4),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('PDF upload coming soon'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        ),
                      );
                    },
                    icon: const Icon(Icons.upload_file, size: 20, color: Color(0xFF00677F)),
                    label: const Text('Upload PDF', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF00677F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _simulateAIGenerate(),
                    icon: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
                    label: const Text('Generate', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00677F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 4,
                      shadowColor: const Color(0xFF00677F).withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _simulateAIGenerate() {
    HapticFeedback.mediumImpact();
    if (_aiTopicCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a topic first'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF191C1E),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
          SizedBox(width: 12),
          Text('AI generating questions...'),
        ]),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF191C1E),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      _addQuestion();
      _addQuestion();
    });
  }

  Widget _buildQuestionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 8, height: 32, decoration: BoxDecoration(color: const Color(0xFF406900), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 12),
                const Text('Question List',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E3E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${_questions.length.toString().padLeft(2, '0')} Items',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'mcq') _addQuestion();
                if (v == 'tf') _addTrueFalse();
              },
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'mcq', child: Row(children: [Icon(Icons.list_alt_rounded, size: 18), SizedBox(width: 10), Text('Multiple Choice')])),
                const PopupMenuItem(value: 'tf', child: Row(children: [Icon(Icons.toggle_on_rounded, size: 18), SizedBox(width: 10), Text('True / False')])),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00677F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_rounded, size: 18, color: Color(0xFF00677F)),
                    SizedBox(width: 6),
                    Text('New Question', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_questions.isEmpty)
          GestureDetector(
            onTap: _addQuestion,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBBC9CF).withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline_rounded, size: 48, color: const Color(0xFF6C797F).withOpacity(0.5)),
                    const SizedBox(height: 12),
                    const Text('Drag components here or click to add manually',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6C797F))),
                  ],
                ),
              ),
            ),
          )
        else
          ..._questions.asMap().entries.map((e) {
            final i = e.key;
            final q = e.value;
            final qNum = i + 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40, offset: const Offset(0, 10))],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        decoration: BoxDecoration(
                          color: q.isMultipleChoice ? const Color(0xFF00677F) : const Color(0xFF87D600),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 20, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Question ${qNum.toString().padLeft(2, '0')} \u2022 ${q.isMultipleChoice ? 'Multiple Choice' : 'True / False'}',
                                    style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5,
                                      color: q.isMultipleChoice ? const Color(0xFF00677F) : const Color(0xFF406900))),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _removeQuestion(q.id),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBA1A1A).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.delete_rounded, size: 16, color: Color(0xFFBA1A1A)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 48,
                                child: TextField(
                                  controller: q.textCtrl,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your question...',
                                    hintStyle: const TextStyle(color: Color(0xFF6C797F), fontSize: 16),
                                    filled: true,
                                    fillColor: const Color(0xFFF2F4F6),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...q.optionCtrls.asMap().entries.map((oe) {
                                final oi = oe.key;
                                final isCorrect = q.correctIndex == oi;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => q.correctIndex = oi),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isCorrect ? const Color(0xFF406900).withOpacity(0.08) : const Color(0xFFF2F4F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: isCorrect ? const Color(0xFF406900).withOpacity(0.3) : Colors.transparent),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28, height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isCorrect ? const Color(0xFF406900) : const Color(0xFFBBC9CF),
                                            ),
                                            child: isCorrect
                                              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                              : Center(child: Text(String.fromCharCode(65 + oi),
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: SizedBox(
                                              height: 40,
                                              child: TextField(
                                                controller: q.optionCtrls[oi],
                                                decoration: InputDecoration(
                                                  hintText: 'Option ${String.fromCharCode(65 + oi)}',
                                                  hintStyle: const TextStyle(color: Color(0xFF6C797F)),
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (isCorrect)
                                            const Text('Correct', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF406900))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        if (_questions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: _addQuestion,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFBBC9CF).withOpacity(0.3), width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 24, color: const Color(0xFF6C797F).withOpacity(0.5)),
                      const SizedBox(width: 8),
                      const Text('Add another question',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6C797F))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (_questions.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF65A1FE).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFA9C7FF).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF055DB6)),
                          const SizedBox(width: 6),
                          const Text('Difficulty Score', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF055DB6))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Medium', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF003670))),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          backgroundColor: const Color(0xFFD6E3FF).withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF055DB6)),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87D600).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF9FFB00).withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_rounded, size: 16, color: Color(0xFF406900)),
                          const SizedBox(width: 6),
                          const Text('AI Insights', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF406900))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Questions target 3 cognitive domains. Consider adding 1 more analytical question.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF3C494E))),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomBar(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB).withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.5))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Auto-saved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
                    Text('12:45 PM Today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                  ],
                ),
                const SizedBox(width: 24),
                Container(width: 1, height: 40, color: const Color(0xFFBBC9CF).withOpacity(0.3)),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: const Row(
                    children: [
                      Icon(Icons.visibility_rounded, size: 20, color: Color(0xFF3C494E)),
                      SizedBox(width: 6),
                      Text('Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF3C494E))),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Draft saved'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF191C1E),
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E3E5),
                      foregroundColor: const Color(0xFF191C1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                    child: const Text('Save Draft', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00677F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 8,
                      shadowColor: const Color(0xFF00677F).withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                    ),
                    child: const Text('Publish Quiz', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QItem {
  final int id;
  bool isMultipleChoice;
  final TextEditingController textCtrl;
  final List<TextEditingController> optionCtrls;
  int correctIndex;

  QItem({
    required this.id,
    required this.isMultipleChoice,
    required this.textCtrl,
    required this.optionCtrls,
    this.correctIndex = 0,
  });
}
