import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/providers/connectivity_provider.dart';
import 'package:educam_ai/services/local_storage_service.dart';
import 'package:educam_ai/screens/student/student_course_detail.dart';

class StudentCourses extends ConsumerWidget {
  const StudentCourses({super.key});

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final cached = LocalStorageService().getCachedCourses();

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
                StaggerItem(index: 0, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('My Learning Journey',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  const SizedBox(height: 4),
                  Text(isOnline ? 'Continue your academic excellence' : '${cached.length} cours disponibles hors ligne',
                    style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                ])),
                const SizedBox(height: 20),
                StaggerItem(index: 1, child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    const Icon(Icons.search_rounded, size: 22, color: Color(0xFF6C797F)),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search courses, lessons, or topics...',
                        hintStyle: const TextStyle(color: Color(0xFF6C797F), fontSize: 16),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    )),
                  ]),
                )),
                const SizedBox(height: 20),
                StaggerItem(index: 2, child: SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _FilterChip(label: 'All Courses', selected: true),
                      _FilterChip(label: 'Mathematics', selected: false),
                      _FilterChip(label: 'Physics', selected: false),
                      _FilterChip(label: 'Chemistry', selected: false),
                      _FilterChip(label: 'Biology (SVT)', selected: false),
                      _FilterChip(label: 'Computer Science', selected: false),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                ..._buildCourseGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCourseGrid(BuildContext context) {
    final courses = const [
      {'name': 'Mathematiques', 'subject': 'Mathematics', 'desc': 'Calculus & Linear Algebra', 'level': 'Advanced', 'lessons': '12 of 24', 'progress': 0.50, 'color': Color(0xFF65A1FE), 'icon': Icons.calculate, 'bg': Color(0xFF65A1FE)},
      {'name': 'Physique', 'subject': 'Physics', 'desc': 'Quantum Mechanics Fundamentals', 'level': 'Intermediate', 'lessons': '5 of 18', 'progress': 0.28, 'color': Color(0xFF00677F), 'icon': Icons.science, 'bg': Color(0xFF00677F)},
      {'name': 'SVT', 'subject': 'SVT / Biology', 'desc': 'Cellular Biology & Genetics', 'level': 'Beginner', 'lessons': '18 of 20', 'progress': 0.90, 'color': Color(0xFF406900), 'icon': Icons.biotech, 'bg': Color(0xFF406900)},
    ];

    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Learning Journey',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: const Row(
                children: [
                  Text('View Schedule',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00677F))),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18, color: Color(0xFF00677F)),
                ],
              ),
            ),
          ],
        ),
      ),
      ...courses.asMap().entries.map((e) {
        final i = e.key;
        final c = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (c['bg'] as Color).withOpacity(0.15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: (c['color'] as Color).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(c['icon'] as IconData, size: 24,
                              color: c['color'] as Color),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(c['level'] as String,
                              style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700,
                                color: c['color'] as Color,
                              )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['subject'] as String,
                            style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              color: Color(0xFF6C797F), letterSpacing: 1.5)),
                          const SizedBox(height: 6),
                          Text(c['desc'] as String,
                            style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700,
                              color: Color(0xFF191C1E))),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Progress',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                                      color: Color(0xFF3C494E))),
                                  Text(c['lessons'] as String,
                                    style: const TextStyle(fontSize: 12,
                                      color: Color(0xFF6C797F))),
                                ],
                              ),
                              Text('${((c['progress'] as double) * 100).round()}%',
                                style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700,
                                  color: c['color'] as Color)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: c['progress'] as double,
                              backgroundColor: (c['color'] as Color).withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(c['color'] as Color),
                              minHeight: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ];
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00677F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF00677F) : const Color(0xFFBBC9CF),
          ),
          boxShadow: selected ? [
            BoxShadow(
              color: const Color(0xFF00677F).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF3C494E),
          )),
      ),
    );
  }
}
