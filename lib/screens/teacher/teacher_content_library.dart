import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherContentLibrary extends StatefulWidget {
  final String? courseId;
  final String? courseName;
  const TeacherContentLibrary({super.key, this.courseId, this.courseName});

  @override
  State<TeacherContentLibrary> createState() => _TeacherContentLibraryState();
}

class _TeacherContentLibraryState extends State<TeacherContentLibrary> {
  final _searchCtrl = TextEditingController();
  String _activeFilter = 'All';

  final _filters = ['All', 'Lessons', 'Videos', 'Worksheets', 'Presentations'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => Future.delayed(const Duration(milliseconds: 800)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StaggerItem(index: 0, child: _QuickAddFilterRow(filters: _filters, activeFilter: _activeFilter, onFilterChanged: (f) => setState(() => _activeFilter = f))),
                      const SizedBox(height: 24),
                      StaggerItem(index: 1, child: const _FoldersSection()),
                      const SizedBox(height: 24),
                      StaggerItem(index: 2, child: const _RecentFilesSection()),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: BoxDecoration(
        color: EduCamColors.surface.withOpacity(0.7),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Menu - Bientot disponible'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
              ));
            },
            child: const Icon(Icons.menu_open_rounded, size: 24, color: Color(0xFF00677F)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Content Library',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF00D2FF), width: 2),
            ),
            child: const Center(
              child: Text('A', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF00677F))),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddFilterRow extends StatelessWidget {
  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const _QuickAddFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ActionBtn(
              label: 'Upload File',
              icon: Icons.upload_file_rounded,
              color: const Color(0xFF00677F),
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Upload - Bientot disponible'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              },
            ),
            const SizedBox(width: 8),
            _ActionBtn(
              label: 'Create Lesson',
              icon: Icons.add_circle_rounded,
              color: const Color(0xFF00566A),
              isSoft: true,
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Creer lecon - Bientot disponible'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final f = filters[i];
              final isActive = f == activeFilter;
              return GestureDetector(
                onTap: () => onFilterChanged(f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF00677F) : EduCamColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isActive ? const Color(0xFF00677F) : const Color(0xFFBBC9CF),
                    ),
                  ),
                  child: Text(f,
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFF3C494E),
                    )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSoft;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSoft = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSoft ? null : LinearGradient(
            colors: [const Color(0xFF00677F), const Color(0xFF055DB6)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          color: isSoft ? const Color(0xFF00D2FF).withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSoft ? const Color(0xFF00566A) : Colors.white),
            const SizedBox(width: 6),
            Text(label,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: isSoft ? const Color(0xFF00566A) : Colors.white,
              )),
          ],
        ),
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _FolderCard({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EduCamColors.surface.withOpacity(0.7),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 36, color: iconColor),
              Icon(Icons.more_vert_rounded, size: 20,
                color: const Color(0xFFBBC9CF)),
            ],
          ),
          const SizedBox(height: 12),
          Text(name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
              color: Color(0xFF191C1E))),
          const SizedBox(height: 4),
          Text(subtitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
              color: Color(0xFF3C494E), letterSpacing: 0.05)),
        ],
      ),
    );
  }
}

class _FoldersSection extends StatelessWidget {
  const _FoldersSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Folders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Tous les dossiers'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                ));
              },
              child: const Text('View all',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00677F))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = (constraints.maxWidth - 16) / 3;
            return Row(
              children: [
                SizedBox(
                  width: w,
                  child: const _FolderCard(
                    name: 'Mathematics 101',
                    subtitle: '24 items \u2022 Updated 2h ago',
                    icon: Icons.folder_rounded,
                    iconColor: Color(0xFF00677F),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: w,
                  child: const _FolderCard(
                    name: 'Physics Lab Prep',
                    subtitle: '12 items \u2022 Updated Yesterday',
                    icon: Icons.folder_rounded,
                    iconColor: Color(0xFF055DB6),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: w,
                  child: const _FolderCard(
                    name: 'Historical Archives',
                    subtitle: '56 items \u2022 Updated 1w ago',
                    icon: Icons.folder_rounded,
                    iconColor: Color(0xFF406900),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RecentFilesSection extends StatelessWidget {
  const _RecentFilesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Files',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
        const SizedBox(height: 16),
        _FileItem(
          icon: Icons.picture_as_pdf_rounded,
          iconBg: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFC62828),
          name: 'Calculus_Final_Exam_Draft.pdf',
          meta: '2.4 MB \u2022 Added Oct 12, 2023',
          tag: 'Exam',
        ),
        const SizedBox(height: 8),
        _FileItem(
          icon: Icons.slideshow_rounded,
          iconBg: const Color(0xFFE3F2FD),
          iconColor: const Color(0xFF1565C0),
          name: 'Quantum_Physics_Intro.pptx',
          meta: '15.8 MB \u2022 Added Oct 11, 2023',
          tag: 'Physics',
        ),
        const SizedBox(height: 8),
        _FileItem(
          icon: Icons.table_view_rounded,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          name: 'Student_Grades_Q3.csv',
          meta: '450 KB \u2022 Added Oct 10, 2023',
          tag: 'Grades',
        ),
      ],
    );
  }
}

class _FileItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final String meta;
  final String tag;

  const _FileItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.name,
    required this.meta,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface.withOpacity(0.7),
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
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1E)),
                  overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(meta,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF3C494E))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFECEFF1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(tag,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                color: Color(0xFF3C494E), letterSpacing: 0.05)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.download_rounded, size: 20, color: Color(0xFFBBC9CF)),
        ],
      ),
    );
  }
}
