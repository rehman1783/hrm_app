import 'package:flutter_test/flutter_test.dart';

import 'package:hrm_app/main.dart';

void main() {
  testWidgets('app boots with dashboard view', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('HRM Dashboard Ready'), findsOneWidget);
  });
}
