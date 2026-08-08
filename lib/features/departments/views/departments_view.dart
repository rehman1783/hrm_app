import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/departments_widgets.dart';

class DepartmentsView extends StatelessWidget {
  const DepartmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Departments'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const DepartmentsViewBody(),
    );
  }
}
