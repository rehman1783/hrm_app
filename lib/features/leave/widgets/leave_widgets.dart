import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL & ENUMS
// =============================================================

enum LeaveRequestStatus { pending, approved, rejected }

class LeaveRequestItem {
  final String id;
  final String employeeName;
  final String employeeId;
  final String leaveType;
  final String duration;
  final String days;
  LeaveRequestStatus status;
  final String reason;

  LeaveRequestItem({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.leaveType,
    required this.duration,
    required this.days,
    required this.status,
    this.reason = '',
  });

  String get statusText {
    switch (status) {
      case LeaveRequestStatus.pending:
        return 'Pending';
      case LeaveRequestStatus.approved:
        return 'Approved';
      case LeaveRequestStatus.rejected:
        return 'Rejected';
    }
  }

  Color get statusColor {
    switch (status) {
      case LeaveRequestStatus.pending:
        return const Color(0xFFF59E0B);
      case LeaveRequestStatus.approved:
        return AppColors.success;
      case LeaveRequestStatus.rejected:
        return AppColors.error;
    }
  }
}

// =============================================================
// MAIN BODY WIDGET (STATEFUL)
// =============================================================

class LeaveViewBody extends StatefulWidget {
  const LeaveViewBody({super.key});

  @override
  State<LeaveViewBody> createState() => _LeaveViewBodyState();
}

class _LeaveViewBodyState extends State<LeaveViewBody> {
  String _selectedFilter = 'All';

  late List<LeaveRequestItem> _leaveRequests;

  @override
  void initState() {
    super.initState();
    _leaveRequests = [
      LeaveRequestItem(
        id: 'LV-001',
        employeeName: 'Mahnoor Anwar',
        employeeId: 'EP-093',
        leaveType: 'Annual Leave',
        duration: 'Jul 23 → Jul 30',
        days: '8d',
        status: LeaveRequestStatus.rejected,
        reason: 'Family event and vacation',
      ),
      LeaveRequestItem(
        id: 'LV-002',
        employeeName: 'Hassan Khan',
        employeeId: 'EP-104',
        leaveType: 'General Leave',
        duration: 'Jun 11 → Jun 12',
        days: '2d',
        status: LeaveRequestStatus.approved,
        reason: 'Personal errands',
      ),
      LeaveRequestItem(
        id: 'LV-003',
        employeeName: 'Zainab Bibi',
        employeeId: 'EP-112',
        leaveType: 'Sick Leave',
        duration: 'Aug 14 → Aug 16',
        days: '3d',
        status: LeaveRequestStatus.pending,
        reason: 'Medical recovery',
      ),
    ];
  }

  // --- STATS ---
  int get _totalCount => _leaveRequests.length;
  int get _pendingCount => _leaveRequests.where((i) => i.status == LeaveRequestStatus.pending).length;
  int get _approvedCount => _leaveRequests.where((i) => i.status == LeaveRequestStatus.approved).length;
  int get _rejectedCount => _leaveRequests.where((i) => i.status == LeaveRequestStatus.rejected).length;

  List<LeaveRequestItem> get _filteredRequests {
    return _leaveRequests.where((item) {
      if (_selectedFilter == 'Pending' && item.status != LeaveRequestStatus.pending) return false;
      if (_selectedFilter == 'Approved' && item.status != LeaveRequestStatus.approved) return false;
      if (_selectedFilter == 'Rejected' && item.status != LeaveRequestStatus.rejected) return false;
      return true;
    }).toList();
  }

