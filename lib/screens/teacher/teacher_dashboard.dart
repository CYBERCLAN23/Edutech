import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
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
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StaggerItem(index: 0, child: _HeroSection()),
                      SizedBox(height: 24),
                      StaggerItem(index: 1, child: _StatsRow()),
                      SizedBox(height: 24),
                      StaggerItem(index: 2, child: _ClassOverviewSection()),
                      SizedBox(height: 24),
                      StaggerItem(index: 3, child: _RecentSubmissionsSection()),
                      SizedBox(height: 32),
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
        color: EduCamColors.surface,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('EA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
          ),
          const SizedBox(width: 12),
          const Text('EduCam AI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.notifications_outlined, size: 24, color: EduCamColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bonjour, Professeur',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
            const SizedBox(height: 4),
            const Text("Voici l'apercu de vos classes pour aujourd'hui.",
              style: TextStyle(fontSize: 16, color: EduCamColors.secondaryText)),
            const SizedBox(height: 20),
            Row(
              children: [
                _HeroActionButton(
                  label: 'Add Content',
                  icon: Icons.add,
                  isFilled: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ajout de contenu - Bientot disponible'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _HeroActionButton(
                  label: 'Grade',
                  icon: Icons.grading,
                  isFilled: false,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correction - Bientot disponible'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _HeroActionButton(
                  label: 'Message',
                  icon: Icons.chat,
                  isFilled: false,
                  isOutline: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Messagerie - Bientot disponible'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isFilled;
  final bool isOutline;
  final VoidCallback onTap;

  const _HeroActionButton({
    required this.label, required this.icon,
    required this.isFilled, this.isOutline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isFilled ? EduCamColors.accent : (isOutline ? Colors.transparent : EduCamColors.surface),
          borderRadius: BorderRadius.circular(8),
          border: isOutline ? Border.all(color: const Color(0xFF74777D)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18,
              color: isFilled ? EduCamColors.surface : (isOutline ? EduCamColors.secondaryText : EduCamColors.accent)),
            const SizedBox(width: 4),
            Text(label,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: isFilled ? EduCamColors.surface : (isOutline ? EduCamColors.secondaryText : EduCamColors.accent),
              )),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _TeacherStatCard(
                icon: Icons.groups, value: '128', label: 'Eleves',
                circleBgColor: const Color(0xFFD6E4F9).withOpacity(0.2), iconColor: EduCamColors.primary,
              )),
              const SizedBox(width: 12),
              Expanded(child: _TeacherStatCard(
                icon: Icons.meeting_room, value: '4', label: 'Classes',
                circleBgColor: const Color(0xFFE2DFFF).withOpacity(0.2), iconColor: EduCamColors.accent,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _TeacherStatCard(
                icon: Icons.assignment_turned_in, value: '8', label: 'A corriger',
                circleBgColor: const Color(0xFFFFDAD6).withOpacity(0.5), iconColor: EduCamColors.error,
                topBarColor: EduCamColors.error,
              )),
              const SizedBox(width: 12),
              Expanded(child: _TeacherStatCard(
                icon: Icons.trending_up, value: '82%', label: 'Reussite',
                circleBgColor: const Color(0xFFFFDDBA).withOpacity(0.3), iconColor: const Color(0xFF2A1700),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeacherStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color circleBgColor;
  final Color iconColor;
  final Color? topBarColor;

  const _TeacherStatCard({
    required this.icon, required this.value, required this.label,
    required this.circleBgColor, required this.iconColor,
    this.topBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (topBarColor != null)
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: topBarColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: circleBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(height: 12),
              Text(value,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
              Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.secondaryText)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassOverviewSection extends StatelessWidget {
  const _ClassOverviewSection();

  final _classes = const [
    {'name': 'Terminale C', 'subject': 'Mathematiques Avancees', 'students': 32, 'progress': 0.75, 'color': Color(0xFF4F46E5)},
    {'name': 'Seconde C', 'subject': 'Physique-Chimie', 'students': 45, 'progress': 0.40, 'color': Color(0xFF2A1700)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Apercu des classes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
              Text('Voir tout',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: EduCamColors.accent)),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: _classes.asMap().entries.map((e) {
              final c = e.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ClassCard(
                  name: c['name'] as String,
                  subject: c['subject'] as String,
                  students: c['students'] as int,
                  progress: c['progress'] as double,
                  color: c['color'] as Color,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String name;
  final String subject;
  final int students;
  final double progress;
  final Color color;

  const _ClassCard({
    required this.name, required this.subject, required this.students,
    required this.progress, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                    Text(subject,
                      style: const TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$students Eleves',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE6E8EA),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Progression du trimestre: ${(progress * 100).round()}%',
                style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSubmissionsSection extends StatelessWidget {
  const _RecentSubmissionsSection();

  final _submissions = const [
    {'initials': 'AM', 'name': 'Alain Mvondo', 'assignment': 'Equations Differentielles', 'status': 'En attente'},
    {'initials': 'CB', 'name': 'Clarisse Biya', 'assignment': 'Dynamique des Fluides', 'status': 'Corrige'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Submissions recentes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC4C6CC).withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D1B2A).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _submissions.asMap().entries.map((e) {
                final s = e.value;
                final isLast = e.key == _submissions.length - 1;
                final isPending = s['status'] == 'En attente';
                final statusColor = isPending ? EduCamColors.error : EduCamColors.accent;
                final statusBgColor = isPending
                    ? const Color(0xFFFFDAD6).withOpacity(0.3)
                    : EduCamColors.accent.withOpacity(0.08);

                return GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: isLast ? null : Border(
                        bottom: BorderSide(color: const Color(0xFFC4C6CC).withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E3E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(s['initials'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.secondaryText)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['name'] as String,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                              Text('Devoir: ${s['assignment']}',
                                style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPending ? Icons.pending : Icons.check_circle,
                                size: 14, color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(s['status'] as String,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: statusColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
