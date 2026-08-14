import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL & ENUMS
// =============================================================

enum AttendanceStatus { present, late, absent, onLeave }

class AttendanceRecord {
  final String id;
  final String employeeName;
  final String date;
  final String checkIn;
  final String checkOut;
  final String workingHours;
  AttendanceStatus status;

  AttendanceRecord({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.workingHours,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.onLeave:
        return 'On Leave';
    }
  }

  Color get statusColor {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;
      case AttendanceStatus.late:
        return const Color(0xFFF59E0B);
      case AttendanceStatus.absent:
        return AppColors.error;
      case AttendanceStatus.onLeave:
        return const Color(0xFF8B5CF6);
    }
  }
}

// =============================================================
// MAIN BODY (STATEFUL)
// =============================================================

class AttendanceViewBody extends StatefulWidget {
  const AttendanceViewBody({super.key});

  @override
  State<AttendanceViewBody> createState() => _AttendanceViewBodyState();
}

class _AttendanceViewBodyState extends State<AttendanceViewBody> {
  bool _isCheckedIn = false;
  String _todayCheckIn = '--:--';
  String _todayCheckOut = '--:--';
  String _todayWorkingHours = 'Not started';

  String _searchQuery = '';
  String _selectedStatusFilter = 'All Status';

  late List<AttendanceRecord> _records;

  @override
  void initState() {
    super.initState();
    _records = [
      AttendanceRecord(
        id: 'ATT-001',
        employeeName: 'Sarah Jenkins',
        date: 'Today (Aug 14, 2026)',
        checkIn: '08:55 AM',
        checkOut: '--:--',
        workingHours: 'In progress',
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'ATT-002',
        employeeName: 'Ali Khan',
        date: 'Today (Aug 14, 2026)',
        checkIn: '09:25 AM',
        checkOut: '--:--',
        workingHours: 'In progress',
        status: AttendanceStatus.late,
      ),
      AttendanceRecord(
        id: 'ATT-003',
        employeeName: 'Zubair Ahmed',
        date: 'Aug 13, 2026',
        checkIn: '09:00 AM',
        checkOut: '05:30 PM',
        workingHours: '8h 30m',
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'ATT-004',
        employeeName: 'Hamza Tariq',
        date: 'Aug 13, 2026',
        checkIn: '--:--',
        checkOut: '--:--',
        workingHours: '0h',
        status: AttendanceStatus.absent,
      ),
    ];
  }

  // --- STATS COMPUTATION ---
  int get _totalCount => _records.length;
  int get _presentCount => _records.where((r) => r.status == AttendanceStatus.present).length;
  int get _lateCount => _records.where((r) => r.status == AttendanceStatus.late).length;
  int get _absentCount => _records.where((r) => r.status == AttendanceStatus.absent).length;

