import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/providers/connectivity_provider.dart';
import 'package:educam_ai/services/offline_service.dart';

class OfflinePill extends ConsumerWidget {
  final bool compact;

  const OfflinePill({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);
    final isOnline = connectivity.valueOrNull == ConnectivityStatus.online;

    final bgColor = isOnline ? EduCamColors.success : EduCamColors.highlight;
    final label = isOnline ? 'En ligne' : 'Hors ligne';
    final borderColor = isOnline
        ? EduCamColors.success.withOpacity(0.3)
        : EduCamColors.highlight.withOpacity(0.3);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 3 : 4),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: EduCamTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: bgColor,
            ),
          ),
        ],
      ),
    );
  }
}
