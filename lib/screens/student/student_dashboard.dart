import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/app_role.dart';
import 'package:educam_ai/widgets/offline_pill.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/widgets/skeleton_loader.dart';
import 'package:educam_ai/screens/tutorbot_screen.dart';
import 'package:educam_ai/screens/student/student_documents.dart';
import 'package:educam_ai/screens/student/student_course_detail.dart';
import 'package:educam_ai/providers/course_provider.dart';
import 'package:educam_ai/providers/auth_provider.dart';
import 'package:educam_ai/providers/connectivity_provider.dart';
import 'package:educam_ai/services/course_service.dart';
import 'package:educam_ai/services/local_storage_service.dart';
import 'package:educam_ai/services/offline_service.dart';
import 'package:educam_ai/services/notification_service.dart';

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
    );
  }

  Widget _buildError(Object e) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const _Header(userName: ''),
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
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaggerItem(index: 0, child: _Header(userName: userName)),
          const SizedBox(height: 20),
          StaggerItem(index: 1, child: _GreetingSection(userName: userName, courseCount: courses.length, stats: stats)),
          const SizedBox(height: 20),
          StaggerItem(index: 2, child: _StatsRow(stats: stats)),
          const SizedBox(height: 24),
          StaggerItem(
            index: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Nouveautes des profs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                    SizedBox(height: 2),
                    Text('3 nouvelles activites', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: EduCamColors.highlight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('NOUVEAU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EduCamColors.highlight)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const StaggerItem(index: 4, child: _TeacherUpdates()),
          const SizedBox(height: 24),
          const StaggerItem(
            index: 5,
            child: _SectionHeader(title: 'Continuer l\'apprentissage', subtitle: 'Reprends la ou tu t\'es arrete'),
          ),
          const SizedBox(height: 12),
          StaggerItem(index: 6, child: _ContinueLearning(courses: courses)),
          const SizedBox(height: 24),
          const StaggerItem(
            index: 7,
            child: _SectionHeader(title: 'Devoirs a rendre', subtitle: 'Echeance proche'),
          ),
          const SizedBox(height: 12),
          StaggerItem(index: 8, child: _UpcomingAssignments(courses: courses)),
          const SizedBox(height: 24),
          const StaggerItem(
            index: 9,
            child: _SectionHeader(title: 'Acces rapide', subtitle: 'Outils intelligents'),
          ),
          const SizedBox(height: 12),
          const StaggerItem(index: 10, child: _QuickAccessSection()),
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

class _Header extends StatelessWidget {
  final String userName;
  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('EA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EduCam AI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  _RoleBadgeStudent(),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const OfflinePill(),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDocuments()));
                },
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: const Icon(Icons.folder_rounded, size: 20, color: EduCamColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadgeStudent extends StatelessWidget {
  const _RoleBadgeStudent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: EduCamColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: const Text('ELEVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: EduCamColors.accent, letterSpacing: 1)),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final String userName;
  final int courseCount;
  final _DashboardStats stats;
  const _GreetingSection({required this.userName, required this.courseCount, required this.stats});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Bonjour' : hour < 17 ? 'Bon apres-midi' : 'Bonsoir';
    final subtitle = '$courseCount cours en cours, ${stats.assignmentCount} devoirs a rendre';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting, $userName', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final _DashboardStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final avgStr = stats.average > 0 ? stats.average.toStringAsFixed(1) : '--';
    final hoursStr = stats.weekHours > 0 ? '${stats.weekHours.toStringAsFixed(0)}h' : '--';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _StatCard(icon: Icons.menu_book_rounded, value: '${stats.courseCount}', label: 'Cours', color: EduCamColors.accent),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.assignment_rounded, value: '${stats.assignmentCount}', label: 'Devoirs', color: EduCamColors.highlight),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.grade_rounded, value: avgStr, label: 'Moyenne', color: EduCamColors.success),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.timer_rounded, value: hoursStr, label: 'Cette semaine', color: EduCamColors.subjectPhysique),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String value; final String label; final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Column(children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: EduCamColors.secondaryText)),
        ]),
      ),
    );
  }
}

class _TeacherUpdates extends StatelessWidget {
  const _TeacherUpdates();

