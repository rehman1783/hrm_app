import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OverviewCard extends StatelessWidget {
  final List<OverviewItem> items;

  const OverviewCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      shadowColor: AppColors.primary.withAlpha(31),
      child: Column(
        children: items
            .map(
              (item) => Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    trailing: item.badgeText != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(37, 99, 235, 0.12),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              item.badgeText!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.hintLight,
                          ),
                  ),
                  if (item != items.last)
                    const Divider(height: 1, indent: 18, endIndent: 18),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class OverviewItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? badgeText;

  const OverviewItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeText,
  });
}
