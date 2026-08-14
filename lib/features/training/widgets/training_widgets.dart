import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// =============================================================
// DATA MODEL
// =============================================================

class TrainingProgram {
  final String id;
  final String name;
  final String code;
  final String trainer;
  final String trainerEmail;
  final String type;
  final Color typeColor;
  final String schedule;
  final String mode;
  String status;
  final Color color;
  int enrolledCount;
  final int capacity;

  TrainingProgram({
    required this.id,
    required this.name,
    required this.code,
    required this.trainer,
    required this.trainerEmail,
    required this.type,
    required this.typeColor,
    required this.schedule,
    required this.mode,
    required this.status,
    required this.color,
    required this.enrolledCount,
    required this.capacity,
  });
}

// =============================================================
// MAIN BODY (STATEFUL)
// =============================================================

class TrainingViewBody extends StatefulWidget {
  const TrainingViewBody({super.key});

  @override
  State<TrainingViewBody> createState() => _TrainingViewBodyState();
}

class _TrainingViewBodyState extends State<TrainingViewBody> {
  String _selectedStatus = 'All Statuses';
  String _selectedMode = 'All Modes';

  late List<TrainingProgram> _programs;

  @override
  void initState() {
    super.initState();
    _programs = [
      TrainingProgram(
        id: 'TRN-001',
        name: 'Flutter Architecture & Best Practices',
        code: 'ENG-101',
        trainer: 'Sarah Jenkins',
        trainerEmail: 'sarah.j@company.com',
        type: 'Technical',
        typeColor: const Color(0xFF60A5FA),
        schedule: 'Aug 20, 2026 (2:00 PM)',
        mode: 'Online',
        status: 'Upcoming',
        color: const Color(0xFF0284C7),
        enrolledCount: 5,
        capacity: 15,
      ),
      TrainingProgram(
        id: 'TRN-002',
        name: 'Modern UI/UX Design System in Figma',
        code: 'DES-202',
        trainer: 'Ali Khan',
        trainerEmail: 'ali.design@company.com',
        type: 'Design',
        typeColor: const Color(0xFF8B5CF6),
        schedule: 'Aug 25, 2026 (11:00 AM)',
        mode: 'In-Person',
        status: 'Upcoming',
        color: const Color(0xFF8B5CF6),
        enrolledCount: 8,
        capacity: 12,
      ),
      TrainingProgram(
        id: 'TRN-003',
        name: 'HR Compliance & Management',
        code: 'HR-301',
        trainer: 'User (HR Manager)',
        trainerEmail: 'hr@hrm.com',
        type: 'Management',
        typeColor: const Color(0xFF10B981),
        schedule: 'Jul 15, 2026 (10:00 AM)',
        mode: 'Online',
        status: 'Completed',
        color: const Color(0xFF10B981),
        enrolledCount: 12,
        capacity: 12,
      ),
    ];
  }

  // --- STATS ---
  int get _totalCount => _programs.length;
  int get _upcomingCount => _programs.where((p) => p.status == 'Upcoming').length;
  int get _completedCount => _programs.where((p) => p.status == 'Completed').length;
  int get _totalEnrolled => _programs.fold(0, (sum, p) => sum + p.enrolledCount);

  List<TrainingProgram> get _filteredPrograms {
    return _programs.where((p) {
      if (_selectedStatus != 'All Statuses' && p.status != _selectedStatus) return false;
      if (_selectedMode != 'All Modes' && p.mode != _selectedMode) return false;
      return true;
    }).toList();
  }

