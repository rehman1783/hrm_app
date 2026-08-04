import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/attendance_widgets.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(drawer: HRMDrawer(), body: AttendanceViewBody());
  }
}
