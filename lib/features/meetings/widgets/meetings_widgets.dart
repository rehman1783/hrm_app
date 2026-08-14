import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL
// =============================================================

enum MeetingStatus { pending, approved, completed, cancelled }

class MeetingItem {
  final String id;
  final String title;
  final String date;
  final String time;
  final String host;
  final String department;
  final String platform; // 'Google Meet', 'Zoom', 'In-Person Room A'
  MeetingStatus status;
  final int participants;

  MeetingItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.host,
    required this.department,
    required this.platform,
    required this.status,
    required this.participants,
  });

  String get statusText {
    switch (status) {
      case MeetingStatus.pending:
        return 'Pending';
      case MeetingStatus.approved:
        return 'Approved';
      case MeetingStatus.completed:
        return 'Completed';
      case MeetingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case MeetingStatus.pending:
        return const Color(0xFFF59E0B);
      case MeetingStatus.approved:
        return AppColors.success;
      case MeetingStatus.completed:
        return const Color(0xFF64748B);
      case MeetingStatus.cancelled:
        return AppColors.error;
    }
  }
}

// =============================================================
// MAIN BODY (STATEFUL)
// =============================================================

class MeetingsViewBody extends StatefulWidget {
  const MeetingsViewBody({super.key});

  @override
  State<MeetingsViewBody> createState() => _MeetingsViewBodyState();
}

class _MeetingsViewBodyState extends State<MeetingsViewBody> {
  String _selectedStatusFilter = 'All';

  late List<MeetingItem> _meetings;

  @override
  void initState() {
    super.initState();
    _meetings = [
      MeetingItem(
        id: 'MTG-001',
        title: 'Weekly Engineering Sprint Sync',
        date: 'Today (Aug 14, 2026)',
        time: '03:00 PM - 04:00 PM',
        host: 'Sarah Jenkins',
        department: 'Engineering',
        platform: 'Google Meet',
        status: MeetingStatus.approved,
        participants: 6,
      ),
      MeetingItem(
        id: 'MTG-002',
        title: 'Q3 Performance Review & HR Alignment',
        date: 'Aug 18, 2026',
        time: '11:00 AM - 12:00 PM',
        host: 'User (HR Manager)',
        department: 'Human Resources',
        platform: 'Conference Room 1',
        status: MeetingStatus.pending,
        participants: 4,
      ),
      MeetingItem(
        id: 'MTG-003',
        title: 'Design Critique & Figma Walkthrough',
        date: 'Aug 19, 2026',
        time: '02:00 PM - 03:00 PM',
        host: 'Ali Khan',
        department: 'Design',
        platform: 'Zoom',
        status: MeetingStatus.approved,
        participants: 5,
      ),
    ];
  }

  // --- STATS ---
  int get _totalCount => _meetings.length;
  int get _approvedCount => _meetings.where((m) => m.status == MeetingStatus.approved).length;
  int get _pendingCount => _meetings.where((m) => m.status == MeetingStatus.pending).length;
  int get _todayCount => _meetings.where((m) => m.date.contains('Today')).length;

  List<MeetingItem> get _filteredMeetings {
    return _meetings.where((m) {
      if (_selectedStatusFilter == 'Approved' && m.status != MeetingStatus.approved) return false;
      if (_selectedStatusFilter == 'Pending' && m.status != MeetingStatus.pending) return false;
      return true;
    }).toList();
  }

