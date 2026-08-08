import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/employees_widgets.dart';

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Employees'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const EmployeesViewBody(),
    );
  }
}
