import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';

class AdminSettings extends ConsumerWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Système', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: EduCamColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Serveur', items: [
            _SettingTile(icon: Icons.cloud_rounded, label: 'Statut', value: 'En ligne', color: EduCamColors.success),
            _SettingTile(icon: Icons.tag_rounded, label: 'Version API', value: 'v1.0.0', color: EduCamColors.accent),
            _SettingTile(icon: Icons.language_rounded, label: 'Environnement', value: 'Production', color: EduCamColors.highlight),
          ]),
          const SizedBox(height: 20),
          _Section(title: 'Préférences', items: [
            _SettingTile(icon: Icons.notifications_rounded, label: 'Notifications', value: 'Activées', color: EduCamColors.accent),
            _SettingTile(icon: Icons.palette_rounded, label: 'Thème', value: 'Clair', color: EduCamColors.highlight),
            _SettingTile(icon: Icons.translate_rounded, label: 'Langue', value: 'Français', color: EduCamColors.success),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.secondaryText)),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SettingTile({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          ),
          Text(value, style: GoogleFonts.poppins(fontSize: 12, color: EduCamColors.secondaryText)),
        ],
      ),
    );
  }
}
