import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class EmployeesViewBody extends StatelessWidget {
  const EmployeesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _EmployeesHeader(),
            SizedBox(height: 22),
            _StatsRow(),
            SizedBox(height: 12),
            _FiltersRow(),
            SizedBox(height: 12),
            _SearchBar(),
            SizedBox(height: 22),
            _EmployeeListSection(),
          ],
        ),
      ),
    );
  }
}

class _EmployeesHeader extends StatelessWidget {
  const _EmployeesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Employees', style: AppTextStyles.headlineMedium),
              SizedBox(height: 6),
              Text(
                'HR adds employees and assigns their login password. Employees sign in on the common login page with email + assigned password.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Employee'),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: StatCard(
                title: 'Total Employees',
                value: '9',
                icon: Icons.group_rounded,
                accentColor: Color(0xFF60A5FA),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Active',
                value: '9',
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
                title: 'On Leave',
                value: '0',
                icon: Icons.beach_access_rounded,
                accentColor: Color(0xFFF59E0B),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Terminated',
                value: '0',
                icon: Icons.person_off_rounded,
                accentColor: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: const [
        _FilterChip(label: 'All', selected: true),
        _FilterChip(label: 'Active'),
        _FilterChip(label: 'Inactive'),
        _FilterChip(label: 'Terminated'),
        _FilterChip(label: 'On Leave'),
        _FilterChip(label: 'Employees'),
        _FilterChip(label: 'Managers'),
        _FilterChip(label: 'Assistant Managers'),
        _FilterChip(label: 'Team Leaders'),
        _FilterChip(label: 'Interns'),
        _FilterChip(label: 'Office Boys'),
        _FilterChip(label: 'Guards'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.surface,
      side: selected ? null : BorderSide(color: theme.dividerColor),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by name, email, ID, or skills...',
        suffixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _EmployeeListSection extends StatelessWidget {
  const _EmployeeListSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Employee List', style: AppTextStyles.titleMedium),
        const SizedBox(height: 14),
        Column(
          children: employees
              .map(
                (employee) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: EmployeeCard(employee: employee),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeInfo employee;

  const EmployeeCard({super.key, required this.employee});

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
            color: theme.shadowColor.withAlpha(18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withAlpha(31),
                child: Text(
                  employee.initials,
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
                      employee.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          label: employee.role,
                          color: theme.colorScheme.secondaryContainer,
                          textColor: theme.colorScheme.onSecondaryContainer,
                        ),
                        _InfoChip(
                          label: employee.department,
                          color: theme.colorScheme.primary.withAlpha(20),
                          textColor: theme.colorScheme.primary,
                        ),
                        _InfoChip(
                          label: employee.status,
                          color: AppColors.success.withAlpha(31),
                          textColor: AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                label: 'View',
                color: theme.colorScheme.primary,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _ActionButton(
                label: 'Edit',
                color: const Color(0xFFF59E0B),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class EmployeeInfo {
  final String initials;
  final String name;
  final String email;
  final String role;
  final String department;
  final String status;

  const EmployeeInfo({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.status,
  });
}

const employees = [
  EmployeeInfo(
    initials: 'MW',
    name: 'mahnoor Wholcure',
    email: 'wholcurehjkljkl@gmail.com',
    role: 'Intern',
    department: 'Real Estate',
    status: 'Active',
  ),
  EmployeeInfo(
    initials: 'MW',
    name: 'mahnoor Wholcure',
    email: 'wholcurekjklj@gmail.com',
    role: 'Intern',
    department: 'Marketing',
    status: 'Active',
  ),
  EmployeeInfo(
    initials: 'AW',
    name: 'alia Wholcure',
    email: 'abdj@gmail.com',
    role: 'Intern',
    department: 'WholCure Technology',
    status: 'Active',
  ),
  EmployeeInfo(
    initials: 'AW',
    name: 'alia Wholcure',
    email: 'abd@gmail.com',
    role: 'Intern',
    department: 'WholCure Technology',
    status: 'Active',
  ),
  EmployeeInfo(
    initials: 'SA',
    name: 'sss anwar',
    email: 'mkj1234@gmail.com',
    role: 'Employee',
    department: 'WholCure Technology',
    status: 'Active',
  ),
];
