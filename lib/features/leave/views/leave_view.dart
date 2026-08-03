import 'package:flutter/material.dart';

import '../../../core/widgets/app_placeholder_page.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class LeaveView extends StatelessWidget {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderPage(
      title: 'Leave Page',
      drawer: HRMDrawer(),
    );
  }
}
