import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Text(
                'HR',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const DashboardViewBody(),
    );
  }
}

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _DashboardHeader(),
            SizedBox(height: 12),
            _StatsRow(),
            SizedBox(height: 12),
            _DashboardInfoBar(),
            SizedBox(height: 14),
            _OperationsOverviewSection(),
            SizedBox(height: 14),
            _QuickStatsSection(),
            SizedBox(height: 14),
            _SystemStatusSection(),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text(
                '8/2026',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final statList = [
          (
            'TOTAL EMPLOYEES',
            '5',
            'All active workforce',
            Icons.group_rounded,
            const Color(0xFF60A5FA),
          ),
          (
            'DEPARTMENTS',
            '3',
            'Operational units\n100% active rate',
            Icons.apartment_rounded,
            AppColors.success,
          ),
          (
            'PENDING LEAVES',
            '0',
            'Awaiting HR approval',
            Icons.beach_access_rounded,
            const Color(0xFFF59E0B),
          ),
          (
            'TODAY\'S ATTENDANCE',
            '4',
            'Checked in today',
            Icons.fingerprint_rounded,
            const Color(0xFF8B5CF6),
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: statList[0].$1,
                      value: statList[0].$2,
                      subtitle: statList[0].$3,
                      icon: statList[0].$4,
                      color: statList[0].$5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      title: statList[1].$1,
                      value: statList[1].$2,
                      subtitle: statList[1].$3,
                      icon: statList[1].$4,
                      color: statList[1].$5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: statList[2].$1,
                      value: statList[2].$2,
                      subtitle: statList[2].$3,
                      icon: statList[2].$4,
                      color: statList[2].$5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      title: statList[3].$1,
                      value: statList[3].$2,
                      subtitle: statList[3].$3,
                      icon: statList[3].$4,
                      color: statList[3].$5,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: statList
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(right: entry.key < 3 ? 10 : 0),
                    child: SizedBox(
                      width: 180,
                      child: _StatCard(
                        title: entry.value.$1,
                        value: entry.value.$2,
                        subtitle: entry.value.$3,
                        icon: entry.value.$4,
                        color: entry.value.$5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 18,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardInfoBar extends StatelessWidget {
  const _DashboardInfoBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_done_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HR Operations System:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'All core modules operational & synced',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Updated automatically',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationsOverviewSection extends StatelessWidget {
  const _OperationsOverviewSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Operations Overview',
                style: AppTextStyles.titleMedium,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Healthy',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OverviewCard(
            items: const [
              OverviewItem(
                title: 'Active Workforce',
                subtitle: '5 team members online & active',
                icon: Icons.group_rounded,
                badgeText: 'Live',
              ),
              OverviewItem(
                title: 'Pending Leaves',
                subtitle: '0 requests awaiting approval',
                icon: Icons.calendar_today_rounded,
              ),
              OverviewItem(
                title: "Today's Attendance",
                subtitle: '4 employees checked in',
                icon: Icons.fingerprint_rounded,
              ),
              OverviewItem(
                title: 'Department Structure',
                subtitle: '3 active operational units',
                icon: Icons.apartment_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStatsSection extends StatelessWidget {
  const _QuickStatsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.bolt_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text('Quick Stats', style: AppTextStyles.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          childAspectRatio: 2.2,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            StatCard(
              title: 'Projects',
              value: '1',
              icon: Icons.folder_open_rounded,
              accentColor: Color(0xFF4F46E5),
            ),
            StatCard(
              title: 'Open Tasks',
              value: '3',
              icon: Icons.task_alt_rounded,
              accentColor: Color(0xFF0EA5E9),
            ),
            StatCard(
              title: 'Leave Requests',
              value: '0',
              icon: Icons.beach_access_rounded,
              accentColor: Color(0xFFF97316),
            ),
            StatCard(
              title: 'System',
              value: 'Online',
              icon: Icons.cloud_done_rounded,
              valueColor: AppColors.success,
              accentColor: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }
}

class _SystemStatusSection extends StatelessWidget {
  const _SystemStatusSection();

  @override
  Widget build(BuildContext context) {
    return SystemStatus(
      statusText: 'All systems operational',
      lastUpdated: DateTime.now(),
    );
  }
}
