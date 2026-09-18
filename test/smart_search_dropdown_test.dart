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
              items: const ['Product Alpha', 'Product Beta', 'Product Gamma'],
              value: selected,
              hintText: 'Select Product',
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
    expect(find.text('Select Product'), findsOneWidget);

    // Tap dropdown trigger box
    await tester.tap(find.byKey(const Key('my_dropdown')));
    await tester.pumpAndSettle();

    // Verify dialog opened with items
    expect(find.text('Product Alpha'), findsOneWidget);
    expect(find.text('Product Beta'), findsOneWidget);
    expect(find.text('Product Gamma'), findsOneWidget);

    // Tap 'Product Beta'
    await tester.tap(find.text('Product Beta'));
    await tester.pumpAndSettle();

    // Verify selection callback fired
    expect(selected, equals('Product Beta'));
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
              items: const ['Product Alpha', 'Product Beta', 'Product Gamma'],
              hintText: 'Select Product',
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

    // Type query 'Beta' into search field
    await tester.enterText(find.byType(TextField), 'Beta');
    await tester.pumpAndSettle();

    // Verify filtering
    expect(find.text('Product Beta'), findsOneWidget);
    expect(find.text('Product Alpha'), findsNothing);
  });

  testWidgets(
      'SmartSearchDropdown renders labelText, prefixIcon, trailingLabelWidget, and loader',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmartSearchDropdown<String>(
              key: const Key('my_dropdown_full'),
              labelText: 'Product Category *',
              prefixIcon:
                  const Icon(Icons.shopping_bag, key: Key('prefix_icon')),
              trailingLabelWidget:
                  const Icon(Icons.add, key: Key('trailing_icon')),
              loader: (query, page) async {
                return DropdownPageResult(
                  items: ['Category A', 'Category B'],
                  hasMore: false,
                );
              },
              hintText: 'Select Category',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify labelText and asterisks are present
    expect(find.text('Product Category'), findsOneWidget);
    expect(find.text(' *'), findsOneWidget);

    // Verify prefixIcon and trailingLabelWidget are rendered
    expect(find.byKey(const Key('prefix_icon')), findsOneWidget);
    expect(find.byKey(const Key('trailing_icon')), findsOneWidget);
  });

  testWidgets(
      'SmartSearchDropdown multi-select supports maxVisibleChips and overflowChipBuilder',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SmartSearchDropdown<String>.multi(
            items: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
            selectedItems: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
            selection: SmartDropdownSelectionConfig(
              maxVisibleChips: 2,
              overflowChipBuilder: (context, count) => Text('+$count more'),
            ),
            onMultiChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Gamma'), findsNothing);
    expect(find.text('+2 more'), findsOneWidget);
  });

  testWidgets('SmartSearchDropdownFormField validates and resets properly',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormState>();
    String? submittedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SmartSearchDropdownFormField<String>(
              items: const ['Option A', 'Option B'],
              validator: (val) => val == null ? 'Selection required' : null,
              onSaved: (val) => submittedValue = val,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Trigger validation on empty field
    final isValid = formKey.currentState!.validate();
    await tester.pumpAndSettle();

    expect(isValid, isFalse);
    expect(find.text('Selection required'), findsOneWidget);

    formKey.currentState!.save();
    expect(submittedValue, isNull);

    // Reset form
    formKey.currentState!.reset();
    await tester.pumpAndSettle();

    expect(find.text('Selection required'), findsNothing);
  });

  testWidgets('SmartDropdownController helper methods work as expected',
      (WidgetTester tester) async {
    final controller = SmartDropdownController<String>();
    bool refreshed = false;

    controller.attachCallbacks(
      onRefresh: () => refreshed = true,
    );

    controller.select('Item 1');
    expect(controller.selectedItems, contains('Item 1'));

    controller.clear();
    expect(controller.selectedItems, isEmpty);

    controller.refresh();
    expect(refreshed, isTrue);

    controller.dispose();
  });
}
