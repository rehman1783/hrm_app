import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL
// =============================================================

class EmployeeInfo {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final String phone;
  final String shift;
  final String joinDate;
  bool isActive;
  final String category; // 'Interns', 'Employees', 'Managers'

  EmployeeInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.phone,
    required this.shift,
    required this.joinDate,
    this.isActive = true,
    required this.category,
  });

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : 'E';
}

// =============================================================
// MAIN BODY (STATEFUL)
// =============================================================

class EmployeesViewBody extends StatefulWidget {
  const EmployeesViewBody({super.key});

  @override
  State<EmployeesViewBody> createState() => _EmployeesViewBodyState();
}

class _EmployeesViewBodyState extends State<EmployeesViewBody> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDeptFilter = 'All Departments';

  late List<EmployeeInfo> _employees;

  @override
  void initState() {
    super.initState();
    _employees = [
      EmployeeInfo(
        id: 'EMP-001',
        name: 'User (HR Manager)',
        email: 'hr@hrm.com',
        role: 'HR Manager',
        department: 'Human Resources',
        phone: '+92 300 1234567',
        shift: 'Morning (09:00 - 17:00)',
        joinDate: 'Jan 15, 2024',
        isActive: true,
        category: 'Managers',
      ),
      EmployeeInfo(
        id: 'EMP-002',
        name: 'Sarah Jenkins',
        email: 'sarah.j@company.com',
        role: 'Lead Flutter Developer',
        department: 'Engineering',
        phone: '+92 312 9876543',
        shift: 'Morning (09:00 - 17:00)',
        joinDate: 'Feb 01, 2024',
        isActive: true,
        category: 'Employees',
      ),
      EmployeeInfo(
        id: 'EMP-003',
        name: 'Ali Khan',
        email: 'ali.design@company.com',
        role: 'Senior UI/UX Designer',
        department: 'Design',
        phone: '+92 333 4567890',
        shift: 'Morning (09:00 - 17:00)',
        joinDate: 'Mar 10, 2024',
        isActive: true,
        category: 'Employees',
      ),
      EmployeeInfo(
        id: 'EMP-004',
        name: 'Zubair Ahmed',
        email: 'zubair.qa@company.com',
        role: 'QA Engineer',
        department: 'Engineering',
        phone: '+92 345 6789012',
        shift: 'Evening (13:00 - 21:00)',
        joinDate: 'Apr 05, 2024',
        isActive: true,
        category: 'Employees',
      ),
      EmployeeInfo(
        id: 'EMP-005',
        name: 'Hamza Tariq',
        email: 'hamza.intern@company.com',
        role: 'Flutter Intern',
        department: 'Engineering',
        phone: '+92 301 2345678',
        shift: 'Morning (09:00 - 17:00)',
        joinDate: 'Jul 01, 2024',
        isActive: true,
        category: 'Interns',
      ),
    ];
  }

  // --- STATS ---
  int get _totalCount => _employees.length;
  int get _activeCount => _employees.where((e) => e.isActive).length;
  int get _onLeaveCount => _employees.where((e) => !e.isActive).length;
  int get _internCount => _employees.where((e) => e.category == 'Interns').length;

  List<EmployeeInfo> get _filteredEmployees {
    return _employees.where((e) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = e.name.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q) ||
            e.role.toLowerCase().contains(q) ||
            e.department.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedDeptFilter != 'All Departments' && e.department != _selectedDeptFilter) {
        return false;
      }
      if (_selectedCategory == 'Active' && !e.isActive) return false;
      if (_selectedCategory == 'On Leave' && e.isActive) return false;
      if (_selectedCategory == 'Interns' && e.category != 'Interns') return false;
      if (_selectedCategory == 'Employees' && e.category != 'Employees') return false;
      if (_selectedCategory == 'Managers' && e.category != 'Managers') return false;

      return true;
    }).toList();
  }

  // --- ADD EMPLOYEE DIALOG ---
  void _openAddEmployeeDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String dept = 'Engineering';
    String category = 'Employees';

    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person_add_rounded, color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Add New Employee',
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        _buildInput('FULL NAME', nameCtrl, theme),
                        const SizedBox(height: 12),
                        _buildInput('WORK EMAIL', emailCtrl, theme, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: _buildInput('JOB TITLE / ROLE', roleCtrl, theme)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DEPARTMENT',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: theme.dividerColor.withAlpha(80)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: dept,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
                                          DropdownMenuItem(value: 'Human Resources', child: Text('Human Resources')),
                                          DropdownMenuItem(value: 'Design', child: Text('Design')),
                                          DropdownMenuItem(value: 'Finance', child: Text('Finance')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) setModalState(() => dept = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: _buildInput('PHONE NUMBER', phoneCtrl, theme, keyboardType: TextInputType.phone)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CATEGORY',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: theme.dividerColor.withAlpha(80)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: category,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(value: 'Employees', child: Text('Employees')),
                                          DropdownMenuItem(value: 'Managers', child: Text('Managers')),
                                          DropdownMenuItem(value: 'Interns', child: Text('Interns')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) setModalState(() => category = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () {
                                if (nameCtrl.text.trim().isEmpty) return;
                                setState(() {
                                  _employees.add(
                                    EmployeeInfo(
                                      id: 'EMP-00${_employees.length + 1}',
                                      name: nameCtrl.text.trim(),
                                      email: emailCtrl.text.trim().isEmpty ? 'employee@hrm.com' : emailCtrl.text.trim(),
                                      role: roleCtrl.text.trim().isEmpty ? 'Software Staff' : roleCtrl.text.trim(),
                                      department: dept,
                                      phone: phoneCtrl.text.trim().isEmpty ? '+92 300 0000000' : phoneCtrl.text.trim(),
                                      shift: 'Morning (09:00 - 17:00)',
                                      joinDate: 'Today',
                                      isActive: true,
                                      category: category,
                                    ),
                                  );
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${nameCtrl.text.trim()} added successfully!'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Add Employee'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmployeeDetails(EmployeeInfo emp) {
    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary.withAlpha(25),
                        child: Text(
                          emp.initials,
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(emp.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 17)),
                            Text(emp.role, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: emp.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          emp.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: emp.isActive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  _buildDetailRow('Employee ID', emp.id, theme),
                  _buildDetailRow('Work Email', emp.email, theme),
                  _buildDetailRow('Department', emp.department, theme),
                  _buildDetailRow('Phone Number', emp.phone, theme),
                  _buildDetailRow('Work Shift', emp.shift, theme),
                  _buildDetailRow('Joining Date', emp.joinDate, theme),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() => emp.isActive = !emp.isActive);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${emp.name} status updated to ${emp.isActive ? "Active" : "Inactive"}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(emp.isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded, size: 16),
                        label: Text(emp.isActive ? 'Set Inactive' : 'Set Active'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, ThemeData theme, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor.withAlpha(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
          Text(value, style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with Add Employee action
            _buildHeader(theme),
            const SizedBox(height: 12),

            // 2. Stats
            _buildStatsRow(theme),
            const SizedBox(height: 12),

            // 3. Filter Section
            _buildFilterSection(theme),
            const SizedBox(height: 14),

            // 4. Employee Records
            _buildRecordsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Employees', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text(
                '8/2026',
                style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _openAddEmployeeDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Employee'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final statList = [
          ('TOTAL EMPLOYEES', '$_totalCount', 'All team members', Icons.group_rounded, const Color(0xFF60A5FA)),
          ('ACTIVE', '$_activeCount', 'Working active', Icons.check_circle_rounded, AppColors.success),
          ('ON LEAVE', '$_onLeaveCount', 'Away / inactive', Icons.beach_access_rounded, const Color(0xFFF59E0B)),
          ('INTERNS', '$_internCount', 'Trainees enrolled', Icons.school_rounded, const Color(0xFF8B5CF6)),
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard(statList[0], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCard(statList[1], theme)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildStatCard(statList[2], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCard(statList[3], theme)),
                ],
              ),
            ],
          );
        }

        return Row(
          children: statList
              .map((s) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildStatCard(s, theme),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildStatCard((String, String, String, IconData, Color) s, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.$1,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: s.$5.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(s.$4, color: s.$5, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.$2,
            style: AppTextStyles.headlineMedium.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s.$3,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              const Text('Search & Filter', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search name, email, or role...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor.withAlpha(60)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withAlpha(60)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDeptFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.expand_more_rounded, size: 18),
                      items: const [
                        DropdownMenuItem(value: 'All Departments', child: Text('All Depts', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Engineering', child: Text('Engineering', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Human Resources', child: Text('HR', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Design', child: Text('Design', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedDeptFilter = v);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(ThemeData theme) {
    final list = _filteredEmployees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Employee Records', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length} entries',
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Filter chips row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Active', 'On Leave', 'Interns', 'Employees', 'Managers'].map((cat) {
              final isSel = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? theme.colorScheme.primary : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? theme.colorScheme.primary : theme.dividerColor.withAlpha(80),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? Colors.white : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Text('No employees match this filter', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final emp = list[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha(10),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
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
                          backgroundColor: theme.colorScheme.primary.withAlpha(25),
                          child: Text(
                            emp.initials,
                            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('${emp.role} • ${emp.department}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: emp.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            emp.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: emp.isActive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone: ${emp.phone}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showEmployeeDetails(emp),
                              icon: const Icon(Icons.badge_outlined, size: 14),
                              label: const Text('Details', style: TextStyle(fontSize: 11.5)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () {
                                setState(() => _employees.removeWhere((e) => e.id == emp.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${emp.name} removed!'), behavior: SnackBarBehavior.floating),
                                );
                              },
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                              tooltip: 'Remove',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
