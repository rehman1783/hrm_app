import 'package:flutter/material.dart';

import '../../../core/widgets/app_placeholder_page.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class FinanceView extends StatelessWidget {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderPage(title: 'Finance Page', drawer: HRMDrawer());
  }
}
