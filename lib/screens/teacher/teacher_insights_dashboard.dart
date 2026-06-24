import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherInsightsDashboard extends StatefulWidget {
  final String? courseId;
  final String? courseName;
  const TeacherInsightsDashboard({super.key, this.courseId, this.courseName});

  @override
  State<TeacherInsightsDashboard> createState() => _TeacherInsightsDashboardState();
}

class _TeacherInsightsDashboardState extends State<TeacherInsightsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => Future.delayed(const Duration(milliseconds: 800)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StaggerItem(index: 0, child: const _StatsRow()),
                      const SizedBox(height: 24),
                      StaggerItem(index: 1, child: const _AIInsightCard()),
                      const SizedBox(height: 24),
                      StaggerItem(index: 2, child: const _GradeDistribution()),
                      const SizedBox(height: 24),
                      StaggerItem(index: 3, child: const _PerformanceTrend()),
                      const SizedBox(height: 24),
                      StaggerItem(index: 4, child: const _StudentSegments()),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: BoxDecoration(
        color: EduCamColors.surface.withValues(alpha: 0.7),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40)],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text('Class Insights',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFBBC9CF).withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mathematics 101 - Sec A',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
                SizedBox(width: 4),
                Icon(Icons.expand_more_rounded, size: 18, color: Color(0xFF3C494E)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.notifications_outlined, size: 24, color: Color(0xFF00677F)),
          const SizedBox(width: 8),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              color: const Color(0xFF00D2FF),
            ),
            child: const Center(
              child: Text('P', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00566A))),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final String? subtitle;
  final Widget? progress;

  const _StatCard({
    required this.label,
    required this.value,
    this.trailing,
    this.subtitle,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EduCamColors.surface.withValues(alpha: 0.7),
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
              Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF00677F))),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6C797F))),
          ],
          if (progress != null) ...[
            const SizedBox(height: 8),
            progress!,
          ],
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (constraints.maxWidth - 18) / 4;
        return Row(
          children: [
            SizedBox(
              width: w,
              child: _StatCard(
                label: 'Average Grade',
                value: '84.2%',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF406900)),
                    const SizedBox(width: 2),
                    const Text('+2.4%',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF406900))),
                  ],
                ),
                progress: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.842,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00677F),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: w,
              child: _StatCard(
                label: 'Attendance',
                value: '96%',
                trailing: SizedBox(
                  width: 48, height: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [0.25, 0.5, 0.75, 0.5, 1.0].map((h) => Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Container(
                        width: 4,
                        height: h * 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00677F),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                subtitle: 'Consistently high this week',
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: w,
              child: _StatCard(
                label: 'Assignments',
                value: '88%',
                trailing: const Icon(Icons.task_alt_rounded, size: 20, color: Color(0xFF00D2FF)),
                subtitle: '44/50 Students completed',
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: w,
              child: _StatCard(
                label: 'Participation',
                value: '92%',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 20, height: 20,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF65A1FE))),
                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Container(width: 20, height: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00D2FF))),
                    ),
                    Transform.translate(
                      offset: const Offset(-12, 0),
                      child: Container(width: 20, height: 20,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF87D600))),
                    ),
                  ],
                ),
                subtitle: 'Very active class discussions',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AIInsightCard extends StatelessWidget {
  const _AIInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D2FF).withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome_rounded, size: 28, color: Color(0xFF00566A)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('Priority',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                    color: Color(0xFF00566A), letterSpacing: 0.05)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF00566A), height: 1.3),
              children: [
                const TextSpan(text: '65% of students are struggling with '),
                TextSpan(
                  text: "'Quadratic Equations'",
                  style: const TextStyle(color: Color(0xFF00677F), fontWeight: FontWeight.w800),
                ),
                const TextSpan(text: '. Consider scheduling a review session or interactive lab.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Schedule Review - Bientot disponible'),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00677F), Color(0xFF00D2FF)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [BoxShadow(color: const Color(0xFF00677F).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Text('Schedule Review',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeDistribution extends StatelessWidget {
  const _GradeDistribution();

  @override
  Widget build(BuildContext context) {
    final grades = [
      ('A', 0.8, const Color(0xFF00677F), '18 Stud.'),
      ('B', 0.6, const Color(0xFF00677F), null),
      ('C', 0.4, const Color(0xFF00677F), null),
      ('D', 0.2, const Color(0xFF00677F), null),
      ('F', 0.1, const Color(0xFFBA1A1A), null),
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EduCamColors.surface.withValues(alpha: 0.7),
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
              const Text('Grade Distribution',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF6C797F)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: grades.map((g) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (g.$4 != null) Text(g.$4!,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF3C494E))),
                      const SizedBox(height: 4),
                      Container(
                        height: 160 * g.$2,
                        decoration: BoxDecoration(
                          color: g.$3.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 160 * g.$2,
                            decoration: BoxDecoration(
                              color: g.$3,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(g.$1,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3C494E))),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceTrend extends StatelessWidget {
  const _PerformanceTrend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: EduCamColors.surface.withValues(alpha: 0.7),
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
              const Text('Weekly Trend',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFF1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('Last 4 Weeks',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _LineChartPainter(),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Week 1', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
              Text('Week 2', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
              Text('Week 3', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
              Text('Week 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6C797F))),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00677F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF00677F).withValues(alpha: 0.15), const Color(0xFF00677F).withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, size.height * 0.76)
      ..cubicTo(
        size.width * 0.15, size.height * 0.7,
        size.width * 0.25, size.height * 0.3,
        size.width * 0.3, size.height * 0.3,
      )
      ..cubicTo(
        size.width * 0.4, size.height * 0.3,
        size.width * 0.45, size.height * 0.55,
        size.width * 0.5, size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.55, size.height * 0.55,
        size.width * 0.65, size.height * 0.15,
        size.width * 0.75, size.height * 0.15,
      )
      ..cubicTo(
        size.width * 0.85, size.height * 0.15,
        size.width * 0.9, size.height * 0.25,
        size.width, size.height * 0.25,
      );

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF00677F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 5, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.15), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StudentSegments extends StatelessWidget {
  const _StudentSegments();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (constraints.maxWidth - 16) / 2;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: w,
              child: Container(
                decoration: BoxDecoration(
                  color: EduCamColors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFBBC9CF), width: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, size: 24, color: Color(0xFF87D600)),
                          const SizedBox(width: 8),
                          const Text('Top Performers',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                        ],
                      ),
                    ),
                    _StudentRow(initial: 'S', name: 'Sarah Jenkins', detail: 'Consistency: 98%', score: '98.4%'),
                    _StudentRow(initial: 'M', name: 'Marcus Thorne', detail: 'Consistency: 95%', score: '96.1%'),
                    _StudentRow(initial: 'E', name: 'Elena Rodriguez', detail: 'Consistency: 92%', score: '94.8%'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: w,
              child: Container(
                decoration: BoxDecoration(
                  color: EduCamColors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFBBC9CF), width: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_rounded, size: 24, color: Color(0xFFBA1A1A)),
                          const SizedBox(width: 8),
                          const Text('Students At Risk',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                        ],
                      ),
                    ),
                    _StudentRow(initial: 'D', name: 'David Miller', detail: 'Missed 3 Assignments', score: '62.5%', isRisk: true),
                    _StudentRow(initial: 'L', name: 'Lucy Yang', detail: 'Attendance Drop: -15%', score: '68.2%', isRisk: true),
                    _StudentRow(initial: 'J', name: 'James Wilson', detail: 'Low Quiz Participation', score: '70.1%', isRisk: true),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StudentRow extends StatelessWidget {
  final String initial;
  final String name;
  final String detail;
  final String score;
  final bool isRisk;

  const _StudentRow({
    required this.initial,
    required this.name,
    required this.detail,
    required this.score,
    this.isRisk = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: isRisk
                    ? const Color(0xFFFFDAD6).withValues(alpha: 0.3)
                    : const Color(0xFF00D2FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(initial,
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: isRisk ? const Color(0xFFBA1A1A) : const Color(0xFF00677F),
                  )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1E))),
                  Text(detail,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6C797F))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isRisk
                    ? const Color(0xFFFFDAD6)
                    : const Color(0xFF87D600).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(score,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: isRisk ? const Color(0xFF93000A) : const Color(0xFF406900),
                )),
            ),
          ],
        ),
      ),
    );
  }
}
