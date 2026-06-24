import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/services/admin_service.dart';

class AdminCourses extends ConsumerStatefulWidget {
  const AdminCourses({super.key});

  @override
  ConsumerState<AdminCourses> createState() => _AdminCoursesState();
}

class _AdminCoursesState extends ConsumerState<AdminCourses> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await AdminService().getCourses();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _subjectColor(String subject) {
    if (subject == 'Mathematiques') return EduCamColors.subjectMaths;
    if (subject == 'Physique') return EduCamColors.subjectPhysique;
    if (subject == 'SVT') return EduCamColors.subjectSVT;
    if (subject == 'Histoire-Geo') return EduCamColors.subjectHistoire;
    if (subject == 'Francais') return EduCamColors.subjectFrancais;
    if (subject == 'Anglais') return EduCamColors.subjectAnglais;
    return EduCamColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _buildLoading();
    }
    if (_error != null) {
      return _buildError();
    }
    return _buildContent();
  }

  Widget _buildLoading() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSummaryBar(),
        const SizedBox(height: 24),
        ...List.generate(3, (_) => _buildSectionSkeleton()),
      ],
    );
  }

  Widget _buildError() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: EduCamColors.secondaryText),
              const SizedBox(height: 16),
              const Text(
                'Impossible de charger les cours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reessayer'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final courses = List<Map<String, dynamic>>.from(_data!['courses'] as List);
    final grouped = _data!['grouped'] as Map<String, dynamic>;
    final classNames = grouped.keys.toList()..sort();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSummaryBar(totalCourses: courses.length, classCount: classNames.length),
        const SizedBox(height: 24),
        ...classNames.map((className) => _buildClassSection(className, List<Map<String, dynamic>>.from(grouped[className] as List))),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.admin_panel_settings_rounded, size: 20, color: EduCamColors.surface),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Apercu des cours',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: EduCamColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Text(
            'Gerer les cours et le contenu pedagogique',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: EduCamColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBar({int totalCourses = 0, int classCount = 0}) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: EduCamColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book_rounded, size: 18, color: EduCamColors.accent),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalCourses.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: EduCamColors.primary,
                      ),
                    ),
                    Text(
                      'Cours',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: EduCamColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: EduCamColors.highlight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.group_rounded, size: 18, color: EduCamColors.highlight),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classCount.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: EduCamColors.primary,
                      ),
                    ),
                    Text(
                      'Classes',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: EduCamColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16, width: 160, decoration: BoxDecoration(color: EduCamColors.progressTrack, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 12),
            Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: EduCamColors.progressTrack.withOpacity(0.5), borderRadius: BorderRadius.circular(4))),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSection(String className, List<Map<String, dynamic>> courses) {
    final icon = className.contains('Terminale')
        ? Icons.school_rounded
        : className.contains('Premiere')
            ? Icons.auto_stories_rounded
            : Icons.class_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: EduCamColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: EduCamColors.accent),
            ),
            title: Text(
              className,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: EduCamColors.primary,
              ),
            ),
            subtitle: Text(
              '${courses.length} cours',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: EduCamColors.secondaryText,
              ),
            ),
            children: courses.map((c) => _buildCourseCard(c)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final subjectName = course['subject_name'] as String? ?? course['name'] as String? ?? 'Cours';
    final subject = course['subject'] as String? ?? subjectName;
    final color = _subjectColor(subject);
    final teacherName = course['teacher_name'] as String? ?? course['teacher'] as String? ?? 'Non assigne';
    final className = course['class_name'] as String? ?? course['class'] as String? ?? '';

    final totalLessons = (course['total_lessons'] ?? course['totalLessons'] ?? 0) as num;
    final completedLessons = (course['completed_lessons'] ?? course['completedLessons'] ?? 0) as num;
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: EduCamColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EduCamColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 12, color: EduCamColors.secondaryText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teacherName,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: EduCamColors.secondaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (className.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.class_rounded, size: 12, color: EduCamColors.secondaryText),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            className,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: EduCamColors.secondaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${completedLessons}/${totalLessons}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 56,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: EduCamColors.progressTrack,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
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