  List<AttendanceRecord> get _filteredRecords {
    return _records.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = r.employeeName.toLowerCase().contains(q) ||
            r.date.toLowerCase().contains(q) ||
            r.statusText.toLowerCase().contains(q);
        if (!match) return false;
      }
      if (_selectedStatusFilter != 'All Status') {
        if (r.statusText != _selectedStatusFilter) return false;
      }
      return true;
    }).toList();
  }

  void _handleCheckIn() {
    if (_isCheckedIn) return;
    final now = TimeOfDay.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _isCheckedIn = true;
      _todayCheckIn = timeStr;
      _todayWorkingHours = 'In progress';

      _records.insert(
        0,
        AttendanceRecord(
          id: 'ATT-00${_records.length + 1}',
          employeeName: 'User (HR Manager)',
          date: 'Today (Aug 14, 2026)',
          checkIn: timeStr,
          checkOut: '--:--',
          workingHours: 'In progress',
          status: now.hour > 9 || (now.hour == 9 && now.minute > 15) ? AttendanceStatus.late : AttendanceStatus.present,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked In successfully at $timeStr!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleCheckOut() {
    if (!_isCheckedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Check In first!'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final now = TimeOfDay.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _isCheckedIn = false;
      _todayCheckOut = timeStr;
      _todayWorkingHours = '8h 00m (Completed)';

      final userRec = _records.firstWhere((r) => r.employeeName.startsWith('User'));
      userRec.status = AttendanceStatus.present;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked Out successfully at $timeStr!'),
        backgroundColor: themePrimaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color get themePrimaryColor => Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with Check In / Check Out actions
            _buildHeader(theme),
            const SizedBox(height: 12),

            // 2. Stats row
            _buildStatsRow(theme),
            const SizedBox(height: 12),

            // 3. Info bar
            _buildInfoBar(theme),
            const SizedBox(height: 14),

            // 4. Today's live attendance card
            _buildTodayCard(theme),
            const SizedBox(height: 14),

            // 5. Search & Filter
            _buildFilterSection(theme),
            const SizedBox(height: 14),

            // 6. Records history
            _buildHistorySection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Attendance', style: AppTextStyles.headlineMedium),
                  Text('8/2026', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isCheckedIn ? null : _handleCheckIn,
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: Text(_isCheckedIn ? 'Checked In' : 'Check In'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isCheckedIn ? _handleCheckOut : null,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Check Out'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attendance', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 2),
                  Text('8/2026', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _isCheckedIn ? null : _handleCheckIn,
              icon: const Icon(Icons.login_rounded, size: 18),
              label: Text(_isCheckedIn ? 'Checked In' : 'Check In'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _isCheckedIn ? _handleCheckOut : null,
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Check Out'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        final statList = [
          ('TOTAL LOGS', '$_totalCount', 'Attendance records', Icons.schedule_rounded, const Color(0xFF60A5FA)),
          ('PRESENT', '$_presentCount', 'On-time check-ins', Icons.check_circle_rounded, AppColors.success),
          ('LATE', '$_lateCount', 'Delayed arrivals', Icons.warning_amber_rounded, const Color(0xFFF59E0B)),
          ('ABSENT', '$_absentCount', 'Unexcused absences', Icons.cancel_rounded, AppColors.error),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s.$1,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: s.$5.withAlpha(24),
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
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s.$3,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_rounded, color: theme.colorScheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Biometric and mobile attendance syncing active',
              style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        border: Border.all(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fingerprint_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Today\'s Session', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text(
                      _isCheckedIn ? 'Currently working' : 'Not clocked in',
                      style: TextStyle(fontSize: 12, color: _isCheckedIn ? AppColors.success : theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isCheckedIn ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _isCheckedIn ? 'ACTIVE' : 'OFFLINE',
                  style: TextStyle(
                    color: _isCheckedIn ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHECK IN TIME', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(_todayCheckIn, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHECK OUT TIME', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(_todayCheckOut, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: theme.colorScheme.onSurface)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STATUS', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(_todayWorkingHours, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.success)),
                  ],
                ),
              ),
            ],
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
              Icon(Icons.filter_list_rounded, color: theme.colorScheme.primary, size: 18),
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
                    hintText: 'Search employee, date, or status...',
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
                      value: _selectedStatusFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.expand_more_rounded, size: 18),
                      items: const [
                        DropdownMenuItem(value: 'All Status', child: Text('All Status', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Present', child: Text('Present', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Late', child: Text('Late', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'Absent', child: Text('Absent', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedStatusFilter = v);
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

  Widget _buildHistorySection(ThemeData theme) {
    final list = _filteredRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Attendance History', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length} records',
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
            child: Text('No attendance records found', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final r = list[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.primary.withAlpha(20),
                      child: Text(
                        r.employeeName.isNotEmpty ? r.employeeName[0] : 'E',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('${r.date} • ${r.checkIn} → ${r.checkOut}', style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: r.statusColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        r.statusText,
                        style: TextStyle(color: r.statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
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
