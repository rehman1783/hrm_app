import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SystemStatus extends StatelessWidget {
  final String statusText;
  final DateTime lastUpdated;

  const SystemStatus({
    super.key,
    required this.statusText,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(statusText, style: AppTextStyles.bodyLarge)),
            Text(
              'Updated ${TimeOfDay.fromDateTime(lastUpdated).format(context)}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      ),
    );
  }
}
