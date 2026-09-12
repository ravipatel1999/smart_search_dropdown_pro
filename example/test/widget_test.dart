import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('SmartDropdownGalleryApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartDropdownGalleryApp());
    expect(find.text('SmartSearchDropdown Gallery'), findsOneWidget);
  });
}
