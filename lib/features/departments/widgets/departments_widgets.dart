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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _DepartmentsHeader(),
            SizedBox(height: 12),
            _SummaryRow(),
            SizedBox(height: 12),
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Departments',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last updated: 8/6/2026',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(label: '${departments.length} total'),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          const SizedBox(height: 8),
          ...departments.map(
            (item) => Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: DepartmentItemCardMobile(item: item),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DepartmentTableHeader extends StatelessWidget {
  const _DepartmentTableHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = AppTextStyles.labelMedium.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
    );

    return Row(
      children: [
        Expanded(flex: 3, child: Text('Department', style: headerStyle)),
        Expanded(flex: 2, child: Text('Description', style: headerStyle)),
        Expanded(child: Text('Team', style: headerStyle)),
        Expanded(child: Text('Head', style: headerStyle)),
        Expanded(child: Text('Status', style: headerStyle)),
        SizedBox(
          width: 140,
          child: Text('Actions', style: headerStyle, textAlign: TextAlign.end),
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

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 14,
      children: [
        SizedBox(
          width: 280,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withAlpha(24),
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
                      item.shortCode,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            item.team,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            item.head,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(width: 110, child: _StatusChip(status: item.status)),
        SizedBox(
          width: 180,
          child: Row(
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
        ),
      ],
    );
  }
}

class DepartmentItemCardMobile extends StatelessWidget {
  final DepartmentItem item;

  const DepartmentItemCardMobile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withAlpha(24),
                child: Text(
                  item.shortCode,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
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
              _StatusChip(status: item.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Edit',
                  color: theme.colorScheme.primary,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: 'Delete',
                  color: AppColors.error,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withAlpha(24)
            : AppColors.warning.withAlpha(24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isActive ? AppColors.success : AppColors.warning,
          fontWeight: FontWeight.w700,
        ),
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
