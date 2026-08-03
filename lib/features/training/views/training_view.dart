import 'package:flutter/material.dart';

import '../../../core/widgets/app_placeholder_page.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class TrainingView extends StatelessWidget {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderPage(
      title: 'Training Page',
      drawer: HRMDrawer(),
    );
  }
}
