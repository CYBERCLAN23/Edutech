import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/subject.dart';
import 'package:educam_ai/models/app_role.dart';
import 'package:educam_ai/widgets/subject_card.dart';
import 'package:educam_ai/widgets/progress_ring.dart';
import 'package:educam_ai/widgets/offline_pill.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalProgress = Subject.subjects.fold<double>(
      0,
      (sum, s) => sum + s.progress,
    ) / Subject.subjects.length;

    final completedLessons = Subject.subjects.fold<int>(
      0,
      (sum, s) => sum + s.lessonsCompleted,
    );
    final totalLessons = Subject.subjects.fold<int>(
      0,
      (sum, s) => sum + s.totalLessons,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 20),
              _GreetingSection(),
              const SizedBox(height: 24),
              _QuickActions(context),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Matieres',
                subtitle: 'Continue ton programme',
                actionLabel: 'Voir tout',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 224,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: Subject.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = Subject.subjects[index];
                    return SubjectCard(
                      title: subject.nameFr,
                      subtitle: subject.description,
                      icon: subject.icon,
                      color: subject.color,
                      progress: subject.progress,
                      lessonCount: '${subject.lessonsCompleted}/${subject.totalLessons}',
                      onTap: () {},
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Cette semaine',
                subtitle: 'Ta progression',
                actionLabel: null,
                onAction: null,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                    boxShadow: EduCamTheme.softShadow,
                  ),
                  child: Row(
                    children: [
                      ProgressRing(
                        progress: totalProgress,
                        size: 96,
                        color: EduCamColors.accent,
                        label: 'Complete',
                        value: '${(totalProgress * 100).round()}%',
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Super progression !',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: EduCamColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedLessons/$totalLessons lecons completees cette periode',
                              style: const TextStyle(
                                fontSize: 14,
                                color: EduCamColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: EduCamColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    size: 16,
                                    color: EduCamColors.success,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '+12% cette semaine',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: EduCamColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _RecentActivitySection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'EA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: EduCamColors.surface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'EduCam AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: EduCamColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              _RoleBadge(),
            ],
          ),
          Row(
            children: [
              const OfflinePill(),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: EduCamColors.primary,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final role = AppSession.currentRole;
    final label = role == AppRole.teacher
        ? 'PROFESSEUR'
        : role == AppRole.admin
            ? 'ADMIN'
            : 'ELEVE';
    final color = role == AppRole.teacher
        ? EduCamColors.highlight
        : EduCamColors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Bonjour'
        : hour < 17
            ? 'Bon apres-midi'
            : 'Bonsoir';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, Samuel',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: EduCamColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Prepare-toi pour le BAC avec TutorBot',
            style: TextStyle(
              fontSize: 15,
              color: EduCamColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final BuildContext context;

  _QuickActions(this.context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              icon: Icons.smart_toy_rounded,
              label: 'TutorBot',
              subtitle: 'Pose une question',
              color: EduCamColors.accent,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.camera_alt_rounded,
              label: 'CopyCorrector',
              subtitle: 'Corrige un devoir',
              color: EduCamColors.highlight,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
          boxShadow: EduCamTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: EduCamColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: EduCamColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: EduCamColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: EduCamColors.secondaryText,
                ),
              ),
            ],
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: EduCamColors.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.functions_rounded,
        'color': EduCamColors.subjectMaths,
        'title': 'Exercice: Equations du second degre',
        'subtitle': 'Il y a 30 min',
        'status': 'Termine',
      },
      {
        'icon': Icons.biotech_rounded,
        'color': EduCamColors.subjectSVT,
        'title': 'Cours: La cellule animale',
        'subtitle': 'Il y a 2 heures',
        'status': 'En cours',
      },
      {
        'icon': Icons.public_rounded,
        'color': EduCamColors.subjectHistoire,
        'title': 'Chapitre: Colonisation du Cameroun',
        'subtitle': 'Il y a 1 jour',
        'status': 'A revoir',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activite recente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: EduCamColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EduCamColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (a['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        a['icon'] as IconData,
                        size: 20,
                        color: a['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: EduCamColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            a['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: EduCamColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: a['status'] == 'Termine'
                            ? EduCamColors.success.withValues(alpha: 0.1)
                            : a['status'] == 'En cours'
                                ? EduCamColors.accent.withValues(alpha: 0.1)
                                : EduCamColors.highlight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        a['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: a['status'] == 'Termine'
                              ? EduCamColors.success
                              : a['status'] == 'En cours'
                                  ? EduCamColors.accent
                                  : EduCamColors.highlight,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
