import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/screens/student/student_dashboard.dart';
import 'package:educam_ai/screens/student/student_courses.dart';
import 'package:educam_ai/screens/student/student_assignments.dart';
import 'package:educam_ai/screens/student/student_documents.dart';
import 'package:educam_ai/screens/student/student_profile.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;

  final _screens = const [
    StudentDashboard(),
    StudentCourses(),
    StudentDocuments(),
    StudentAssignments(),
    StudentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          boxShadow: EduCamTheme.softShadow,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StudentNavItem(icon: Icons.space_dashboard_rounded, label: 'Tableau', index: 0),
                _StudentNavItem(icon: Icons.menu_book_rounded, label: 'Cours', index: 1),
                _StudentNavItem(icon: Icons.folder_rounded, label: 'Documents', index: 2),
                _StudentNavItem(icon: Icons.assignment_rounded, label: 'Devoirs', index: 3),
                _StudentNavItem(icon: Icons.person_rounded, label: 'Profil', index: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _StudentNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? EduCamColors.accent.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? EduCamColors.accent : EduCamColors.secondaryText),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? EduCamColors.accent : EduCamColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}