  // --- APPLY LEAVE MODAL ---
  void _openApplyLeaveDialog() {
    final nameController = TextEditingController(text: 'User (HR Manager)');
    final reasonController = TextEditingController();
    String leaveType = 'Annual Leave';
    int days = 3;

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
                                color: AppColors.success.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.beach_access_rounded, color: AppColors.success, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Apply for Leave',
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Employee Name
                        _buildFormField(label: 'EMPLOYEE NAME', controller: nameController, theme: theme),
                        const SizedBox(height: 12),

                        // Leave Type Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEAVE TYPE',
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
                                  value: leaveType,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'Annual Leave', child: Text('Annual Leave')),
                                    DropdownMenuItem(value: 'Casual Leave', child: Text('Casual Leave')),
                                    DropdownMenuItem(value: 'Sick Leave', child: Text('Sick Leave')),
                                    DropdownMenuItem(value: 'Maternity Leave', child: Text('Maternity Leave')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => leaveType = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Days count slider / stepper
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('DURATION (DAYS):', style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: days > 1 ? () => setModalState(() => days--) : null,
                                  icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                                ),
                                Text('$days days', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                                IconButton(
                                  onPressed: () => setModalState(() => days++),
                                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Reason
                        _buildFormField(label: 'REASON / NOTE', controller: reasonController, maxLines: 2, theme: theme),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () {
                                setState(() {
                                  _leaveRequests.insert(
                                    0,
                                    LeaveRequestItem(
                                      id: 'LV-00${_leaveRequests.length + 1}',
                                      employeeName: nameController.text.trim().isEmpty ? 'Employee' : nameController.text.trim(),
                                      employeeId: 'EP-0${100 + _leaveRequests.length}',
                                      leaveType: leaveType,
                                      duration: 'Upcoming ($days d)',
                                      days: '${days}d',
                                      status: LeaveRequestStatus.pending,
                                      reason: reasonController.text.trim(),
                                    ),
                                  );
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Leave application submitted successfully!'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.send_rounded, size: 16),
                              label: const Text('Submit Application'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.success,
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    int maxLines = 1,
  }) {
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
          controller: controller,
          maxLines: maxLines,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            _buildHeader(theme),
            const SizedBox(height: 12),

            // 2. Summary
            _buildSummaryRow(theme),
            const SizedBox(height: 14),

            // 3. Requests list
            _buildRequestsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.beach_access_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Leave Tracker', style: AppTextStyles.headlineMedium.copyWith(fontSize: 20)),
                    const SizedBox(width: 6),
                    Text(
                      '($_totalCount)',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage employee leave requests and approvals',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: _openApplyLeaveDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Apply for Leave'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final statList = [
          ('Total Requests', '$_totalCount', 'All requests', Icons.person_rounded, const Color(0xFF60A5FA)),
          ('Pending', '$_pendingCount', 'Awaiting HR', Icons.schedule_rounded, const Color(0xFFFACC15)),
          ('Approved', '$_approvedCount', 'Leave granted', Icons.check_circle_rounded, const Color(0xFF4ADE80)),
          ('Rejected', '$_rejectedCount', 'Leave denied', Icons.close_rounded, const Color(0xFFF87272)),
        ];

        final isMobile = constraints.maxWidth < 500;

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(statList[0], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildSummaryCard(statList[1], theme)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(statList[2], theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildSummaryCard(statList[3], theme)),
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
                      child: _buildSummaryCard(s, theme),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildSummaryCard((String, String, String, IconData, Color) s, ThemeData theme) {
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
                  s.$1.toUpperCase(),
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
              fontSize: 17,
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

  Widget _buildRequestsSection(ThemeData theme) {
    final list = _filteredRequests;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Leave Applications', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),

                // Filter Chips
                Wrap(
                  spacing: 6,
                  children: ['All', 'Pending', 'Approved', 'Rejected'].map((f) {
                    final isSel = _selectedFilter == f;
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _selectedFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
                            fontSize: 11,
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
          ),
          const Divider(height: 1),

          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.info_outline_rounded, color: theme.colorScheme.onSurfaceVariant, size: 28),
                    const SizedBox(height: 8),
                    Text('No leave requests match this filter', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = list[index];
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primary.withAlpha(25),
                            child: Text(
                              item.employeeName.isNotEmpty ? item.employeeName[0] : 'E',
                              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                                const SizedBox(height: 2),
                                Text('${item.employeeId} • ${item.leaveType}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.statusColor.withAlpha(24),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.statusText,
                              style: TextStyle(color: item.statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.date_range_rounded, size: 15, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(item.duration, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(item.days, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11)),
                          ),
                        ],
                      ),
                      if (item.reason.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text('Note: ${item.reason}', style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: theme.colorScheme.onSurfaceVariant)),
                      ],

                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (item.status == LeaveRequestStatus.pending) ...[
                            FilledButton.icon(
                              onPressed: () {
                                setState(() => item.status = LeaveRequestStatus.approved);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Leave for ${item.employeeName} approved!'), backgroundColor: AppColors.success),
                                );
                              },
                              icon: const Icon(Icons.check_rounded, size: 14),
                              label: const Text('Approve', style: TextStyle(fontSize: 11.5)),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() => item.status = LeaveRequestStatus.rejected);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Leave for ${item.employeeName} rejected!'), backgroundColor: AppColors.error),
                                );
                              },
                              icon: const Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                              label: const Text('Reject', style: TextStyle(fontSize: 11.5, color: AppColors.error)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.error),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          IconButton(
                            onPressed: () {
                              setState(() => _leaveRequests.removeWhere((l) => l.id == item.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Leave record removed!'), behavior: SnackBarBehavior.floating),
                              );
                            },
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
