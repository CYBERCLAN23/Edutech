import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/widgets/skeleton_loader.dart';
import 'package:educam_ai/screens/tutorbot_screen.dart';
import 'package:educam_ai/screens/student/student_documents.dart';
import 'package:educam_ai/screens/student/student_course_detail.dart';
import 'package:educam_ai/providers/course_provider.dart';
import 'package:educam_ai/providers/auth_provider.dart';

class StudentDashboard extends ConsumerStatefulWidget {
  const StudentDashboard({super.key});

  @override
  ConsumerState<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends ConsumerState<StudentDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(coursesProvider.notifier).loadCourses());
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(coursesProvider.notifier).loadCourses(),
                child: coursesAsync.when(
                  loading: () => const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 16),
                    child: DashboardSkeleton(),
                  ),
                  error: (e, _) => _buildError(e),
                  data: (courses) => _buildDashboard(courses, authState),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Object e) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 48, color: EduCamColors.secondaryText),
                  const SizedBox(height: 16),
                  const Text(
                    'Impossible de charger les donnees',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => ref.read(coursesProvider.notifier).loadCourses(),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reessayer'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(List<Map<String, dynamic>> courses, AuthState authState) {
    final stats = _computeStats(courses);
    final userName = authState.user?['name'] as String? ?? 'Eleve';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaggerItem(index: 0, child: _GreetingSection(userName: userName)),
          const SizedBox(height: 20),
          StaggerItem(index: 1, child: const _HeroBanner()),
          const SizedBox(height: 24),
          StaggerItem(index: 2, child: _StatsGrid(stats: stats)),
          const SizedBox(height: 24),
          StaggerItem(index: 3, child: const _QuickAccess()),
          const SizedBox(height: 24),
          StaggerItem(
            index: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Continuer l'apprentissage",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                  Text('Voir tout',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: EduCamColors.accent)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          StaggerItem(index: 5, child: _ContinueLearning(courses: courses)),
          const SizedBox(height: 24),
          StaggerItem(
            index: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Devoirs a venir',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
            ),
          ),
          const SizedBox(height: 12),
          StaggerItem(index: 7, child: _UpcomingAssignments(courses: courses)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  _DashboardStats _computeStats(List<Map<String, dynamic>> courses) {
    int totalAssignments = 0;
    double totalAverage = 0.0;
    int coursesWithAverage = 0;
    double totalHours = 0.0;

    for (final c in courses) {
      final assignments = _toInt(c['assignments_count'] ?? c['exercises_count'] ?? c['total_exercises'] ?? 0);
      totalAssignments += assignments;

      final avg = _toDouble(c['average'] ?? c['student_average'] ?? 0.0);
      if (avg > 0) {
        totalAverage += avg;
        coursesWithAverage++;
      }

      final hours = _toDouble(c['total_hours'] ?? c['weekly_hours'] ?? 0.0);
      totalHours += hours;
    }

    final avgDisplay = coursesWithAverage > 0 ? totalAverage / coursesWithAverage : 0.0;

    return _DashboardStats(
      courseCount: courses.length,
      assignmentCount: totalAssignments,
      average: avgDisplay,
      weekHours: totalHours,
    );
  }
}

class _DashboardStats {
  final int courseCount;
  final int assignmentCount;
  final double average;
  final double weekHours;

  const _DashboardStats({
    required this.courseCount,
    required this.assignmentCount,
    required this.average,
    required this.weekHours,
  });
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('EA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
          ),
          const SizedBox(width: 12),
          const Text('EduCam AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.notifications_outlined, size: 24, color: EduCamColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final String userName;
  const _GreetingSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Bonjour, ',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: EduCamColors.primary),
              children: [
                TextSpan(text: userName),
                TextSpan(text: ' ', style: TextStyle(fontSize: 24)),
                TextSpan(text: '\u{1F44B}'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text("Pret a exceller aujourd'hui ?",
            style: TextStyle(fontSize: 16, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFFFDDBA).withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Code, Build, Solve.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                  const SizedBox(height: 4),
                  const Text("Turn your biggest ideas into real-world solutions today.",
                    style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
          Positioned(
            right: -16,
            bottom: -8,
            child: SizedBox(
              width: 180,
              height: 140,
              child: Icon(Icons.auto_awesome_rounded, size: 100,
                color: EduCamColors.accent.withOpacity(0.08)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final _DashboardStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final avgStr = stats.average > 0 ? stats.average.toStringAsFixed(1) : '--';
    final hoursStr = stats.weekHours > 0 ? '${stats.weekHours.toStringAsFixed(0)}h' : '--';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatCard(
                value: '${stats.courseCount}', label: 'Cours',
                borderColor: EduCamColors.accent, icon: Icons.school, iconColor: EduCamColors.accent,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(
                value: '${stats.assignmentCount}', label: 'Devoirs',
                borderColor: EduCamColors.error, icon: Icons.assignment_late, iconColor: EduCamColors.error,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatCard(
                value: avgStr, label: 'Moyenne',
                borderColor: EduCamColors.success, icon: Icons.trending_up, iconColor: EduCamColors.success,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(
                value: hoursStr, label: "Temps d'Etude",
                borderColor: const Color(0xFFFFB95F), icon: Icons.timer, iconColor: EduCamColors.highlight,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.value, required this.label,
    required this.borderColor, required this.icon, required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 2),
          Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          const SizedBox(height: 2),
          Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acces Rapide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickAccessButton(
                icon: Icons.smart_toy,
                label: 'TutorBot',
                bgColor: const Color(0xFFE2DFFF),
                iconColor: EduCamColors.accent,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorBotScreen()));
                },
              ),
              _QuickAccessButton(
                icon: Icons.fact_check,
                label: 'Correction',
                bgColor: const Color(0xFFFCD34D).withOpacity(0.3),
                iconColor: const Color(0xFFD97706),
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Correction - Bientot disponible'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                  ));
                },
              ),
              _QuickAccessButton(
                icon: Icons.folder,
                label: 'Docs',
                bgColor: const Color(0xFFD8B4FE).withOpacity(0.3),
                iconColor: const Color(0xFF7E22CE),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDocuments()));
                },
              ),
              _QuickAccessButton(
                icon: Icons.play_circle,
                label: 'Videos',
                bgColor: const Color(0xFFFCA5A5).withOpacity(0.3),
                iconColor: const Color(0xFFB91C1C),
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Choisis d\'abord un cours dans l\'onglet Cours'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon, required this.label,
    required this.bgColor, required this.iconColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}

class _ContinueLearning extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  const _ContinueLearning({required this.courses});

  static const _defaultColors = [
    EduCamColors.accent,
    Color(0xFF0EA5E9),
    EduCamColors.highlight,
    EduCamColors.success,
  ];

  static const _defaultIcons = [
    Icons.calculate,
    Icons.science,
    Icons.public,
    Icons.biotech,
  ];

  Color _colorFor(dynamic value, int index) {
    if (value != null) {
      if (value is Color) return value;
      if (value is int) return Color(value);
      if (value is String) {
        final hex = value.replaceFirst('#', '');
        if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
        if (hex.length == 8) return Color(int.parse(hex, radix: 16));
      }
    }
    return _defaultColors[index % _defaultColors.length];
  }

  IconData _iconFor(dynamic value, int index) {
    if (value != null) {
      if (value is IconData) return value;
      if (value is int) return IconData(value, fontFamily: 'MaterialIcons');
    }
    return _defaultIcons[index % _defaultIcons.length];
  }

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text('Aucun cours pour le moment', style: TextStyle(color: EduCamColors.secondaryText)),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final c = courses[index];
          final color = _colorFor(c['color'] ?? c['color_hex'], index);
          final icon = _iconFor(c['icon'] ?? c['icon_data'], index);

          final totalLessons = (c['total_lessons'] ?? c['totalLessons'] ?? 20) as num;
          final completedLessons = (c['completed_lessons'] ?? c['completedLessons'] ?? 0) as num;
          final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

          final name = (c['subject_name'] ?? c['subjectName'] ?? c['name'] ?? 'Cours') as String;
          final lesson = c['current_lesson'] ?? c['lesson'] ?? 'Lecon';

          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => StudentCourseDetail(
                  courseName: name,
                  courseColor: color,
                  courseIcon: icon,
                  courseId: c['id'] as String? ?? 'c$index',
                ),
              ));
            },
            child: Container(
              width: 240,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B2A).withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 20, color: color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                            Text(lesson,
                              style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progression',
                        style: TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                      Text('${(progress * 100).round()}%',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFECEFF0),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UpcomingAssignments extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  const _UpcomingAssignments({required this.courses});

  @override
  Widget build(BuildContext context) {
    final assignments = <Map<String, dynamic>>[];

    for (final c in courses) {
      final exercises = c['exercises'] as List<dynamic>?;
      if (exercises != null) {
        for (final e in exercises) {
          if (e is Map<String, dynamic>) {
            final dueStr = e['due_date'] ?? e['due_at'] ?? '';
            final isUrgent = dueStr.toString().contains('Demain') ||
                dueStr == 'Demain' ||
                (e['urgent'] == true);
            assignments.add({
              'title': e['title'] ?? 'Exercice',
              'course': c['subject_name'] ?? c['subjectName'] ?? c['name'] ?? 'Cours',
              'due': dueStr.toString().isNotEmpty ? dueStr.toString() : 'A venir',
              'color': _parseColorSimple(c['color'] ?? c['color_hex'], EduCamColors.accent),
              'urgent': isUrgent,
            });
          }
        }
      }
    }

    if (assignments.isEmpty) {
      assignments.addAll([
        {'title': 'Dissertation d\'Histoire', 'course': 'A rendre', 'due': 'Demain, 08:00', 'color': EduCamColors.error, 'urgent': true},
        {'title': 'Exercices de SVT', 'course': 'A rendre', 'due': 'Mercredi', 'color': EduCamColors.highlight, 'urgent': false},
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: assignments.asMap().entries.map((e) {
          final a = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1B2A).withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6, height: 40,
                      decoration: BoxDecoration(
                        color: (a['urgent'] as bool) ? EduCamColors.error : const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title'] as String,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                          Text(a['due'] as String,
                            style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                        ],
                      ),
                    ),
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC4C6CC)),
                      ),
                      child: Icon(Icons.arrow_forward_ios, size: 12,
                        color: const Color(0xFFC4C6CC)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _parseColorSimple(dynamic value, Color fallback) {
    if (value == null) return fallback;
    if (value is Color) return value;
    if (value is int) return Color(value);
    if (value is String) {
      final hex = value.replaceFirst('#', '');
      if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
      if (hex.length == 8) return Color(int.parse(hex, radix: 16));
    }
    return fallback;
  }
}
