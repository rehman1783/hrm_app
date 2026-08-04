import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AttendanceViewBody extends StatelessWidget {
  const AttendanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _AttendanceHeader(),
            SizedBox(height: 22),
            _TodayAttendanceCard(),
            SizedBox(height: 24),
            _AttendanceHistorySection(),
          ],
        ),
      ),
    );
  }
}

class _AttendanceHeader extends StatelessWidget {
  const _AttendanceHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Attendance', style: AppTextStyles.headlineMedium),
              SizedBox(height: 6),
              Text(
                'Check-in and check-out to track your working hours',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Check In'),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Check Out'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TodayAttendanceCard extends StatelessWidget {
  const _TodayAttendanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Today\'s Attendance', style: AppTextStyles.titleMedium),
                  SizedBox(height: 4),
                  Text('Tue, Aug 4', style: AppTextStyles.bodyMedium),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F8EF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Absent',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FBFF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('No Check-in', style: AppTextStyles.headlineMedium),
                SizedBox(height: 10),
                Text(
                  'You have not checked in today. Tap Check In to start your day.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceHistorySection extends StatelessWidget {
  const _AttendanceHistorySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.calendar_month_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Attendance History', style: AppTextStyles.titleMedium),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1FBF7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(child: Text('DATE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    Expanded(child: Text('CHECK IN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    Expanded(child: Text('CHECK OUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    Expanded(child: Text('WORKING HOURS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    SizedBox(width: 68, child: Text('STATUS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...attendanceHistory.map((record) => AttendanceHistoryItem(record: record)),
            ],
          ),
        ),
      ],
    );
  }
}

class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceHistoryItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.date,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: record.status == 'Present'
                      ? AppColors.success.withAlpha(41)
                      : AppColors.warning.withAlpha(41),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(
                    color: record.status == 'Present'
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AttendanceLabelValue(
                  label: 'Check In',
                  value: record.checkIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttendanceLabelValue(
                  label: 'Check Out',
                  value: record.checkOut,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AttendanceLabelValue(
            label: 'Working Hours',
            value: record.workHours,
          ),
        ],
      ),
    );
  }
}

class _AttendanceLabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _AttendanceLabelValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class AttendanceRecord {
  final String date;
  final String checkIn;
  final String checkOut;
  final String workHours;
  final String status;

  const AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.workHours,
    required this.status,
  });
}

const attendanceHistory = [
  AttendanceRecord(
    date: 'Wed, Jul 29',
    checkIn: '10:24 PM',
    checkOut: '10:25 PM',
    workHours: '0.01 hrs',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Tue, Jul 28',
    checkIn: '08:44 PM',
    checkOut: '08:45 PM',
    workHours: '0.01 hrs',
    status: 'Present',
  ),
  AttendanceRecord(
    date: 'Mon, Jul 27',
    checkIn: '11:19 PM',
    checkOut: '11:19 PM',
    workHours: '-',
    status: 'Present',
  ),
];
