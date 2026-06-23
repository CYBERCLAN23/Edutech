import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/app_role.dart';
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
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StaggerItem(index: 0, child: _Header()),
                const SizedBox(height: 20),
                const StaggerItem(index: 1, child: _GreetingSection()),
                const SizedBox(height: 20),
                const StaggerItem(index: 2, child: _StatsRow()),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 3,
                  child: _SectionHeader(title: 'Soumissions recentes', subtitle: 'Devoirs a corriger'),
                ),
                const SizedBox(height: 12),
                const StaggerItem(index: 4, child: _RecentSubmissions()),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 5,
                  child: _SectionHeader(title: 'Vue d\'ensemble des classes', subtitle: 'Tes 4 classes'),
                ),
                const SizedBox(height: 12),
                const StaggerItem(index: 6, child: _ClassOverview()),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 7,
                  child: _SectionHeader(title: 'Actions rapides', subtitle: 'Outils pedagogiques'),
                ),
                const SizedBox(height: 12),
                StaggerItem(index: 8, child: _QuickActions(context: context)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('EA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('EduCam AI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                  _RoleBadge(),
                ],
              ),
            ],
          ),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Aucune notification'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(milliseconds: 1200),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_outlined, size: 20, color: EduCamColors.primary),
              padding: EdgeInsets.zero,
              tooltip: 'Notifications',
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge();

  @override
  Widget build(BuildContext context) {
    final role = AppSession.currentRole;
    final label = role == AppRole.teacher ? 'PROFESSEUR' : role == AppRole.admin ? 'ADMIN' : 'ELEVE';
    final color = role == AppRole.teacher ? EduCamColors.highlight : EduCamColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color, letterSpacing: 1)),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Bonjour' : hour < 17 ? 'Bon apres-midi' : 'Bonsoir';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting, M. Nkwi', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
          const SizedBox(height: 4),
          const Text('4 classes, 128 eleves, 8 devoirs a corriger', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _StatCard(icon: Icons.people_rounded, value: '128', label: 'Eleves', color: EduCamColors.accent),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.menu_book_rounded, value: '4', label: 'Classes', color: EduCamColors.highlight),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.assignment_rounded, value: '8', label: 'A corriger', color: EduCamColors.error),
          const SizedBox(width: 10),
          _StatCard(icon: Icons.trending_up_rounded, value: '82%', label: 'Reussite', color: EduCamColors.success),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String value; final String label; final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: EduCamColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}

class _RecentSubmissions extends StatelessWidget {
  const _RecentSubmissions();

  final _submissions = const [
    {'student': 'Samuel Mbarga', 'subject': 'Mathematiques', 'time': 'Il y a 30 min', 'color': EduCamColors.subjectMaths, 'status': 'Non corrige'},
    {'student': 'Alice Ngo', 'subject': 'Physique-Chimie', 'time': 'Il y a 1h', 'color': EduCamColors.subjectPhysique, 'status': 'Non corrige'},
    {'student': 'Paul Biya Jr', 'subject': 'Histoire-Geo', 'time': 'Il y a 2h', 'color': EduCamColors.subjectHistoire, 'status': 'Corrige'},
    {'student': 'Marie Eyanga', 'subject': 'SVT', 'time': 'Il y a 3h', 'color': EduCamColors.subjectSVT, 'status': 'Non corrige'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _submissions.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: StaggerItem(
              index: i,
              child: GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
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
                          color: (s['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.person_rounded, size: 18, color: s['color'] as Color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['student'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                            Text('${s['subject']} - ${s['time']}', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: s['status'] == 'Corrige'
                              ? EduCamColors.success.withValues(alpha: 0.1)
                              : EduCamColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          s['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: s['status'] == 'Corrige' ? EduCamColors.success : EduCamColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ClassOverview extends StatelessWidget {
  const _ClassOverview();

  final _classes = const [
    {'name': 'Terminale C', 'students': 32, 'avg': '13.5', 'color': EduCamColors.subjectMaths},
    {'name': 'Terminale D', 'students': 35, 'avg': '12.8', 'color': EduCamColors.subjectSVT},
    {'name': 'Premiere C', 'students': 30, 'avg': '11.2', 'color': EduCamColors.subjectHistoire},
    {'name': 'Seconde C', 'students': 31, 'avg': '14.1', 'color': EduCamColors.subjectPhysique},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _classes.asMap().entries.map((e) {
          final i = e.key;
          final c = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: StaggerItem(
              index: i,
              child: GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: (c['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            (c['name'] as String).split(' ').last,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c['color'] as Color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                            Text('${c['students']} eleves', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${c['avg']}/20', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c['color'] as Color)),
                          const Text('Moyenne', style: TextStyle(fontSize: 10, color: EduCamColors.secondaryText)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final BuildContext context;
  const _QuickActions({required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _ActionCard(icon: Icons.add_circle_outline, title: 'Nouveau cours', subtitle: 'Creer une lecon', color: EduCamColors.accent, onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Nouveau cours - Bientot disponible'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          })),
          const SizedBox(width: 12),
          Expanded(child: _ActionCard(icon: Icons.fact_check_outlined, title: 'Corriger', subtitle: 'Noter les devoirs', color: EduCamColors.highlight, onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Correction - Bientot disponible'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          })),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 42, height: 42,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title; final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}
