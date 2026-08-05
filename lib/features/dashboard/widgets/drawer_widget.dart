import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class DrawerMenuItem {
  final String route;
  final String label;
  final IconData icon;

  const DrawerMenuItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}

class HRMDrawer extends StatelessWidget {
  const HRMDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width * 0.78;

    const menuItems = [
      DrawerMenuItem(
        route: AppRoutes.dashboard,
        label: 'Dashboard',
        icon: Icons.grid_view_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.employees,
        label: 'Employees',
        icon: Icons.person_2_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.departments,
        label: 'Departments',
        icon: Icons.apartment_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.attendance,
        label: 'Attendance',
        icon: Icons.access_time_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.leave,
        label: 'Leave',
        icon: Icons.calendar_today_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.payroll,
        label: 'Payroll',
        icon: Icons.account_balance_wallet_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.training,
        label: 'Training',
        icon: Icons.school_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.meetings,
        label: 'Meetings',
        icon: Icons.event_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.finance,
        label: 'Finance',
        icon: Icons.attach_money_rounded,
      ),
      DrawerMenuItem(
        route: AppRoutes.settings,
        label: 'Settings',
        icon: Icons.settings_rounded,
      ),
    ];

    final currentRoute = Get.currentRoute;

    Widget menuItem(DrawerMenuItem item) {
      final selected = item.route == currentRoute;
      final tileColor = selected
          ? theme.colorScheme.primaryContainer
          : theme.cardColor;
      final iconBackgroundColor = selected
          ? theme.colorScheme.primary.withAlpha(32)
          : theme.colorScheme.surface;
      final textColor = selected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : null,
          boxShadow: [
            if (selected)
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(26),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
              size: 24,
            ),
          ),
          title: Text(
            item.label,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          trailing: selected
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary,
                )
              : null,
          onTap: () {
            Navigator.of(context).pop();
            if (!selected) {
              Get.toNamed(item.route);
            }
          },
        ),
      );
    }

    return Drawer(
      width: width,
      child: Container(
        color: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(46),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withOpacity(0.46),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WholCure HRM',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Smart people management',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.72,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: menuItems.map(menuItem).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'H',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'HR Manager',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'hr@example.com',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.72),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurface,
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
