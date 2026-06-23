import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/screens/student/student_course_detail.dart';

class StudentCourses extends StatelessWidget {
  const StudentCourses({super.key});

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StaggerItem(index: 0, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Mes cours', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  SizedBox(height: 4),
                  Text('6 cours inscrits cette annee', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                ])),
                const SizedBox(height: 20),
                StaggerItem(index: 1, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: EduCamColors.surface, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5)),
                  child: const Row(children: [
                    Icon(Icons.search_rounded, size: 20, color: EduCamColors.secondaryText),
                    SizedBox(width: 10),
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher un cours...',
                        border: InputBorder.none, enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14)),
                    )),
                  ]),
                )),
                const SizedBox(height: 20),
                StaggerItem(index: 2, child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
                  child: Row(children: [
                    _FilterChip(label: 'Tous', selected: true),
                    _FilterChip(label: 'Scientifiques', selected: false),
                    _FilterChip(label: 'Litteraires', selected: false),
                    _FilterChip(label: 'Langues', selected: false),
                  ]),
                )),
                const SizedBox(height: 20),
                ..._buildCourseCards(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCourseCards(BuildContext context) {
    final courses = const [
      {'name': 'Mathematiques', 'teacher': 'M. Nkwi', 'lessons': '18/25', 'color': EduCamColors.subjectMaths, 'icon': Icons.functions_rounded, 'progress': 0.72, 'desc': 'Algebre, Geometrie, Probabilites'},
      {'name': 'SVT', 'teacher': 'Mme Eyanga', 'lessons': '11/20', 'color': EduCamColors.subjectSVT, 'icon': Icons.biotech_rounded, 'progress': 0.55, 'desc': 'Biologie, Geologie, Ecologie'},
      {'name': 'Histoire-Geo', 'teacher': 'M. Beti', 'lessons': '22/25', 'color': EduCamColors.subjectHistoire, 'icon': Icons.public_rounded, 'progress': 0.88, 'desc': 'Histoire, Geographie mondiale'},
      {'name': 'Physique-Chimie', 'teacher': 'Mme Mbarga', 'lessons': '8/20', 'color': EduCamColors.subjectPhysique, 'icon': Icons.science_rounded, 'progress': 0.40, 'desc': 'Mecanique, Electricite'},
      {'name': 'Francais', 'teacher': 'M. Ateba', 'lessons': '13/20', 'color': EduCamColors.subjectFrancais, 'icon': Icons.menu_book_rounded, 'progress': 0.65, 'desc': 'Dissertation, Grammaire'},
      {'name': 'Anglais', 'teacher': 'Mme Besong', 'lessons': '12/20', 'color': EduCamColors.subjectAnglais, 'icon': Icons.language_rounded, 'progress': 0.60, 'desc': 'Grammar, Essay Writing'},
    ];

    return courses.asMap().entries.map((e) {
      final i = e.key;
      final c = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: StaggerItem(
          index: i + 3,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => StudentCourseDetail(
                  courseName: c['name'] as String,
                  courseColor: c['color'] as Color,
                  courseIcon: c['icon'] as IconData,
                  courseId: 'c$i',
                ),
              ));
            },
            child: Container(
              width: double.infinity,
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
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: (c['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(c['icon'] as IconData, size: 22, color: c['color'] as Color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                      Text('${c['teacher']} - ${c['lessons']} lecons', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    ])),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: EduCamColors.secondaryText),
                  ]),
                  const SizedBox(height: 14),
                  Text(c['desc'] as String, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: c['progress'] as double,
                        backgroundColor: EduCamColors.progressTrack,
                        valueColor: AlwaysStoppedAnimation<Color>(c['color'] as Color),
                        minHeight: 4,
                      ),
                    )),
                    const SizedBox(width: 12),
                    Text('${((c['progress'] as double) * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c['color'] as Color)),
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _FilterChip extends StatelessWidget {
  final String label; final bool selected;
  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? EduCamColors.accent : EduCamColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? EduCamColors.accent : EduCamColors.cardBorder, width: selected ? 0 : 0.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
          color: selected ? EduCamColors.surface : EduCamColors.secondaryText)),
      ),
    );
  }
}
