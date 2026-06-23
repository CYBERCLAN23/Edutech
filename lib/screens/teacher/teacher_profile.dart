import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({super.key});

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
                  child: Text('Analyse par classe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                _ClassAnalyticsRow(label: 'Terminale C', avg: '13.5', students: 32, passed: 28, color: EduCamColors.subjectMaths, index: 3),
                _ClassAnalyticsRow(label: 'Terminale D', avg: '12.8', students: 35, passed: 27, color: EduCamColors.subjectSVT, index: 4),
                _ClassAnalyticsRow(label: 'Premiere C', avg: '11.2', students: 30, passed: 20, color: EduCamColors.subjectHistoire, index: 5),
                _ClassAnalyticsRow(label: 'Seconde C', avg: '14.1', students: 31, passed: 29, color: EduCamColors.subjectPhysique, index: 6),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 7,
                  child: Text('Parametres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                StaggerItem(index: 8, child: _MenuTile(icon: Icons.notifications_outlined, label: 'Notifications', value: 'Activees')),
                const SizedBox(height: 8),
                StaggerItem(index: 9, child: _MenuTile(icon: Icons.download_rounded, label: 'Stockage utilise', value: '2.4 GB')),
                const SizedBox(height: 8),
                StaggerItem(index: 10, child: _MenuTile(icon: Icons.info_outline, label: 'Version', value: '1.0.0')),
                const SizedBox(height: 8),
                StaggerItem(index: 11, child: _MenuTile(icon: Icons.mail_outline, label: 'Contact', value: 'support@educam.cm')),
                const SizedBox(height: 8),
                StaggerItem(index: 12, child: _MenuTile(icon: Icons.description_outlined, label: 'Conditions d\'utilisation', value: null, hasArrow: true)),
                const SizedBox(height: 8),
                StaggerItem(index: 13, child: _MenuTile(icon: Icons.shield_outlined, label: 'Politique de confidentialite', value: null, hasArrow: true)),
                const SizedBox(height: 24),
                StaggerItem(
                  index: 14,
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
              colors: [EduCamColors.highlight, Color(0xFFF97316)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(child: Text('MN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.surface))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('M. Nkwi David', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
              const SizedBox(height: 2),
              const Text('Professeur de Mathematiques\nLycee General Leclerc', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
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
          icon: const Icon(Icons.edit_outlined, size: 18, color: EduCamColors.highlight),
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
          const Text('Performance globale', style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
          const SizedBox(height: 4),
          const Text('82%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: EduCamColors.success)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(label: 'Taux de reussite', value: '82%'),
              _MiniStat(label: 'Moyenne classe', value: '12.8'),
              _MiniStat(label: 'Soumissions', value: '143'),
            ],
          ),
        ],
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
        Text(label, style: const TextStyle(fontSize: 10, color: EduCamColors.secondaryText)),
      ],
    );
  }
}

class _ClassAnalyticsRow extends StatelessWidget {
  final String label; final String avg; final int students; final int passed; final Color color; final int index;
  const _ClassAnalyticsRow({required this.label, required this.avg, required this.students, required this.passed, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    final rate = students > 0 ? passed / students : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: StaggerItem(
        index: index,
        child: GestureDetector(
          onTap: () => HapticFeedback.lightImpact(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                    Text('$avg/20', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('$passed/$students reussite', style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                    const Spacer(),
                    Text('${(rate * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: rate >= 0.8 ? EduCamColors.success : EduCamColors.highlight)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: rate,
                    backgroundColor: EduCamColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(rate >= 0.8 ? EduCamColors.success : color),
                    minHeight: 4,
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

class _MenuTile extends StatelessWidget {
  final IconData icon; final String label; final String? value; final bool hasArrow;
  const _MenuTile({required this.icon, required this.label, this.value, this.hasArrow = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (hasArrow) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(milliseconds: 1200),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: EduCamColors.secondaryText),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: EduCamColors.primary))),
            if (value != null) Text(value!, style: const TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
            if (hasArrow) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, size: 18, color: EduCamColors.secondaryText),
            ],
          ],
        ),
      ),
    );
  }
}
