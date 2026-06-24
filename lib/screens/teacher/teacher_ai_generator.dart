import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherAIGenerator extends StatefulWidget {
  final String? courseId;
  const TeacherAIGenerator({super.key, this.courseId});

  @override
  State<TeacherAIGenerator> createState() => _TeacherAIGeneratorState();
}

class _TeacherAIGeneratorState extends State<TeacherAIGenerator> {
  final _topicCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  String _difficulty = 'Intermediate';
  String _count = '10 Questions';
  bool _generated = false;

  @override
  void dispose() {
    _topicCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    if (_topicCtrl.text.trim().isEmpty && _textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a topic or reference text'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF191C1E),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _generated = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
          SizedBox(width: 12),
          Text('AI is thinking...'),
        ]),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF191C1E),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _generated = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggerItem(index: 0, child: _buildHeroSection(isWide)),
              const SizedBox(height: 32),
              isWide ? _buildWideContent() : _buildNarrowContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 48 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          if (isWide)
            Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00677F).withValues(alpha: 0.08),
              ),
              child: Center(
                child: Icon(Icons.auto_awesome_rounded, size: 100, color: const Color(0xFF00677F).withValues(alpha: 0.3)),
              ),
            ),
          if (isWide) const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Magic AI Question Generator',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
                const SizedBox(height: 12),
                const Text('Transform any topic or text into professionally crafted multiple-choice questions in seconds. Let our AI handle the heavy lifting while you focus on teaching.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF3C494E))),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: [
                    _HeroBadge(icon: Icons.bolt_rounded, label: 'Auto-Explain'),
                    _HeroBadge(icon: Icons.fact_check_rounded, label: "Bloom's Taxonomy"),
                    _HeroBadge(icon: Icons.history_edu_rounded, label: 'High Quality'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.4,
              child: _buildInputPanel(),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: constraints.maxWidth * 0.6 - 24,
              child: _buildResultsPanel(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNarrowContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputPanel(),
        const SizedBox(height: 24),
        _buildResultsPanel(),
      ],
    );
  }

  Widget _buildInputPanel() {
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
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_note_rounded, size: 22, color: Color(0xFF00566A)),
              ),
              const SizedBox(width: 12),
              const Text('Input Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 24),
          _buildInputLabel('Subject Topic'),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: TextField(
              controller: _topicCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. Photosynthesis in Plants',
                hintStyle: const TextStyle(color: Color(0xFF6C797F)),
                filled: true,
                fillColor: const Color(0xFFF2F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00677F), width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInputLabel('Or Paste Reference Text'),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: TextField(
              controller: _textCtrl,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste educational content here for context-aware questions...',
                hintStyle: const TextStyle(color: Color(0xFF6C797F)),
                filled: true,
                fillColor: const Color(0xFFF2F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00677F), width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Difficulty'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: DropdownButtonFormField<String>(
                      value: _difficulty,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: ['Beginner', 'Intermediate', 'Advanced'].map((s) =>
                        DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _difficulty = v);
                      },
                    ),
                  ),
                ],
              )),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Count'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: DropdownButtonFormField<String>(
                      value: _count,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: ['5 Questions', '10 Questions', '20 Questions'].map((s) =>
                        DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _count = v);
                      },
                    ),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.psychology_rounded, size: 22),
              label: const Text('Generate Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00677F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 8,
                shadowColor: const Color(0xFF00677F).withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
    );
  }

  Widget _buildResultsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('Generated Preview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                const SizedBox(width: 8),
                Text(_generated ? '(3 Ready)' : '(0)',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6C797F))),
              ],
            ),
            if (_generated)
              GestureDetector(
                onTap: _generate,
                child: const Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF00677F)),
                    SizedBox(width: 4),
                    Text('Regenerate All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00677F))),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (!_generated)
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBC9CF).withValues(alpha: 0.3), width: 2, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 64, color: const Color(0xFF6C797F).withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('Enter a topic and click Generate',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
                  const SizedBox(height: 4),
                  const Text('AI will craft professional questions instantly',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6C797F))),
                ],
              ),
            ),
          )
        else
          ..._sampleQuestions(),
      ],
    );
  }

  List<Widget> _sampleQuestions() {
    final samples = [
      {'q': 'What is the primary byproduct of photosynthesis that is released into the atmosphere?', 'a': 'Oxygen', 'exp': 'During the light-dependent reactions of photosynthesis, water molecules are split, releasing oxygen gas as a byproduct while generating chemical energy for the plant.', 'icon': Icons.biotech},
      {'q': 'Which pigment is primarily responsible for absorbing light energy in plants?', 'a': 'Chlorophyll', 'exp': 'Chlorophyll is the green pigment located in chloroplasts that absorbs sunlight, specifically blue and red wavelengths, to drive the synthesis of organic molecules.', 'icon': Icons.energy_savings_leaf_rounded},
      {'q': 'In which part of the plant cell does photosynthesis occur?', 'a': 'Chloroplast', 'exp': 'Photosynthesis takes place in the chloroplasts, which contain the chlorophyll pigments and the enzymatic machinery for both light-dependent and light-independent reactions.', 'icon': Icons.bubble_chart_rounded},
    ];

    return samples.asMap().entries.map((e) {
      final d = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D2FF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Question ${e.key + 1}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF004E60))),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => HapticFeedback.lightImpact(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E3E5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF3C494E)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => HapticFeedback.lightImpact(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete_rounded, size: 16, color: Color(0xFFBA1A1A)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(d['q'] as String,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
              const SizedBox(height: 20),
              ...['A: Carbon Dioxide', 'B: ${d['a']}', 'C: Glucose', 'D: Nitrogen'].asMap().entries.map((oe) {
                final isCorrect = oe.key == 1;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCorrect ? const Color(0xFF406900).withValues(alpha: 0.08) : const Color(0xFFF2F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isCorrect ? const Color(0xFF406900).withValues(alpha: 0.3) : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCorrect ? const Color(0xFF406900) : const Color(0xFFBBC9CF),
                        ),
                        child: isCorrect
                            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                            : Center(child: Text(String.fromCharCode(65 + oe.key),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        oe.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w400,
                          color: isCorrect ? const Color(0xFF355800) : const Color(0xFF3C494E),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E3E5).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, size: 16, color: const Color(0xFF00677F)),
                        const SizedBox(width: 6),
                        const Text('AI Explanation',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(d['exp'] as String,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF3C494E))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Question added to quiz'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xFF406900),
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(e.key == 1 ? 'Added to Quiz' : 'Add to Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: e.key == 1 ? Colors.white : const Color(0xFF00677F),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: e.key == 1 ? const Color(0xFF00677F) : Colors.transparent,
                    foregroundColor: e.key == 1 ? Colors.white : const Color(0xFF00677F),
                    side: BorderSide(
                      color: e.key == 1 ? Colors.transparent : const Color(0xFF00677F),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon; final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00677F).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF00677F)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF00677F))),
        ],
      ),
    );
  }
}
