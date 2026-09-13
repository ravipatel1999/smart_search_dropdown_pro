import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

import 'helpers/fake_remote_api_service.dart';

class CityItem {
  final String id;
  final String name;

  const CityItem({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}

void main() {
  group('Selection, Keyboard, and Lifecycle Tests', () {
    late FakeRemoteApiService<CityItem> api;
    late SmartDropdownController<CityItem> controller;

    setUp(() {
      api = FakeRemoteApiService<CityItem>();
      controller = SmartDropdownController<CityItem>();
    });

    tearDown(() {
      controller.dispose();
      api.clear();
    });

    testWidgets('Single-select: selection persists and displays in trigger field',
        (WidgetTester tester) async {
      CityItem? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: SmartSearchDropdown<CityItem>(
                  key: const Key('city_dropdown'),
                  controller: controller,
                  itemLabelBuilder: (c) => c.name,
                  asyncSearch: (q) => api.search(q),
                  popup: const SmartDropdownPopupConfig(
                    presentation: DropdownPresentation.dialog,
                  ),
                  onChanged: (c) => selected = c,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Open dropdown
      await tester.tap(find.byKey(const Key('city_dropdown')));
      await tester.pumpAndSettle();

      // Type "lon"
      await tester.enterText(find.byType(TextField), 'lon');
      await tester.pump(const Duration(milliseconds: 350));

      api.requests.last.complete([
        const CityItem(id: '1', name: 'London'),
        const CityItem(id: '2', name: 'Long Beach'),
      ]);
      await tester.pumpAndSettle();

      // Select 'London'
      await tester.tap(find.text('London'));
      await tester.pumpAndSettle();

      // Dropdown should be closed and trigger should display London
      expect(selected, equals(const CityItem(id: '1', name: 'London')));
      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('Multi-select: selections remain selected when search query changes',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      List<CityItem> selectedList = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: SmartSearchDropdown<CityItem>.multi(
                  key: const Key('multi_city_dropdown'),
                  controller: controller,
                  itemLabelBuilder: (c) => c.name,
                  asyncSearch: (q) => api.search(q),
                  popup: const SmartDropdownPopupConfig(
                    presentation: DropdownPresentation.dialog,
                  ),
                  onMultiChanged: (list) => selectedList = list,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Open dropdown
      await tester.tap(find.byKey(const Key('multi_city_dropdown')));
      await tester.pumpAndSettle();

      // Search query 1
      await tester.enterText(find.byType(TextField), 'new');
      await tester.pump(const Duration(milliseconds: 350));

      api.requests.last.complete([
        const CityItem(id: 'ny', name: 'New York'),
        const CityItem(id: 'nd', name: 'New Delhi'),
      ]);
      await tester.pumpAndSettle();

      // Select 'New York'
      await tester.tap(find.text('New York'));
      await tester.pumpAndSettle();

      expect(selectedList.length, equals(1));
      expect(selectedList.first.name, equals('New York'));

      // Search query 2: 'tokyo'
      await tester.enterText(find.byType(TextField), 'tokyo');
      await tester.pump(const Duration(milliseconds: 350));

      api.requests.last.complete([
        const CityItem(id: 'tk', name: 'Tokyo'),
      ]);
      await tester.pumpAndSettle();

      // Select 'Tokyo'
      await tester.tap(find.text('Tokyo'));
      await tester.pumpAndSettle();

      // Both New York and Tokyo should be selected
      expect(selectedList.length, equals(2));
      expect(selectedList.map((c) => c.name), containsAll(['New York', 'Tokyo']));
    });

    testWidgets('Initial search error displays retry button which retries query',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: SmartSearchDropdown<CityItem>(
                  key: const Key('error_dropdown'),
                  controller: controller,
                  itemLabelBuilder: (c) => c.name,
                  asyncSearch: (q) => api.search(q),
                  popup: const SmartDropdownPopupConfig(
                    presentation: DropdownPresentation.dialog,
                  ),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('error_dropdown')));
      await tester.pumpAndSettle();

      // Type "fail"
      await tester.enterText(find.byType(TextField), 'fail');
      await tester.pump(const Duration(milliseconds: 350));

      // Complete with error
      api.requests.last.completeError('Server Error 500');
      await tester.pumpAndSettle();

      expect(find.text('Exception: Server Error 500'), findsNothing);
      expect(find.text('Retry'), findsOneWidget);

      // Tap Retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // New request should have fired for "fail"
      expect(api.requests.length, equals(2));
      expect(api.requests.last.query, equals('fail'));

      // Complete retry successfully
      api.requests.last.complete([
        const CityItem(id: 'ok', name: 'Recovered Item'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Recovered Item'), findsOneWidget);
    });

    testWidgets('Keyboard navigation: arrow down, arrow up, enter, escape',
        (WidgetTester tester) async {
      CityItem? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: SmartSearchDropdown<CityItem>(
                  key: const Key('keyboard_dropdown'),
                  controller: controller,
                  itemLabelBuilder: (c) => c.name,
                  asyncSearch: (q) => api.search(q),
                  popup: const SmartDropdownPopupConfig(
                    presentation: DropdownPresentation.dialog,
                  ),
                  onChanged: (item) => selected = item,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Open dropdown
      await tester.tap(find.byKey(const Key('keyboard_dropdown')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'city');
      await tester.pump(const Duration(milliseconds: 350));

      api.requests.last.complete([
        const CityItem(id: '1', name: 'City 1'),
        const CityItem(id: '2', name: 'City 2'),
        const CityItem(id: '3', name: 'City 3'),
      ]);
      await tester.pumpAndSettle();

      // Send Arrow Down -> focus first item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Send Arrow Down -> focus second item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Send Enter -> select focused second item (City 2)
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, equals(const CityItem(id: '2', name: 'City 2')));
    });

    testWidgets('Empty query behavior: clearResults clears all items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: SmartSearchDropdown<CityItem>(
                  key: const Key('clear_behavior_dropdown'),
                  controller: controller,
                  itemLabelBuilder: (c) => c.name,
                  asyncSearch: (q) => api.search(q),
                  search: const SmartDropdownSearchConfig(
                    emptyQueryBehavior: SearchEmptyQueryBehavior.clearResults,
                    debounceDuration: Duration(milliseconds: 100),
                  ),
                  popup: const SmartDropdownPopupConfig(
                    presentation: DropdownPresentation.dialog,
                  ),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('clear_behavior_dropdown')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump(const Duration(milliseconds: 150));

      api.requests.last.complete([
        const CityItem(id: '1', name: 'Test City'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Test City'), findsOneWidget);

      // Clear search
      await tester.tap(find.byIcon(Icons.cancel_rounded));
      await tester.pumpAndSettle();

      // Results should be cleared
      expect(find.text('Test City'), findsNothing);
      expect(find.text('No items found'), findsOneWidget);
    });
  });
}
