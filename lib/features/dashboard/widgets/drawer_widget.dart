import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';

class DrawerMenuItem {
  final String route;
  final String label;
  final IconData icon;
  final Color iconColor;

  const DrawerMenuItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.iconColor,
  });
}

class HRMDrawer extends StatelessWidget {
  const HRMDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth > 500 ? 320.0 : screenWidth * 0.82;

    const menuItems = [
      DrawerMenuItem(
        route: AppRoutes.dashboard,
        label: 'Dashboard',
        icon: Icons.grid_view_rounded,
        iconColor: Color(0xFF0284C7),
      ),
      DrawerMenuItem(
        route: AppRoutes.employees,
        label: 'Employees',
        icon: Icons.people_alt_rounded,
        iconColor: Color(0xFF6366F1),
      ),
      DrawerMenuItem(
        route: AppRoutes.departments,
        label: 'Departments',
        icon: Icons.apartment_rounded,
        iconColor: Color(0xFF8B5CF6),
      ),
      DrawerMenuItem(
        route: AppRoutes.attendance,
        label: 'Attendance',
        icon: Icons.access_time_filled_rounded,
        iconColor: Color(0xFF10B981),
      ),
      DrawerMenuItem(
        route: AppRoutes.leave,
        label: 'Leave',
        icon: Icons.event_available_rounded,
        iconColor: Color(0xFFF59E0B),
      ),
      DrawerMenuItem(
        route: AppRoutes.payroll,
        label: 'Payroll',
        icon: Icons.account_balance_wallet_rounded,
        iconColor: Color(0xFF22C55E),
      ),
      DrawerMenuItem(
        route: AppRoutes.training,
        label: 'Training',
        icon: Icons.school_rounded,
        iconColor: Color(0xFFF43F5E),
      ),
      DrawerMenuItem(
        route: AppRoutes.meetings,
        label: 'Meetings',
        icon: Icons.video_camera_front_rounded,
        iconColor: Color(0xFF06B6D4),
      ),
      DrawerMenuItem(
        route: AppRoutes.finance,
        label: 'Finance',
        icon: Icons.monetization_on_rounded,
        iconColor: Color(0xFFF97316),
      ),
      DrawerMenuItem(
        route: AppRoutes.settings,
        label: 'Settings',
        icon: Icons.settings_rounded,
        iconColor: Color(0xFF64748B),
      ),
    ];

    final currentRoute = Get.currentRoute;

    Widget buildMenuItem(DrawerMenuItem item) {
      final selected = item.route == currentRoute;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                    ? theme.colorScheme.primary.withAlpha(45)
                    : theme.colorScheme.primary.withAlpha(22))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? Border.all(
                  color: theme.colorScheme.primary.withAlpha(80),
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.of(context).pop();
              if (!selected) {
                Get.toNamed(item.route);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withAlpha(35)
                          : item.iconColor.withAlpha(isDark ? 30 : 18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: selected
                          ? theme.colorScheme.primary
                          : item.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Label
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  // Selected Indicator Dot or Arrow
                  if (selected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(120),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      width: drawerWidth,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Top Brand Header
            Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0284C7), // Blue
                    Color(0xFF4F46E5), // Indigo
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withAlpha(50),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // App Icon Container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(45),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white.withAlpha(60)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.hub_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Brand Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'WholCure HRM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4ADE80), // Online Green
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Enterprise Portal',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: menuItems.map(buildMenuItem).toList(),
              ),
            ),

            // 3. Bottom User Profile Card
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha(12),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: theme.dividerColor.withAlpha(50),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoutes.profile);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // User Avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF0284C7), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Name and Role
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'HR Manager',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'hr@hrm.com',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Chevron
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
