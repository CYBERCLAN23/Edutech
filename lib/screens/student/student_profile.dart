import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/services/theme_provider.dart';
import 'package:educam_ai/services/locale_provider.dart';
import 'package:educam_ai/services/translations.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool _offlineMode = true;
  bool _notificationsEnabled = true;

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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StaggerItem(index: 0, child: _ProfileHeader()),
                const SizedBox(height: 24),
                const StaggerItem(index: 1, child: _StatsCard()),
                const SizedBox(height: 20),
                const StaggerItem(
                  index: 2,
                  child: Text('Bulletin par matiere', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                _GradeRow(subject: 'Mathematiques', score: '16', color: EduCamColors.subjectMaths, index: 3),
                _GradeRow(subject: 'SVT', score: '17', color: EduCamColors.subjectSVT, index: 4),
                _GradeRow(subject: 'Histoire-Geo', score: '13', color: EduCamColors.subjectHistoire, index: 5),
                _GradeRow(subject: 'Physique-Chimie', score: '12', color: EduCamColors.subjectPhysique, index: 6),
                _GradeRow(subject: 'Francais', score: '14', color: EduCamColors.subjectFrancais, index: 7),
                _GradeRow(subject: 'Anglais', score: '15', color: EduCamColors.subjectAnglais, index: 8),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 9,
                  child: Text('Parametres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                StaggerItem(index: 10, child: _SettingsSection(offlineMode: _offlineMode, notificationsEnabled: _notificationsEnabled, onChanged: (offline, notif) => setState(() { _offlineMode = offline; _notificationsEnabled = notif; }))),
                const SizedBox(height: 14),
                const StaggerItem(index: 11, child: _LocaleSection()),
                const SizedBox(height: 14),
                StaggerItem(index: 12, child: _AboutRow(icon: Icons.download_rounded, label: 'Stockage utilise', value: '180 MB')),
                const SizedBox(height: 8),
                StaggerItem(index: 13, child: _AboutRow(icon: Icons.info_outline, label: 'Version', value: '1.0.0')),
                const SizedBox(height: 8),
                StaggerItem(index: 14, child: _AboutRow(icon: Icons.mail_outline, label: 'Contact', value: 'support@educam.cm')),
                const SizedBox(height: 24),
                StaggerItem(
                  index: 15,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Deconnexion...'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child: const Text('Deconnexion', style: TextStyle(fontSize: 14, color: EduCamColors.error, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [EduCamColors.accent, Color(0xFF7C3AED)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(child: Text('SM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Samuel Mbarga', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
              const SizedBox(height: 2),
              const Text('Terminale C - Lycee General Leclerc', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Edition du profil'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(milliseconds: 1200),
              ),
            );
          },
          icon: const Icon(Icons.edit_outlined, size: 18, color: EduCamColors.accent),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          tooltip: 'Modifier le profil',
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Column(
        children: [
          const Text('Moyenne generale', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
          const SizedBox(height: 4),
          const Text('14.5 / 20', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: EduCamColors.success)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(label: 'Rang', value: '5e / 42'),
              _MiniStat(label: 'Assiduite', value: '94%'),
              _MiniStat(label: 'Devoirs', value: '18/21'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends ConsumerWidget {
  final bool offlineMode;
  final bool notificationsEnabled;
  final void Function(bool, bool) onChanged;
  const _SettingsSection({required this.offlineMode, required this.notificationsEnabled, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Column(
        children: [
          _SettingToggle(icon: Icons.wifi_off_rounded, title: 'Mode hors-ligne', value: offlineMode, onChanged: (v) => onChanged(v, notificationsEnabled)),
          const SizedBox(height: 14),
          _SettingToggle(icon: Icons.notifications_outlined, title: 'Notifications', value: notificationsEnabled, onChanged: (v) => onChanged(offlineMode, v)),
          const SizedBox(height: 14),
          _ThemeToggleTile(isDark: isDark),
        ],
      ),
    );
  }
}

class _ThemeToggleTile extends ConsumerWidget {
  final bool isDark;
  const _ThemeToggleTile({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(themeModeProvider.notifier).toggle();
      },
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: EduCamColors.highlight.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, size: 18, color: EduCamColors.highlight),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(isDark ? 'Mode sombre' : 'Mode clair', style: const TextStyle(fontSize: 14, color: EduCamColors.primary))),
          _Switch(value: isDark, onChanged: (_) => ref.read(themeModeProvider.notifier).toggle()),
        ],
      ),
    );
  }
}

class _LocaleSection extends ConsumerWidget {
  const _LocaleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isFr = locale.languageCode == 'fr';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Langue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
          const SizedBox(height: 10),
          Row(
            children: [
              _LocaleChip(label: 'FR', selected: isFr, onTap: () => ref.read(localeProvider.notifier).setFr()),
              const SizedBox(width: 8),
              _LocaleChip(label: 'EN', selected: !isFr, onTap: () => ref.read(localeProvider.notifier).setEn()),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocaleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LocaleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? EduCamColors.accent.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? EduCamColors.accent : EduCamColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? EduCamColors.accent : EduCamColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label; final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
      ],
    );
  }
}

class _GradeRow extends StatelessWidget {
  final String subject; final String score; final Color color; final int index;
  const _GradeRow({required this.subject, required this.score, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StaggerItem(
        index: index,
        child: GestureDetector(
          onTap: () => HapticFeedback.lightImpact(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
            ),
            child: Row(
              children: [
                Expanded(child: Text(subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: EduCamColors.primary))),
                Row(
                  children: [
                    Text('$score/20', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                    const SizedBox(width: 8),
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon; final String title; final bool value; final ValueChanged<bool> onChanged;
  const _SettingToggle({required this.icon, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: EduCamColors.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: EduCamColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, color: EduCamColors.primary))),
          _Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  final bool value; final ValueChanged<bool> onChanged;
  const _Switch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44, height: 26,
        decoration: BoxDecoration(
          color: value ? EduCamColors.accent : EduCamColors.cardBorder,
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _AboutRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: EduCamColors.secondaryText),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: EduCamColors.primary))),
          Text(value, style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}
