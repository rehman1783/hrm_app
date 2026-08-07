import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/training_widgets.dart';

class TrainingView extends StatelessWidget {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Training'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const TrainingViewBody(),
    );
  }
}
