import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LiveStatusBar extends StatelessWidget {
  const LiveStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: const [
              Icon(Icons.wifi, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Live — auto-refreshes every 60s',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          'Updated: ${TimeOfDay.now().format(context)}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
