import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';

class OfflinePill extends StatelessWidget {
  final bool isOfflineReady;

  const OfflinePill({
    super.key,
    this.isOfflineReady = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOfflineReady ? EduCamColors.success.withValues(alpha: 0.3) : EduCamColors.highlight.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: EduCamTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOfflineReady ? EduCamColors.success : EduCamColors.highlight,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOfflineReady ? 'Offline ready' : 'Syncing',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOfflineReady ? EduCamColors.success : EduCamColors.highlight,
            ),
          ),
        ],
      ),
    );
  }
}
