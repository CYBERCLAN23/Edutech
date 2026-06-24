import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/screens/admin/admin_dashboard.dart';
import 'package:educam_ai/screens/admin/admin_users.dart';
import 'package:educam_ai/screens/admin/admin_courses.dart';
import 'package:educam_ai/screens/admin/admin_settings.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final _screens = const [
    AdminDashboard(),
    AdminUsers(),
    AdminCourses(),
    AdminSettings(),
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.dashboard_rounded, label: 'Tableau de bord', index: 0, currentIndex: _currentIndex, onTap: () => setState(() => _currentIndex = 0)),
                _NavItem(icon: Icons.people_rounded, label: 'Utilisateurs', index: 1, currentIndex: _currentIndex, onTap: () => setState(() => _currentIndex = 1)),
                _NavItem(icon: Icons.school_rounded, label: 'Cours', index: 2, currentIndex: _currentIndex, onTap: () => setState(() => _currentIndex = 2)),
                _NavItem(icon: Icons.settings_rounded, label: 'Système', index: 3, currentIndex: _currentIndex, onTap: () => setState(() => _currentIndex = 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? EduCamColors.accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? EduCamColors.accent : EduCamColors.secondaryText, size: 22),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? EduCamColors.accent : EduCamColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}
