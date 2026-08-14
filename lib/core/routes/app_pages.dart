import 'package:get/get.dart';

import '../../features/attendance/views/attendance_view.dart';
import '../../features/dashboard/views/dashboard_view.dart';
import '../../features/departments/views/departments_view.dart';
import '../../features/employees/views/employees_view.dart';
import '../../features/finance/views/finance_view.dart';
import '../../features/leave/views/leave_view.dart';
import '../../features/meetings/views/meetings_view.dart';
import '../../features/payroll/views/payroll_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/settings/views/settings_view.dart';
import '../../features/training/views/training_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.employees,
      page: () => const EmployeesView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.departments,
      page: () => const DepartmentsView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendanceView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.leave,
      page: () => const LeaveView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.payroll,
      page: () => const PayrollView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.training,
      page: () => const TrainingView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.meetings,
      page: () => const MeetingsView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.finance,
      page: () => const FinanceView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.fadeIn,
    ),
  ];
}
