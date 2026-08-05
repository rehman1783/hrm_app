import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class DepartmentsViewBody extends StatelessWidget {
  const DepartmentsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _DepartmentsHeader(),
            SizedBox(height: 22),
            _SummaryRow(),
            SizedBox(height: 24),
            _DepartmentList(),
          ],
        ),
      ),
    );
  }
}

class _DepartmentsHeader extends StatelessWidget {
  const _DepartmentsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Departments', style: AppTextStyles.headlineMedium),
              SizedBox(height: 6),
              Text(
                'Manage organizational structure and teams',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Department'),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: StatCard(
                title: 'Total Departments',
                value: '3',
                icon: Icons.apartment_rounded,
                accentColor: Color(0xFF60A5FA),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Active Departments',
                value: '3',
                icon: Icons.check_circle_rounded,
                accentColor: Color(0xFF34D399),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: StatCard(
                title: 'Total Employees',
                value: '9',
                icon: Icons.group_rounded,
                accentColor: Color(0xFFFBBF24),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Avg Per Dept',
                value: '3',
                icon: Icons.show_chart_rounded,
                accentColor: Color(0xFFA78BFA),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DepartmentList extends StatelessWidget {
  const _DepartmentList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Text('All Departments', style: AppTextStyles.titleMedium),
        ),
        Column(
          children: departments
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DepartmentItemCard(item: item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class DepartmentItemCard extends StatelessWidget {
  final DepartmentItem item;

  const DepartmentItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withAlpha(31),
                child: Text(
                  item.shortCode,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.72),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          label: item.team,
                          color: theme.colorScheme.primary.withAlpha(24),
                          textColor: theme.colorScheme.primary,
                        ),
                        _InfoChip(
                          label: item.head,
                          color: theme.colorScheme.surfaceVariant,
                          textColor: theme.colorScheme.onSurface,
                        ),
                        _InfoChip(
                          label: item.status,
                          color: item.status == 'Active'
                              ? AppColors.success.withAlpha(31)
                              : AppColors.warning.withAlpha(31),
                          textColor: item.status == 'Active'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                label: 'Edit',
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _ActionButton(
                label: 'Delete',
                color: AppColors.error,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _InfoChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(31),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class DepartmentItem {
  final String shortCode;
  final String name;
  final String description;
  final String team;
  final String head;
  final String status;

  const DepartmentItem({
    required this.shortCode,
    required this.name,
    required this.description,
    required this.team,
    required this.head,
    required this.status,
  });
}

const departments = [
  DepartmentItem(
    shortCode: 'M',
    name: 'Marketing',
    description: 'WholCure Marketing',
    team: '5 members',
    head: '—',
    status: 'Active',
  ),
  DepartmentItem(
    shortCode: 'RE',
    name: 'Real Estate',
    description: 'EJG36',
    team: '1 members',
    head: '—',
    status: 'Active',
  ),
  DepartmentItem(
    shortCode: 'WT',
    name: 'WholCure Technology',
    description: 'This is Company for IT and Engineering',
    team: '3 members',
    head: '—',
    status: 'Active',
  ),
];
