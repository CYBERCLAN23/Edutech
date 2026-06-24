import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
class StudentAssignments extends StatelessWidget {
  const StudentAssignments({super.key});

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
                StaggerItem(
                  index: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Devoirs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                          SizedBox(height: 4),
                          Text('2 a rendre, 3 termines', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => HapticFeedback.lightImpact(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: EduCamColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.filter_list_rounded, size: 20, color: EduCamColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 1,
                  child: Text('A rendre', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                ..._buildAssignmentList(urgent: true),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 3,
                  child: Text('Termines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                ..._buildAssignmentList(urgent: false),
                const SizedBox(height: 24),
                const StaggerItem(
                  index: 5,
                  child: Text('Notes recentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                ),
                const SizedBox(height: 12),
                ..._buildGradesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAssignmentList({required bool urgent}) {
    final items = urgent
        ? const [
            {'title': 'Exercice: Derivees', 'course': 'Mathematiques', 'due': 'Demain 08h', 'color': EduCamColors.subjectMaths},
            {'title': 'Dissertation: La colonisation', 'course': 'Histoire-Geo', 'due': 'Ven 28 Juin', 'color': EduCamColors.subjectHistoire},
          ]
        : const [
            {'title': 'Compte rendu TP SVT', 'course': 'SVT', 'due': 'Note: 16/20', 'color': EduCamColors.subjectSVT, 'grade': '16/20'},
            {'title': 'Exercice: Loi d\'Ohm', 'course': 'Physique-Chimie', 'due': 'Note: 14/20', 'color': EduCamColors.subjectPhysique, 'grade': '14/20'},
            {'title': 'Dissertation: Litterature', 'course': 'Francais', 'due': 'Note: 15/20', 'color': EduCamColors.subjectFrancais, 'grade': '15/20'},
          ];

    return items.asMap().entries.map((e) {
      final i = e.key;
      final a = e.value;
      final offset = urgent ? 2 : 4;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: StaggerItem(
          index: i + offset,
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
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.description_rounded, size: 18, color: a['color'] as Color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                        const SizedBox(height: 2),
                        Text(a['course'] as String, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: urgent ? EduCamColors.error.withOpacity(0.1) : EduCamColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      a['due'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: urgent ? EduCamColors.error : EduCamColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildGradesList() {
    final grades = const [
      {'subject': 'Mathematiques', 'score': '16/20', 'color': EduCamColors.subjectMaths},
      {'subject': 'Francais', 'score': '14/20', 'color': EduCamColors.subjectFrancais},
      {'subject': 'Anglais', 'score': '15/20', 'color': EduCamColors.subjectAnglais},
      {'subject': 'SVT', 'score': '17/20', 'color': EduCamColors.subjectSVT},
      {'subject': 'Histoire-Geo', 'score': '13/20', 'color': EduCamColors.subjectHistoire},
      {'subject': 'Physique-Chimie', 'score': '12/20', 'color': EduCamColors.subjectPhysique},
    ];

    return grades.asMap().entries.map((e) {
      final i = e.key;
      final g = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: StaggerItem(
          index: i + 7,
          child: GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: EduCamColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: (g['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.grade_rounded, size: 16, color: g['color'] as Color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(g['subject'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: EduCamColors.primary))),
                  Text(g['score'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: g['color'] as Color)),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
