import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL
// =============================================================

class DepartmentRecord {
  final String id;
  final String name;
  final String code;
  final String head;
  int employeeCount;
  final String location;
  final String budget;
  bool isActive;

  DepartmentRecord({
    required this.id,
    required this.name,
    required this.code,
    required this.head,
    required this.employeeCount,
    required this.location,
    required this.budget,
    this.isActive = true,
  });
}

// =============================================================
// MAIN BODY (STATEFUL)
// =============================================================

class DepartmentsViewBody extends StatefulWidget {
  const DepartmentsViewBody({super.key});

  @override
  State<DepartmentsViewBody> createState() => _DepartmentsViewBodyState();
}

class _DepartmentsViewBodyState extends State<DepartmentsViewBody> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';

  late List<DepartmentRecord> _departments;

  @override
  void initState() {
    super.initState();
    _departments = [
      DepartmentRecord(
        id: 'DEPT-001',
        name: 'Engineering',
        code: 'ENG',
        head: 'Sarah Jenkins',
        employeeCount: 3,
        location: 'Building A, Floor 3',
        budget: 'Rs. 4,500,000',
        isActive: true,
      ),
      DepartmentRecord(
        id: 'DEPT-002',
        name: 'Human Resources',
        code: 'HR',
        head: 'User (HR Manager)',
        employeeCount: 1,
        location: 'Building A, Floor 1',
        budget: 'Rs. 1,200,000',
        isActive: true,
      ),
      DepartmentRecord(
        id: 'DEPT-003',
        name: 'Design & Creative',
        code: 'DES',
        head: 'Ali Khan',
        employeeCount: 1,
        location: 'Building B, Floor 2',
        budget: 'Rs. 900,000',
        isActive: true,
      ),
      DepartmentRecord(
        id: 'DEPT-004',
        name: 'Finance & Accounts',
        code: 'FIN',
        head: 'Tariq Mehmood',
        employeeCount: 2,
        location: 'Building A, Floor 2',
        budget: 'Rs. 2,800,000',
        isActive: true,
      ),
    ];
  }

  // --- STATS ---
  int get _totalDepts => _departments.length;
  int get _activeDepts => _departments.where((d) => d.isActive).length;
  int get _totalStaff => _departments.fold(0, (sum, d) => sum + d.employeeCount);

  List<DepartmentRecord> get _filteredDepts {
    return _departments.where((d) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = d.name.toLowerCase().contains(q) ||
            d.code.toLowerCase().contains(q) ||
            d.head.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedStatusFilter == 'Active' && !d.isActive) return false;
      if (_selectedStatusFilter == 'Inactive' && d.isActive) return false;
      return true;
    }).toList();
  }

  // --- NEW DEPARTMENT MODAL ---
  void _openNewDepartmentDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final headCtrl = TextEditingController();
    final budgetCtrl = TextEditingController(text: 'Rs. 1,500,000');
    final locCtrl = TextEditingController(text: 'Building A, Floor 2');

    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
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
                          child: const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Create New Department',
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    _buildInput('DEPARTMENT NAME', nameCtrl, theme),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildInput('CODE (e.g. MKT)', codeCtrl, theme)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildInput('HEAD OF DEPT', headCtrl, theme)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInput('BUDGET ALLOCATION', budgetCtrl, theme),
                    const SizedBox(height: 12),
                    _buildInput('OFFICE LOCATION', locCtrl, theme),
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
                              _departments.add(
                                DepartmentRecord(
                                  id: 'DEPT-00${_departments.length + 1}',
                                  name: nameCtrl.text.trim(),
                                  code: codeCtrl.text.trim().isEmpty ? 'GEN' : codeCtrl.text.trim().toUpperCase(),
                                  head: headCtrl.text.trim().isEmpty ? 'Unassigned' : headCtrl.text.trim(),
                                  employeeCount: 0,
                                  location: locCtrl.text.trim(),
                                  budget: budgetCtrl.text.trim(),
                                  isActive: true,
                                ),
                              );
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${nameCtrl.text.trim()} department created!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('Create Department'),
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
  }

  void _showDepartmentDetails(DepartmentRecord dept) {
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.apartment_rounded, color: theme.colorScheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dept.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 17)),
                            Text('Code: ${dept.code}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  _buildDetailRow('Department ID', dept.id, theme),
                  _buildDetailRow('Head of Department', dept.head, theme),
                  _buildDetailRow('Staff Members', '${dept.employeeCount} employees', theme),
                  _buildDetailRow('Budget Allocated', dept.budget, theme),
                  _buildDetailRow('Office Location', dept.location, theme),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() => dept.isActive = !dept.isActive);
                          Navigator.pop(ctx);
                        },
                        icon: Icon(dept.isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded, size: 16),
                        label: Text(dept.isActive ? 'Deactivate' : 'Activate'),
                      ),
                      FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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

  Widget _buildInput(String label, TextEditingController ctrl, ThemeData theme) {
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
            // 1. Header with New Department action
            _buildHeader(theme),
            const SizedBox(height: 12),

            // 2. Stats
            _buildStatsRow(theme),
            const SizedBox(height: 12),

            // 3. Search & Filter
            _buildFilterSection(theme),
            const SizedBox(height: 14),

            // 4. Department Cards
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
              Text('Departments', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text('8/2026', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _openNewDepartmentDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('New Department'),
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
          ('TOTAL DEPTS', '$_totalDepts', 'All organizational units', Icons.apartment_rounded, const Color(0xFF60A5FA)),
          ('ACTIVE', '$_activeDepts', 'Operational units', Icons.check_circle_rounded, AppColors.success),
          ('TOTAL WORKFORCE', '$_totalStaff', 'Employees assigned', Icons.groups_rounded, const Color(0xFF8B5CF6)),
        ];

        if (isMobile) {
          return Row(
            children: statList
                .map((s) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _buildStatCard(s, theme),
                      ),
                    ))
                .toList(),
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
              fontSize: 10.5,
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search department name, code, or head...',
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
          Wrap(
            spacing: 6,
            children: ['All', 'Active'].map((f) {
              final isSel = _selectedStatusFilter == f;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _selectedStatusFilter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSel ? theme.colorScheme.primary : theme.dividerColor.withAlpha(80),
                    ),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? Colors.white : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(ThemeData theme) {
    final list = _filteredDepts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.apartment_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Department List', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length} units',
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Text('No departments match this filter', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final d = list[index];
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
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              d.code,
                              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('Head: ${d.head} • Staff: ${d.employeeCount}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: d.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            d.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: d.isActive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
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
                        Text('Budget: ${d.budget}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showDepartmentDetails(d),
                              icon: const Icon(Icons.info_outline_rounded, size: 14),
                              label: const Text('Details', style: TextStyle(fontSize: 11.5)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () {
                                setState(() => _departments.removeWhere((item) => item.id == d.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${d.name} deleted!'), behavior: SnackBarBehavior.floating),
                                );
                              },
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                              tooltip: 'Delete',
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
