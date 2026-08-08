import 'package:flutter/material.dart';

import '../../dashboard/widgets/dashboard_widgets.dart';
import '../widgets/meetings_widgets.dart';

class MeetingsView extends StatelessWidget {
  const MeetingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HRMDrawer(),
      appBar: AppBar(
        title: const Text('Meetings'),
        centerTitle: false,
        elevation: 0,
      ),
      body: const MeetingsViewBody(),
    );
  }
}
