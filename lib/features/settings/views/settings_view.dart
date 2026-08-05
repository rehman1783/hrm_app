import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../dashboard/widgets/drawer_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: AppTextStyles.headlineMedium.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => SwitchListTile.adaptive(
                value: themeController.isDarkMode,
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Switch between light and dark app themes',
                ),
                onChanged: (_) async {
                  await themeController.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tileColor: theme.cardColor,
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('App version'),
              subtitle: const Text('HRM App v1.0.0'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tileColor: theme.cardColor,
              leading: const Icon(Icons.palette_rounded),
              title: const Text('Theme colors'),
              subtitle: const Text('Primary blue with a fresh accent palette'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tileColor: theme.cardColor,
              leading: const Icon(Icons.lock_outline_rounded),
              title: const Text('Security'),
              subtitle: const Text('Secure employee and HR data'),
            ),
          ],
        ),
      ),
    );
  }
}
