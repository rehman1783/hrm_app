import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/attendance_widgets.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const AttendanceViewBody(),
    );
  }
}
