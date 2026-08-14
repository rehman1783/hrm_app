import 'package:flutter/material.dart';

import '../../dashboard/widgets/drawer_widget.dart';
import '../widgets/profile_widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: const ProfileViewBody(),
    );
  }
}
