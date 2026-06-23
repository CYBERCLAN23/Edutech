import 'package:flutter/material.dart';
import 'package:educam_ai/models/app_role.dart';
import 'package:educam_ai/screens/student/student_shell.dart';
import 'package:educam_ai/screens/teacher/teacher_shell.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final role = AppSession.currentRole;
    if (role == AppRole.teacher) {
      return const TeacherShell();
    }
    return const StudentShell();
  }
}
