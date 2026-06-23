import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/models/app_role.dart';
import 'package:educam_ai/widgets/language_toggle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offlineMode = true;
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _autoSave = true;
  double _fontSize = 1.0;

  Widget _buildRoleBadge() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: EduCamColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Personnalise ton experience',
                        style: TextStyle(
                          fontSize: 14,
                          color: EduCamColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  _buildRoleBadge(),
                ],
              ),
              const SizedBox(height: 28),
              _SectionCard(
                title: 'Langue d\'apprentissage',
                subtitle: 'Choisis ta langue preferee',
                child: const LanguageToggle(),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Preferences',
                subtitle: 'Mode hors-ligne, notifications',
                child: Column(
                  children: [
                    _SettingsToggle(
                      icon: Icons.wifi_off_rounded,
                      title: 'Mode hors-ligne',
                      subtitle: 'Telecharge les lecons pour reviser sans connexion',
                      value: _offlineMode,
                      onChanged: (v) => setState(() => _offlineMode = v),
                    ),
                    const SizedBox(height: 12),
                    _SettingsToggle(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Rappels de revision et nouveaux cours',
                      value: _notificationsEnabled,
                      onChanged: (v) => setState(() => _notificationsEnabled = v),
                    ),
                    const SizedBox(height: 12),
                    _SettingsToggle(
                      icon: Icons.dark_mode_outlined,
                      title: 'Mode sombre',
                      subtitle: 'Theme fonce pour etudier la nuit',
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                    ),
                    const SizedBox(height: 12),
                    _SettingsToggle(
                      icon: Icons.save_outlined,
                      title: 'Sauvegarde auto',
                      subtitle: 'Sauvegarde automatique des progres',
                      value: _autoSave,
                      onChanged: (v) => setState(() => _autoSave = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Taille du texte',
                subtitle: 'Ajuste la lisibilite',
                child: Row(
                  children: [
                    const Text('A', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 0.8,
                        max: 1.4,
                        divisions: 6,
                        activeColor: EduCamColors.accent,
                        inactiveColor: EduCamColors.progressTrack,
                        onChanged: (v) => setState(() => _fontSize = v),
                      ),
                    ),
                    const Text('A', style: TextStyle(fontSize: 20, color: EduCamColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Stockage',
                subtitle: 'Contenu telecharge',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StorageRow(
                      icon: Icons.download_rounded,
                      label: 'Lecons hors-ligne',
                      size: '156 MB',
                    ),
                    const SizedBox(height: 12),
                    _StorageRow(
                      icon: Icons.fact_check_outlined,
                      label: 'Corrections sauvegardees',
                      size: '24 MB',
                    ),
                    const SizedBox(height: 12),
                    _StorageRow(
                      icon: Icons.mic_outlined,
                      label: 'Fichiers audio',
                      size: '0 MB',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Vider le cache'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: EduCamColors.error,
                          side: const BorderSide(color: EduCamColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'A propos',
                subtitle: 'EduCam AI v1.0.0',
                child: Column(
                  children: [
                    _AboutRow(
                      icon: Icons.info_outline,
                      label: 'Version',
                      value: '1.0.0 (Build 2026)',
                    ),
                    const SizedBox(height: 12),
                    _AboutRow(
                      icon: Icons.description_outlined,
                      label: "Conditions d'utilisation",
                      value: null,
                      hasArrow: true,
                    ),
                    const SizedBox(height: 12),
                    _AboutRow(
                      icon: Icons.shield_outlined,
                      label: 'Politique de confidentialite',
                      value: null,
                      hasArrow: true,
                    ),
                    const SizedBox(height: 12),
                    _AboutRow(
                      icon: Icons.mail_outline,
                      label: 'Contact',
                      value: 'support@educam.cm',
                      hasArrow: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: EduCamColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: EduCamColors.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: EduCamColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: EduCamColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: EduCamColors.primary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: EduCamColors.secondaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _CustomSwitch(
          value: value,
          activeColor: EduCamColors.accent,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: value ? activeColor : EduCamColors.cardBorder,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StorageRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String size;

  const _StorageRow({
    required this.icon,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: EduCamColors.accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: EduCamColors.secondaryText),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: EduCamColors.primary,
            ),
          ),
        ),
        Text(
          size,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: EduCamColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool hasArrow;

  const _AboutRow({
    required this.icon,
    required this.label,
    this.value,
    this.hasArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: EduCamColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: EduCamColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: EduCamColors.primary,
            ),
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: const TextStyle(
              fontSize: 13,
              color: EduCamColors.secondaryText,
            ),
          ),
        if (hasArrow) ...[
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: EduCamColors.secondaryText,
          ),
        ],
      ],
    );
  }
}
