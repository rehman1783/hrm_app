import 'package:flutter/material.dart';

import '../../../core/widgets/app_placeholder_page.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderPage(
      title: 'Attendance Page',
      drawer: HRMDrawer(),
    );
  }
}
