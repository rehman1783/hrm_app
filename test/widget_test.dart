import 'package:flutter_test/flutter_test.dart';

import 'package:hrm_app/main.dart';

void main() {
  testWidgets('app boots with dashboard view', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
  });
}
