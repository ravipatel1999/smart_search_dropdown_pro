import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

void main() {
  testWidgets('SmartSearchDropdown renders hint text and opens dialog on tap',
      (WidgetTester tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmartSearchDropdown<String>(
              key: const Key('my_dropdown'),
              items: const ['Sunshine Hospital', 'Everest Hospital', 'City Care Hospital'],
              value: selected,
              hintText: 'Select Facility',
              popup: const SmartDropdownPopupConfig(
                presentation: DropdownPresentation.dialog,
              ),
              search: const SmartDropdownSearchConfig(autoFocus: false),
              onChanged: (value) {
                selected = value;
              },
            ),
          ),
        ),
      ),
    );

    // Verify hint text is rendered
    expect(find.text('Select Facility'), findsOneWidget);

    // Tap dropdown trigger box
    await tester.tap(find.byKey(const Key('my_dropdown')));
    await tester.pumpAndSettle();

    // Verify dialog opened with items
    expect(find.text('Sunshine Hospital'), findsOneWidget);
    expect(find.text('Everest Hospital'), findsOneWidget);
    expect(find.text('City Care Hospital'), findsOneWidget);

    // Tap 'Everest Hospital'
    await tester.tap(find.text('Everest Hospital'));
    await tester.pumpAndSettle();

    // Verify selection callback fired
    expect(selected, equals('Everest Hospital'));
  });

  testWidgets('SmartSearchDropdown filters items on search query input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmartSearchDropdown<String>(
              key: const Key('my_dropdown'),
              items: const ['Sunshine Hospital', 'Everest Hospital', 'City Care Hospital'],
              hintText: 'Select Facility',
              popup: const SmartDropdownPopupConfig(
                presentation: DropdownPresentation.dialog,
              ),
              search: const SmartDropdownSearchConfig(autoFocus: false),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.byKey(const Key('my_dropdown')));
    await tester.pumpAndSettle();

    // Type query 'Everest' into search field
    await tester.enterText(find.byType(TextField), 'Everest');
    await tester.pumpAndSettle();

    // Verify filtering
    expect(find.text('Everest Hospital'), findsOneWidget);
    expect(find.text('Sunshine Hospital'), findsNothing);
  });
}