  // --- CREATE TRAINING MODAL ---
  void _openCreateTrainingDialog() {
    final titleCtrl = TextEditingController();
    final trainerCtrl = TextEditingController(text: 'Sarah Jenkins');
    final scheduleCtrl = TextEditingController(text: 'Aug 28, 2026 (3:00 PM)');
    final capacityCtrl = TextEditingController(text: '15');
    String mode = 'Online';
    String type = 'Technical';

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
                              child: const Icon(Icons.school_rounded, color: AppColors.success, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Create Training Program',
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        _buildInput('PROGRAM TITLE', titleCtrl, theme),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildInput('TRAINER NAME', trainerCtrl, theme)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildInput('CAPACITY', capacityCtrl, theme, keyboardType: TextInputType.number)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('MODE', style: AppTextStyles.labelMedium.copyWith(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
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
                                        value: mode,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(value: 'Online', child: Text('Online')),
                                          DropdownMenuItem(value: 'In-Person', child: Text('In-Person')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) setModalState(() => mode = val);
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
                                  Text('TYPE', style: AppTextStyles.labelMedium.copyWith(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
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
                                        value: type,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(value: 'Technical', child: Text('Technical')),
                                          DropdownMenuItem(value: 'Design', child: Text('Design')),
                                          DropdownMenuItem(value: 'Management', child: Text('Management')),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) setModalState(() => type = val);
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
                        _buildInput('SCHEDULE & DATE', scheduleCtrl, theme),
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
                                  _programs.add(
                                    TrainingProgram(
                                      id: 'TRN-00${_programs.length + 1}',
                                      name: titleCtrl.text.trim(),
                                      code: 'GEN-${100 + _programs.length}',
                                      trainer: trainerCtrl.text.trim().isEmpty ? 'Lead Trainer' : trainerCtrl.text.trim(),
                                      trainerEmail: 'trainer@company.com',
                                      type: type,
                                      typeColor: type == 'Technical' ? const Color(0xFF60A5FA) : const Color(0xFF8B5CF6),
                                      schedule: scheduleCtrl.text.trim(),
                                      mode: mode,
                                      status: 'Upcoming',
                                      color: const Color(0xFF0284C7),
                                      enrolledCount: 0,
                                      capacity: int.tryParse(capacityCtrl.text.trim()) ?? 10,
                                    ),
                                  );
                                });
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${titleCtrl.text.trim()} created successfully!'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Create Program'),
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

  void _showProgramDetails(TrainingProgram p) {
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
                        radius: 20,
                        backgroundColor: p.color.withAlpha(30),
                        child: Icon(Icons.school_rounded, color: p.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 16)),
                            Text('Code: ${p.code} • ${p.type}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  _buildDetailRow('Trainer', '${p.trainer} (${p.trainerEmail})', theme),
                  _buildDetailRow('Schedule', p.schedule, theme),
                  _buildDetailRow('Delivery Mode', p.mode, theme),
                  _buildDetailRow('Enrollment', '${p.enrolledCount} / ${p.capacity} participants', theme),
                  _buildDetailRow('Status', p.status, theme),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (p.status == 'Upcoming')
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              if (p.enrolledCount < p.capacity) {
                                p.enrolledCount++;
                              }
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enrolled in ${p.name}!'), backgroundColor: AppColors.success),
                            );
                          },
                          icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                          label: const Text('Enroll Self'),
                          style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                        ),
                      OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
        Text(label, style: AppTextStyles.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600, fontSize: 11)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.dividerColor.withAlpha(80))),
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
            _buildHeader(theme),
            const SizedBox(height: 12),
            _buildStatsRow(theme),
            const SizedBox(height: 14),
            _buildFilterSection(theme),
            const SizedBox(height: 14),
            _buildProgramsList(theme),
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
              Text('Training', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 2),
              Text('Manage employee training programs and enrollments', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _openCreateTrainingDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Create Training'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
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
          ('TOTAL PROGRAMS', '$_totalCount', 'Catalog count', Icons.school_rounded, const Color(0xFF60A5FA)),
          ('UPCOMING', '$_upcomingCount', 'Open for enrollment', Icons.event_available_rounded, AppColors.success),
          ('COMPLETED', '$_completedCount', 'Past sessions', Icons.task_alt_rounded, const Color(0xFF8B5CF6)),
          ('ENROLLMENTS', '$_totalEnrolled', 'Active learners', Icons.groups_rounded, const Color(0xFFF59E0B)),
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
                decoration: BoxDecoration(color: s.$5.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                child: Icon(s.$4, color: s.$5, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.$2,
            style: AppTextStyles.headlineMedium.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(s.$3, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
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
          BoxShadow(color: theme.shadowColor.withAlpha(10), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withAlpha(80)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Upcoming', child: Text('Upcoming', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Completed', child: Text('Completed', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
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
                border: Border.all(color: theme.dividerColor.withAlpha(80)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMode,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'All Modes', child: Text('All Modes', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'Online', child: Text('Online Only', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'In-Person', child: Text('In-Person Only', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMode = val);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsList(ThemeData theme) {
    final list = _filteredPrograms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.school_rounded, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text('Training Programs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${list.length} programs',
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
            child: Text('No training programs match this filter', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final p = list[index];
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
                          backgroundColor: p.color.withAlpha(25),
                          child: Icon(Icons.menu_book_rounded, color: p.color, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('Trainer: ${p.trainer} • ${p.mode}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: p.status == 'Upcoming' ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            p.status,
                            style: TextStyle(
                              color: p.status == 'Upcoming' ? const Color(0xFF16A34A) : const Color(0xFF64748B),
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
                        Text('Enrolled: ${p.enrolledCount}/${p.capacity}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showProgramDetails(p),
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
                                setState(() => _programs.removeWhere((item) => item.id == p.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p.name} deleted!'), behavior: SnackBarBehavior.floating),
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