  // --- REQUEST MEETING DIALOG ---
  void _openRequestMeetingDialog() {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: 'Aug 21, 2026');
    final timeCtrl = TextEditingController(text: '02:30 PM - 03:30 PM');
    String platform = 'Google Meet';
    String dept = 'Engineering';

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
                                color: const Color(0xFF06B6D4).withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.video_camera_front_rounded, color: Color(0xFF06B6D4), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Request Meeting',
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        _buildInput('MEETING TITLE', titleCtrl, theme),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildInput('DATE', dateCtrl, theme)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildInput('TIME', timeCtrl, theme)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('PLATFORM / ROOM', style: AppTextStyles.labelMedium.copyWith(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: theme.dividerColor.withAlpha(80)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: platform,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(value: 'Google Meet', child: Text('Google Meet')),
                                          DropdownMenuItem(value: 'Zoom', child: Text('Zoom')),
                                          DropdownMenuItem(value: 'Conference Room 1', child: Text('In-Person Room 1')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) setModalState(() => platform = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DEPARTMENT', style: AppTextStyles.labelMedium.copyWith(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () {
                                if (titleCtrl.text.trim().isEmpty) return;
                                setState(() {
                                  _meetings.add(
                                    MeetingItem(
                                      id: 'MTG-00${_meetings.length + 1}',
                                      title: titleCtrl.text.trim(),
                                      date: dateCtrl.text.trim(),
                                      time: timeCtrl.text.trim(),
                                      host: 'User (HR Manager)',
                                      department: dept,
                                      platform: platform,
                                      status: MeetingStatus.pending,
                                      participants: 3,
                                    ),
                                  );
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Meeting "${titleCtrl.text.trim()}" scheduled!'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Schedule Meeting'),
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

  Widget _buildInput(String label, TextEditingController ctrl, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600, fontSize: 11)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor.withAlpha(80))),
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
            _buildHeader(theme),
            const SizedBox(height: 12),
            _buildStatsRow(theme),
            const SizedBox(height: 12),
            _buildUpcomingSpotlight(theme),
            const SizedBox(height: 14),
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
              Text('Meetings', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text('8/2026', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _openRequestMeetingDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Request Meeting'),
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
        final statList = [
          ('TOTAL MEETINGS', '$_totalCount', 'All scheduled', Icons.calendar_today_rounded, const Color(0xFF60A5FA)),
          ('APPROVED', '$_approvedCount', 'Confirmed sessions', Icons.check_circle_rounded, AppColors.success),
          ('PENDING', '$_pendingCount', 'Awaiting approval', Icons.schedule_rounded, const Color(0xFFF59E0B)),
          ('TODAY', '$_todayCount', 'Happening today', Icons.event_rounded, const Color(0xFF06B6D4)),
        ];

        final isMobile = constraints.maxWidth < 500;

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
          BoxShadow(color: theme.shadowColor.withAlpha(10), blurRadius: 12, offset: const Offset(0, 5)),
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
                  style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w700, fontSize: 10),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: s.$5.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                child: Icon(s.$4, color: s.$5, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(s.$2, style: AppTextStyles.headlineMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          Text(s.$3, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildUpcomingSpotlight(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF06B6D4).withAlpha(18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF06B6D4).withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(Icons.videocam_rounded, color: Color(0xFF0891B2), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Next Session: Sprint Sync at 03:00 PM', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0E7490))),
                Text('Platform: Google Meet • 6 participants', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Launching meeting session...'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.launch_rounded, size: 14),
            label: const Text('Join', style: TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(ThemeData theme) {
    final list = _filteredMeetings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_note_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Scheduled Meetings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const Spacer(),
            Wrap(
              spacing: 6,
              children: ['All', 'Approved', 'Pending'].map((f) {
                final isSel = _selectedStatusFilter == f;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedStatusFilter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? theme.colorScheme.primary : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSel ? theme.colorScheme.primary : theme.dividerColor.withAlpha(80)),
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
        const SizedBox(height: 12),

        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Text('No meetings found for this filter', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final m = list[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: theme.shadowColor.withAlpha(10), blurRadius: 12, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF06B6D4).withAlpha(25),
                          child: const Icon(Icons.video_call_rounded, color: Color(0xFF0891B2), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('${m.date} • ${m.time}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: m.statusColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            m.statusText,
                            style: TextStyle(color: m.statusColor, fontSize: 11, fontWeight: FontWeight.w700),
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
                        Text('Host: ${m.host} (${m.platform})', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                        Row(
                          children: [
                            if (m.status == MeetingStatus.pending) ...[
                              FilledButton(
                                onPressed: () {
                                  setState(() => m.status = MeetingStatus.approved);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Meeting "${m.title}" approved!'), backgroundColor: AppColors.success),
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Approve', style: TextStyle(fontSize: 11.5)),
                              ),
                              const SizedBox(width: 6),
                            ],
                            IconButton(
                              onPressed: () {
                                setState(() => _meetings.removeWhere((item) => item.id == m.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${m.title} cancelled!'), behavior: SnackBarBehavior.floating),
                                );
                              },
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                              tooltip: 'Cancel',
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
