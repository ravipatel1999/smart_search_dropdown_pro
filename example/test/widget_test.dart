import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('SmartDropdownDemoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartDropdownDemoApp());
    expect(find.text('Smart Search Dropdown Pro'), findsOneWidget);
  });
}
