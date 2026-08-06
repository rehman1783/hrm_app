import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/departments_widgets.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Departments'),
        centerTitle: false,
      ),
      body: const DepartmentsViewBody(),
    );
  }
}
