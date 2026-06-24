import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/models/data_store.dart';
import 'package:educam_ai/models/content_models.dart';
import 'package:educam_ai/screens/teacher/teacher_student_dashboard.dart';

class TeacherStudents extends StatefulWidget {
  const TeacherStudents({super.key});

  @override
  State<TeacherStudents> createState() => _TeacherStudentsState();
}

class _TeacherStudentsState extends State<TeacherStudents> {
  final _store = DataStore();
  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedCourseId;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final classes = _store.uniqueClassNames;
    if (classes.isNotEmpty) {
      _selectedClass = classes.first;
      _updateSubjectForClass();
    }
  }

  void _updateSubjectForClass() {
    if (_selectedClass == null) return;
    final subjects = _store.getSubjectsForClass(_selectedClass!);
    if (subjects.isNotEmpty) {
      _selectedSubject = subjects.first;
      _selectedCourseId = _store.getCourseId(_selectedClass!, _selectedSubject!);
    } else {
      _selectedSubject = null;
      _selectedCourseId = null;
    }
  }

  Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Color _subjectColor(String subject) {
    if (subject == 'Mathematiques') return EduCamColors.subjectMaths;
    if (subject == 'Physique') return EduCamColors.subjectPhysique;
    if (subject == 'SVT') return EduCamColors.subjectSVT;
    if (subject == 'Histoire-Geo') return EduCamColors.subjectHistoire;
    return EduCamColors.accent;
  }

  List<Student> _filteredStudents() {
    if (_selectedClass == null) return [];
    var list = _store.getStudentsByClass(_selectedClass!);
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) => s.name.toLowerCase().contains(q)).toList();
    }
    list.sort((a, b) {
      final gA = _store.getGrade(a.id, _selectedCourseId ?? '');
      final gB = _store.getGrade(b.id, _selectedCourseId ?? '');
      return (gB?.average ?? 0).compareTo(gA?.average ?? 0);
    });
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classes = _store.uniqueClassNames;
    final subjects = _selectedClass != null ? _store.getSubjectsForClass(_selectedClass!) : <String>[];
    final students = _filteredStudents();

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
                StaggerItem(
                  index: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mes eleves', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                      const SizedBox(height: 4),
                      Text('${students.length} eleves dans ${_selectedClass ?? '-'}', style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StaggerItem(
                  index: 1,
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: classes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final cls = classes[i];
                        final selected = cls == _selectedClass;
                        final color = i == 0 ? EduCamColors.subjectMaths
                            : i == 1 ? EduCamColors.subjectSVT
                            : i == 2 ? EduCamColors.subjectPhysique
                            : EduCamColors.subjectHistoire;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedClass = cls;
                              _updateSubjectForClass();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? EduCamColors.surface : EduCamColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected ? color.withOpacity(0.3) : EduCamColors.cardBorder,
                                width: selected ? 1 : 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cls, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? EduCamColors.primary : EduCamColors.secondaryText)),
                                if (selected) ...[
                                  const SizedBox(width: 6),
                                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StaggerItem(
                  index: 2,
                  child: SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: subjects.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final subj = subjects[i];
                        final selected = subj == _selectedSubject;
                        final color = _subjectColor(subj);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedSubject = subj;
                              _selectedCourseId = _store.getCourseId(_selectedClass!, subj);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? color.withOpacity(0.1) : EduCamColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selected ? color.withOpacity(0.3) : EduCamColors.cardBorder, width: 0.5),
                            ),
                            child: Text(subj, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? color : EduCamColors.secondaryText)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StaggerItem(
                  index: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: EduCamColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, size: 20, color: EduCamColors.secondaryText),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'Rechercher un eleve...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () { _searchCtrl.clear(); setState(() {}); },
                            child: const Icon(Icons.close_rounded, size: 18, color: EduCamColors.secondaryText),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (students.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.people_outline_rounded, size: 48, color: EduCamColors.secondaryText.withOpacity(0.4)),
                          const SizedBox(height: 12),
                          Text('Aucun eleve trouve', style: TextStyle(fontSize: 15, color: EduCamColors.secondaryText.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                ...students.asMap().entries.map((entry) {
                  final i = entry.key;
                  final student = entry.value;
                  final grade = _store.getGrade(student.id, _selectedCourseId ?? '');
                  final avg = grade?.average ?? 0;
                  final status = avg >= 14 ? 'Actif' : (avg >= 10 ? 'Moyen' : 'En difficulte');
                  final statusColor = avg >= 14 ? EduCamColors.success : (avg >= 10 ? EduCamColors.highlight : EduCamColors.error);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: StaggerItem(
                      index: i + 4,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          if (_selectedCourseId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TeacherStudentDashboard(
                                  student: student,
                                  courseId: _selectedCourseId!,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: EduCamColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    student.name.split(' ').map((e) => e[0]).join(),
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text('Moy: ${avg.toStringAsFixed(1)}/20', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                                        const SizedBox(width: 8),
                                        Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                                        const SizedBox(width: 4),
                                        Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: grade != null ? _subjectColor(grade.subjectName).withOpacity(0.08) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  grade != null ? '${grade.exercisesCompleted}/${grade.exercisesAssigned}' : '-',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: grade != null ? _subjectColor(grade.subjectName) : EduCamColors.secondaryText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right_rounded, size: 18, color: EduCamColors.secondaryText),
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
}
