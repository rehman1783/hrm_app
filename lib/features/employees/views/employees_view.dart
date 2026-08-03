import 'package:flutter/material.dart';

import '../../../core/widgets/app_placeholder_page.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderPage(
      title: 'Employees Page',
      drawer: HRMDrawer(),
    );
  }
}
