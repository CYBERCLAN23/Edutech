import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/screens/teacher/teacher_dashboard.dart';
import 'package:educam_ai/screens/teacher/teacher_courses.dart';
import 'package:educam_ai/screens/teacher/teacher_students.dart';
import 'package:educam_ai/screens/teacher/teacher_profile.dart';

class TeacherShell extends StatefulWidget {
  const TeacherShell({super.key});

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  int _currentIndex = 0;

  final _screens = const [
    TeacherDashboard(),
    TeacherCourses(),
    TeacherStudents(),
    TeacherProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          boxShadow: EduCamTheme.softShadow,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TeacherNavItem(
                  icon: Icons.space_dashboard_rounded,
                  label: 'Tableau',
                  index: 0,
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _TeacherNavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Cours',
                  index: 1,
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _TeacherNavItem(
                  icon: Icons.people_rounded,
                  label: 'Eleves',
                  index: 2,
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _TeacherNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profil',
                  index: 3,
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _TeacherNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? EduCamColors.highlight.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? EduCamColors.highlight : EduCamColors.secondaryText,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? EduCamColors.highlight : EduCamColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
