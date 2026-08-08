import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../dashboard/widgets/drawer_widget.dart';

class MeetingsView extends StatelessWidget {
  const MeetingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Meetings'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MeetingsHeader(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Request Meeting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _MeetingStatsSection(),
              const SizedBox(height: 18),
              const _MeetingFilterRow(),
              const SizedBox(height: 18),
              const _MeetingListSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingsHeader extends StatelessWidget {
  const _MeetingsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meetings',
            style: AppTextStyles.headlineLarge.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Schedule and manage your meetings with anyone',
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.92),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '6 meetings',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'All meetings overview',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.76),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetingStatsSection extends StatelessWidget {
  const _MeetingStatsSection();

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _MeetingStatCard(
        title: 'Total',
        value: '6',
        subtitle: 'All meetings',
        icon: Icons.calendar_today_rounded,
        accent: Color(0xFF60A5FA),
      ),
      _MeetingStatCard(
        title: 'Pending',
        value: '2',
        subtitle: 'Awaiting response',
        icon: Icons.schedule_rounded,
        accent: Color(0xFFF59E0B),
      ),
      _MeetingStatCard(
        title: 'Approved',
        value: '3',
        subtitle: 'Confirmed',
        icon: Icons.check_circle_rounded,
        accent: Color(0xFF22C55E),
      ),
      _MeetingStatCard(
        title: 'Rejected',
        value: '0',
        subtitle: 'Declined',
        icon: Icons.close_rounded,
        accent: Color(0xFFF43F5E),
      ),
      _MeetingStatCard(
        title: 'Today',
        value: '0',
        subtitle: 'Scheduled today',
        icon: Icons.today_rounded,
        accent: Color(0xFF8B5CF6),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return SizedBox(
            height: 124,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => cards[index],
            ),
          );
        }

        return Wrap(spacing: 14, runSpacing: 14, children: cards);
      },
    );
  }
}

class _MeetingStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _MeetingStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingFilterRow extends StatelessWidget {
  const _MeetingFilterRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by title, requester, recipient...',
              filled: true,
              fillColor: theme.cardColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<String>(
            value: 'All Status',
            items: const [
              DropdownMenuItem(value: 'All Status', child: Text('All Status')),
              DropdownMenuItem(value: 'Approved', child: Text('Approved')),
              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
              DropdownMenuItem(value: 'Rejected', child: Text('Rejected')),
            ],
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.cardColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MeetingListSection extends StatelessWidget {
  const _MeetingListSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meeting List',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '6 meetings',
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
                    color: theme.colorScheme.primary.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '2 pending',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Meeting',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'From → To',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Date & Time',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                SizedBox(
                  width: 88,
                  child: Text(
                    'Type',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                SizedBox(
                  width: 88,
                  child: Text(
                    'Status',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                SizedBox(
                  width: 68,
                  child: Text(
                    '',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          const _MeetingListItem(
            title: 'kjhgfdg',
            subtitle: 'bhjvgcfdnjh',
            recipient: 'hr@hrm.com',
            date: 'Jul 25, 2026\n00:22 - 15:24',
            type: 'In Person',
            status: 'Approved',
          ),
          const Divider(height: 0),
          const _MeetingListItem(
            title: 'wwwwwww',
            subtitle: 'Perspiciatis placea',
            recipient: 'hr@hrm.com',
            date: 'Jul 11, 2026\n02:05 - 18:26',
            type: 'In Person',
            status: 'Approved',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MeetingListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String recipient;
  final String date;
  final String type;
  final String status;

  const _MeetingListItem({
    required this.title,
    required this.subtitle,
    required this.recipient,
    required this.date,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 700;
        const sectionSpacing = SizedBox(height: 10);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withAlpha(10),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.event_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sectionSpacing,
                      Text(
                        'Unknown',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '→ $recipient',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      sectionSpacing,
                      Text(date, style: AppTextStyles.bodyMedium),
                      sectionSpacing,
                      Row(
                        children: [
                          Chip(
                            backgroundColor: theme.colorScheme.surface,
                            label: Text(type, style: AppTextStyles.bodyMedium),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              status,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.event_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unknown',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '→ $recipient',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(date, style: AppTextStyles.bodyMedium),
                      ),
                      SizedBox(
                        width: 98,
                        child: Chip(
                          label: Text(type, style: AppTextStyles.bodyMedium),
                          backgroundColor: theme.colorScheme.surface,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          status,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 66,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('View'),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
