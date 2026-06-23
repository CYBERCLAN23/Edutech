import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  String _selected = 'EN';

  final _languages = [
    {'code': 'EN', 'name': 'English'},
    {'code': 'FR', 'name': 'Francais'},
    {'code': 'FUL', 'name': 'Fulfulde'},
    {'code': 'EWO', 'name': 'Ewondo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _languages.map((lang) {
        final isSelected = _selected == lang['code'];
        return GestureDetector(
          onTap: () => setState(() => _selected = lang['code'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? EduCamColors.accent.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? EduCamColors.accent : EduCamColors.cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              lang['name'] as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? EduCamColors.accent : EduCamColors.secondaryText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
