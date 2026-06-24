import 'package:flutter/material.dart';
import 'package:educam_ai/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: EduCamColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 36, color: EduCamColors.accent.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: EduCamColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: EduCamColors.secondaryText,
                height: 1.4,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'Une erreur est survenue',
      subtitle: message,
      action: onRetry != null
          ? OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reessayer'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          : null,
    );
  }
}