  static final _updates = [
    {'teacher': 'M. Nkwi', 'subject': 'Mathematiques', 'action': 'a publie un nouveau sujet d\'annales BAC 2024', 'icon': Icons.assignment_rounded, 'color': EduCamColors.subjectMaths, 'time': 'Il y a 2h'},
    {'teacher': 'Mme Eyanga', 'subject': 'SVT', 'action': 'a ajoute un exercice sur la genetique', 'icon': Icons.biotech_rounded, 'color': EduCamColors.subjectSVT, 'time': 'Il y a 5h'},
    {'teacher': 'M. Beti', 'subject': 'Histoire-Geo', 'action': 'a mis en ligne un cours sur la colonisation', 'icon': Icons.public_rounded, 'color': EduCamColors.subjectHistoire, 'time': 'Hier'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _updates.length,
        itemBuilder: (_, i) {
          final u = _updates[i];
          return GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 240,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (u['color'] as Color).withOpacity(0.15), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: (u['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(u['icon'] as IconData, size: 14, color: u['color'] as Color),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(u['teacher'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EduCamColors.primary))),
                    Text(u['time'] as String, style: const TextStyle(fontSize: 10, color: EduCamColors.secondaryText)),
                  ]),
                  const SizedBox(height: 8),
                  Text('${u['subject']}: ${u['action']}', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText, height: 1.3), maxLines: 2),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: (u['color'] as Color).withOpacity(0.06), borderRadius: BorderRadius.circular(6)),
                    child: Text('Voir', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: (u['color'] as Color).withOpacity(0.7))),
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

class _ContinueLearning extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  const _ContinueLearning({required this.courses});

  static const _defaultColors = [
    EduCamColors.subjectMaths,
    EduCamColors.subjectSVT,
    EduCamColors.subjectHistoire,
    EduCamColors.subjectPhysique,
  ];

  static const _defaultIcons = [
    Icons.functions_rounded,
    Icons.biotech_rounded,
    Icons.public_rounded,
    Icons.science_rounded,
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final c = courses[index];
          final color = _colorFor(c['color'] ?? c['color_hex'], index);
          final icon = _iconFor(c['icon'] ?? c['icon_data'], index);

          final totalLessons = (c['total_lessons'] ?? c['totalLessons'] ?? 20) as num;
          final completedLessons = (c['completed_lessons'] ?? c['completedLessons'] ?? 0) as num;
          final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

          final name = (c['subject_name'] ?? c['subjectName'] ?? c['name'] ?? 'Cours') as String;
          final lesson = c['current_lesson'] ?? c['lesson'] ?? 'Lecon en cours';

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
              width: 190,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, size: 18, color: color),
                    ),
                    const Spacer(),
                    Text('${(progress * 100).round()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                  ]),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                  const SizedBox(height: 4),
                  Text('Lecon: $lesson', style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: EduCamColors.progressTrack,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
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
        {'title': 'Exercice: Derivees', 'course': 'Mathematiques', 'due': 'Demain', 'color': EduCamColors.subjectMaths, 'urgent': true},
        {'title': 'Dissertation: Colonisation', 'course': 'Histoire-Geo', 'due': 'Dans 3 jours', 'color': EduCamColors.subjectHistoire, 'urgent': false},
        {'title': 'Compte rendu TP', 'course': 'SVT', 'due': 'Dans 5 jours', 'color': EduCamColors.subjectSVT, 'urgent': false},
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: assignments.asMap().entries.map((e) {
          final a = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: (a['urgent'] as bool) ? EduCamColors.error.withOpacity(0.2) : EduCamColors.cardBorder, width: 0.5),
                ),
                child: Row(children: [
                  Container(width: 4, height: 40, decoration: BoxDecoration(color: a['color'] as Color, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                    Text(a['course'] as String, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (a['urgent'] as bool) ? EduCamColors.error.withOpacity(0.1) : EduCamColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(a['due'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: (a['urgent'] as bool) ? EduCamColors.error : EduCamColors.accent)),
                  ),
                ]),
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

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: _QuickToolCard(
              icon: Icons.smart_toy_rounded, title: 'TutorBot', subtitle: 'Pose une question',
              color: EduCamColors.accent,
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorBotScreen()));
              },
            )),
            const SizedBox(width: 12),
            Expanded(child: _QuickToolCard(
              icon: Icons.camera_alt_rounded, title: 'CopyCorrector', subtitle: 'Corrige un devoir',
              color: EduCamColors.highlight,
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('CopyCorrector - Prends une photo de ton devoir'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              },
            )),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _QuickToolCard(
              icon: Icons.folder_rounded, title: 'Documents', subtitle: 'Mes fichiers',
              color: EduCamColors.subjectPhysique,
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDocuments()));
              },
            )),
            const SizedBox(width: 12),
            Expanded(child: _QuickToolCard(
              icon: Icons.auto_awesome_rounded, title: 'Video Cours', subtitle: 'Convertir en video',
              color: EduCamColors.subjectSVT,
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Choisis d\'abord un cours dans l\'onglet Cours'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              },
            )),
          ]),
        ],
      ),
    );
  }
}

class _QuickToolCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final VoidCallback onTap;
  const _QuickToolCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
          ])),
          Icon(Icons.chevron_right_rounded, size: 16, color: color.withOpacity(0.5)),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title; final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
      ]),
    );
  }
}

