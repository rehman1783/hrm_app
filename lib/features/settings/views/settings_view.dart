import 'package:flutter/material.dart';

import '../../dashboard/widgets/drawer_widget.dart';
import '../widgets/settings_widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: const SettingsViewBody(),
    );
  }
}
