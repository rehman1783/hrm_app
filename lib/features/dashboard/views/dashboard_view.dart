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
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(name: 'HR Manager'),
              const SizedBox(height: 12),
              const LiveStatusBar(),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withAlpha(80),
                  ),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Operations overview',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'A premium view of daily HR performance.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(24),
                            borderRadius: BorderRadius.circular(999),
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _Pill(label: '3 active teams'),
                        _Pill(label: '0 pending approvals'),
                        _Pill(label: '4 key modules'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Dashboard Overview', style: AppTextStyles.titleMedium),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OverviewCard(
                items: const [
                  OverviewItem(
                    title: 'Active Workforce',
                    subtitle: '0 team members online',
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
                    subtitle: '0 employees checked in',
                    icon: Icons.fingerprint_rounded,
                  ),
                  OverviewItem(
                    title: 'Department Structure',
                    subtitle: '0 active operational units',
                    icon: Icons.account_tree_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('Quick Stats', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
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
                    title: 'Leave',
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
              const SizedBox(height: 20),
              SystemStatus(
                statusText: 'All systems operational',
                lastUpdated: DateTime.now(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
