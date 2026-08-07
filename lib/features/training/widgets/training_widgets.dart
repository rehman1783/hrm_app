import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TrainingViewBody extends StatefulWidget {
  const TrainingViewBody({super.key});

  @override
  State<TrainingViewBody> createState() => _TrainingViewBodyState();
}

class _TrainingViewBodyState extends State<TrainingViewBody> {
  String _selectedStatus = 'All Statuses';
  String _selectedMode = 'All Modes';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TrainingHeader(),
            const SizedBox(height: 12),
            const _StatsRow(),
            const SizedBox(height: 14),
            _FilterSection(
              selectedStatus: _selectedStatus,
              selectedMode: _selectedMode,
              onStatusChanged: (value) =>
                  setState(() => _selectedStatus = value),
              onModeChanged: (value) => setState(() => _selectedMode = value),
            ),
            const SizedBox(height: 14),
            const _TrainingProgramsList(),
          ],
        ),
      ),
    );
  }
}

class _TrainingHeader extends StatelessWidget {
  const _TrainingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Training', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text(
                'Manage employee training programs and enrollments',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Create Training'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            'TOTAL PROGRAMS',
            '2',
            'All trainings',
            Icons.school_rounded,
            Color(0xFF60A5FA),
          ),
          (
            'ONGOING',
            '0',
            'Active programs',
            Icons.play_circle_rounded,
            Color(0xFF34D399),
          ),
          (
            'SCHEDULED',
            '2',
            'Upcoming',
            Icons.event_rounded,
            Color(0xFFF59E0B),
          ),
          (
            'MANDATORY',
            '1',
            'Required trainings',
            Icons.star_rounded,
            Color(0xFF8B5CF6),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String selectedStatus;
  final String selectedMode;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onModeChanged;

  const _FilterSection({
    required this.selectedStatus,
    required this.selectedMode,
    required this.onStatusChanged,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        if (isMobile) {
          return Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by title, trainer...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _FilterDropdown(
                      label: selectedStatus,
                      options: const [
                        'All Statuses',
                        'Scheduled',
                        'Ongoing',
                        'Completed',
                      ],
                      onChanged: onStatusChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterDropdown(
                      label: selectedMode,
                      options: const [
                        'All Modes',
                        'Online',
                        'Hybrid',
                        'Offline',
                      ],
                      onChanged: onModeChanged,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Icon(
              Icons.tune_rounded,
              color: theme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text('FILTER:', style: AppTextStyles.labelMedium),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by title, trainer...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _FilterDropdown(
              label: selectedStatus,
              options: const [
                'All Statuses',
                'Scheduled',
                'Ongoing',
                'Completed',
              ],
              onChanged: onStatusChanged,
            ),
            const SizedBox(width: 8),
            _FilterDropdown(
              label: selectedMode,
              options: const ['All Modes', 'Online', 'Hybrid', 'Offline'],
              onChanged: onModeChanged,
            ),
          ],
        );
      },
    );
  }
}

class _FilterDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.options,
    required this.onChanged,
  });

  @override
  State<_FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<_FilterDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: DropdownButton<String>(
        value: _selectedValue,
        underline: const SizedBox(),
        items: widget.options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option, style: AppTextStyles.bodyMedium),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedValue = value);
            widget.onChanged(value);
          }
        },
      ),
    );
  }
}

class _TrainingProgramsList extends StatelessWidget {
  const _TrainingProgramsList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.library_books_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Training Programs', style: AppTextStyles.titleMedium),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '2 programs',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '0 ongoing',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              return Column(
                children: trainingPrograms
                    .map(
                      (program) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TrainingProgramCard(program: program),
                      ),
                    )
                    .toList(),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withAlpha(12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(
                      label: Text('PROGRAM', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('TRAINER', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('TYPE', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('SCHEDULE', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('MODE', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('STATUS', style: AppTextStyles.labelMedium),
                    ),
                    DataColumn(
                      label: Text('ACTION', style: AppTextStyles.labelMedium),
                    ),
                  ],
                  rows: trainingPrograms
                      .map(
                        (program) => DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: program.color.withAlpha(
                                      31,
                                    ),
                                    child: Icon(
                                      Icons.school_rounded,
                                      color: program.color,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        program.name,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        program.code,
                                        style: AppTextStyles.labelMedium
                                            .copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    program.trainer,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    program.trainerEmail,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: program.typeColor.withAlpha(24),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  program.type,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: program.typeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                program.schedule,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: program.modeColor.withAlpha(24),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      program.modeIcon,
                                      size: 14,
                                      color: program.modeColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      program.mode,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: program.modeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: program.statusColor.withAlpha(24),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 14,
                                      color: program.statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      program.status,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: program.statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'View',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TrainingProgramCard extends StatelessWidget {
  final TrainingProgram program;

  const TrainingProgramCard({super.key, required this.program});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: program.color.withAlpha(31),
                child: Icon(
                  Icons.school_rounded,
                  color: program.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      program.code,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Trainer',
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            program.trainer,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            program.trainerEmail,
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: program.typeColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  program.type,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: program.typeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: program.modeColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(program.modeIcon, size: 14, color: program.modeColor),
                    const SizedBox(width: 4),
                    Text(
                      program.mode,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: program.modeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: program.statusColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: program.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      program.status,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: program.statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Schedule: ${program.schedule}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingProgram {
  final String name;
  final String code;
  final String trainer;
  final String trainerEmail;
  final String type;
  final String schedule;
  final String mode;
  final String status;
  final Color color;
  final Color typeColor;
  final Color modeColor;
  final IconData modeIcon;
  final Color statusColor;

  const TrainingProgram({
    required this.name,
    required this.code,
    required this.trainer,
    required this.trainerEmail,
    required this.type,
    required this.schedule,
    required this.mode,
    required this.status,
    required this.color,
    required this.typeColor,
    required this.modeColor,
    required this.modeIcon,
    required this.statusColor,
  });
}

const trainingPrograms = [
  TrainingProgram(
    name: 'fgdfg',
    code: 'fgdfgfgdfg',
    trainer: 'fgdfgfgdfg',
    trainerEmail: 'mahnoorgsa@gmail.com',
    type: 'Onboarding',
    schedule: 'Jul 11, 2026',
    mode: 'Online',
    status: 'Scheduled',
    color: Color(0xFF60A5FA),
    typeColor: Color(0xFF34D399),
    modeColor: Color(0xFF8B5CF6),
    modeIcon: Icons.cloud_rounded,
    statusColor: Color(0xFF60A5FA),
  ),
  TrainingProgram(
    name: 'HTML',
    code: 'arestdyktulgi:hojpkoi',
    trainer: 'Hassan',
    trainerEmail: 'hassan@gmail.com',
    type: 'Soft Skills',
    schedule: 'Jul 05, 2026',
    mode: 'Hybrid',
    status: 'Scheduled',
    color: Color(0xFF60A5FA),
    typeColor: Color(0xFF8B5CF6),
    modeColor: Color(0xFFF59E0B),
    modeIcon: Icons.link_rounded,
    statusColor: Color(0xFF60A5FA),
  ),
];
