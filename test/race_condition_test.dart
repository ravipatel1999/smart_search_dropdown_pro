import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

import 'helpers/fake_remote_api_service.dart';

class TestItem {
  final String id;
  final String name;

  const TestItem({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}

void main() {
  group('Remote Search & Pagination Race Condition Tests', () {
    late FakeRemoteApiService<TestItem> api;
    late SmartDropdownController<TestItem> controller;

    setUp(() {
      api = FakeRemoteApiService<TestItem>();
      controller = SmartDropdownController<TestItem>();
    });

    tearDown(() {
      controller.dispose();
      api.clear();
    });

    Widget buildTestWidget({
      Duration debounce = const Duration(milliseconds: 100),
      bool paginationEnabled = false,
      int pageSize = 20,
      bool preventDuplicates = true,
      dynamic Function(TestItem)? itemIdExtractor,
      ValueChanged<TestItem?>? onChanged,
      SearchEmptyQueryBehavior emptyQueryBehavior =
          SearchEmptyQueryBehavior.showInitialItems,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              child: SmartSearchDropdown<TestItem>(
                key: const Key('dropdown_under_test'),
                controller: controller,
                itemLabelBuilder: (item) => item.name,
                itemIdExtractor: itemIdExtractor ?? (item) => item.id,
                asyncSearch: (query) => api.search(query),
                search: SmartDropdownSearchConfig(
                  debounceDuration: debounce,
                  emptyQueryBehavior: emptyQueryBehavior,
                ),
                pagination: SmartDropdownPaginationConfig(
                  enabled: paginationEnabled,
                  pageSize: pageSize,
                  preventDuplicates: preventDuplicates,
                  onLoadMoreWithQuery: (page, query) =>
                      api.searchPaginated(query, page, pageSize),
                ),
                popup: const SmartDropdownPopupConfig(
                  presentation: DropdownPresentation.dialog,
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      );
    }

    /// TEST 1:
    /// A starts
    /// B starts
    /// B returns
    /// A returns
    /// Expected: B results only.
    testWidgets('TEST 1: B returns before A -> only B results remain visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Open popup
      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      // Type "A"
      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump(const Duration(milliseconds: 150)); // Allow debounce to fire

      expect(api.requests.length, equals(1));
      final requestA = api.requests[0];
      expect(requestA.query, equals('A'));

      // Type "B" before A completes
      await tester.enterText(find.byType(TextField), 'B');
      await tester.pump(const Duration(milliseconds: 150)); // Debounce fires

      expect(api.requests.length, equals(2));
      final requestB = api.requests[1];
      expect(requestB.query, equals('B'));

      // Network completion order: B completes first, then A completes
      requestB.complete([
        const TestItem(id: 'b1', name: 'Item B1'),
        const TestItem(id: 'b2', name: 'Item B2'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Item B1'), findsOneWidget);
      expect(find.text('Item B2'), findsOneWidget);

      // Now stale request A completes later
      requestA.complete([
        const TestItem(id: 'a1', name: 'Item A1'),
      ]);
      await tester.pumpAndSettle();

      // Stale A must NOT overwrite B results
      expect(find.text('Item B1'), findsOneWidget);
      expect(find.text('Item B2'), findsOneWidget);
      expect(find.text('Item A1'), findsNothing);
    });

    /// TEST 2:
    /// A starts
    /// B starts
    /// A returns
    /// B returns
    /// Expected: B results only.
    testWidgets('TEST 2: A returns before B -> only B results remain visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump(const Duration(milliseconds: 150));

      await tester.enterText(find.byType(TextField), 'B');
      await tester.pump(const Duration(milliseconds: 150));

      final requestA = api.requests[0];
      final requestB = api.requests[1];

      // A completes first
      requestA.complete([
        const TestItem(id: 'a1', name: 'Item A1'),
      ]);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Since B is the current active search generation, A should be dropped!
      expect(find.text('Item A1'), findsNothing);

      // Now B completes
      requestB.complete([
        const TestItem(id: 'b1', name: 'Item B1'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Item B1'), findsOneWidget);
      expect(find.text('Item A1'), findsNothing);
    });

    /// TEST 3:
    /// A starts
    /// B starts
    /// C starts
    /// C returns
    /// A returns
    /// B returns
    /// Expected: C results only.
    testWidgets('TEST 3: Inverted 3-request completion -> C results only',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump(const Duration(milliseconds: 150));

      await tester.enterText(find.byType(TextField), 'B');
      await tester.pump(const Duration(milliseconds: 150));

      await tester.enterText(find.byType(TextField), 'C');
      await tester.pump(const Duration(milliseconds: 150));

      expect(api.requests.length, equals(3));
      final requestA = api.requests[0];
      final requestB = api.requests[1];
      final requestC = api.requests[2];

      // C returns first
      requestC.complete([
        const TestItem(id: 'c1', name: 'Flutter Testing C'),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('Flutter Testing C'), findsOneWidget);

      // A returns next -> dropped
      requestA.complete([
        const TestItem(id: 'a1', name: 'Flutter Dart A'),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('Flutter Testing C'), findsOneWidget);
      expect(find.text('Flutter Dart A'), findsNothing);

      // B returns last -> dropped
      requestB.complete([
        const TestItem(id: 'b1', name: 'Flutter Widgets B'),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('Flutter Testing C'), findsOneWidget);
      expect(find.text('Flutter Widgets B'), findsNothing);
    });

    /// TEST 4:
    /// Search A
    /// Pagination A page 2 starts
    /// Search B
    /// A page 2 returns
    /// Expected: A page 2 ignored.
    testWidgets('TEST 4: Late pagination response from query A ignored after query B starts',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(paginationEnabled: true, pageSize: 1));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      // Search A
      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump(const Duration(milliseconds: 150));

      final requestA1 = api.requests[0];
      requestA1.complete([
        const TestItem(id: 'a_p1', name: 'A Page 1 Item'),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('A Page 1 Item'), findsOneWidget);

      // Trigger pagination for A (Page 2)
      controller.loadMore();
      await tester.pump();

      final requestAPage2 = api.requests.lastWhere((r) => r.query == 'A' && r.page == 2);

      // Before A page 2 returns, user searches "B"
      await tester.enterText(find.byType(TextField), 'B');
      await tester.pump(const Duration(milliseconds: 150));

      final requestB1 = api.requests.lastWhere((r) => r.query == 'B' && r.page == 1);
      requestB1.complete([
        const TestItem(id: 'b_p1', name: 'B Page 1 Item'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('B Page 1 Item'), findsOneWidget);
      expect(find.text('A Page 1 Item'), findsNothing);

      // Late A page 2 completes now
      requestAPage2.complete([
        const TestItem(id: 'a_p2', name: 'A Page 2 Item'),
      ]);
      await tester.pumpAndSettle();

      // A page 2 must be completely ignored and not appended to B results
      expect(find.text('B Page 1 Item'), findsOneWidget);
      expect(find.text('A Page 2 Item'), findsNothing);
    });

    /// TEST 5:
    /// Search A
    /// Clear search
    /// A returns
    /// Expected: A response ignored.
    testWidgets('TEST 5: Search A -> Clear search -> A returns late -> A ignored',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump(const Duration(milliseconds: 150));

      final requestA = api.requests[0];

      // Clear search immediately
      await tester.tap(find.byIcon(Icons.cancel_rounded));
      await tester.pumpAndSettle();

      // Stale A returns late
      requestA.complete([
        const TestItem(id: 'f1', name: 'Flutter Framework'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Flutter Framework'), findsNothing);
    });

    /// TEST 6:
    /// Search A
    /// Close dropdown
    /// A returns
    /// Expected: No invalid state update or crash.
    testWidgets('TEST 6: Search A -> Close dropdown -> A returns -> safe handling',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'dart');
      await tester.pump(const Duration(milliseconds: 150));

      final request = api.requests[0];

      // Close dropdown programmatically or tap outside
      controller.close();
      await tester.pumpAndSettle();

      expect(controller.isOpen, isFalse);

      // Async response completes after close
      request.complete([
        const TestItem(id: 'd1', name: 'Dart Language'),
      ]);
      await tester.pumpAndSettle();

      // Reopen dropdown
      controller.open();
      await tester.pumpAndSettle();

      expect(controller.isOpen, isTrue);
    });

    /// TEST 7:
    /// Search A
    /// Dispose widget
    /// A returns
    /// Expected: No exception or unhandled error.
    testWidgets('TEST 7: Search A -> Dispose widget -> A returns -> no exception',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'search_query');
      await tester.pump(const Duration(milliseconds: 150));

      final request = api.requests[0];

      // Close dropdown before unmounting so dialog with spinner doesn't linger
      controller.close();
      await tester.pumpAndSettle();

      // Replace widget with empty container to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
      await tester.pumpAndSettle();

      // Async request completes on disposed widget
      expect(() => request.complete([
        const TestItem(id: '1', name: 'Result'),
      ]), returnsNormally);

      await tester.pumpAndSettle();
    });

    /// TEST 8:
    /// Rapid typing: a, ab, abc, abcd
    /// Expected: Only final debounced query is requested.
    testWidgets('TEST 8: Rapid typing fires only one final request after debounce',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(debounce: const Duration(milliseconds: 300)));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      // Keystroke 1: 'a'
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 50));

      // Keystroke 2: 'ab'
      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump(const Duration(milliseconds: 50));

      // Keystroke 3: 'abc'
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump(const Duration(milliseconds: 50));

      // Keystroke 4: 'abcd'
      await tester.enterText(find.byType(TextField), 'abcd');
      await tester.pump(const Duration(milliseconds: 50));

      // No API call fired yet
      expect(api.requests.length, equals(0));

      // Advance clock past 300ms debounce
      await tester.pump(const Duration(milliseconds: 300));

      // Exactly one request was fired, for 'abcd'
      expect(api.requests.length, equals(1));
      expect(api.requests[0].query, equals('abcd'));
    });

    /// TEST 9:
    /// Rapid pagination trigger
    /// Expected: Only one page request at a time.
    testWidgets('TEST 9: Rapid pagination trigger serializes requests',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(paginationEnabled: true, pageSize: 2));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'lib');
      await tester.pump(const Duration(milliseconds: 150));

      // Page 1 completes
      api.requests[0].complete([
        const TestItem(id: '1', name: 'Item 1'),
        const TestItem(id: '2', name: 'Item 2'),
      ]);
      await tester.pumpAndSettle();

      // Rapidly trigger loadMore multiple times
      controller.loadMore();
      controller.loadMore();
      controller.loadMore();
      await tester.pump();

      // Only ONE page 2 request must be active
      final page2Requests = api.requests.where((r) => r.page == 2).toList();
      expect(page2Requests.length, equals(1));

      // Complete page 2
      page2Requests.first.complete([
        const TestItem(id: '3', name: 'Item 3'),
        const TestItem(id: '4', name: 'Item 4'),
      ]);
      await tester.pumpAndSettle();

      expect(controller.currentPage, equals(2));
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    /// TEST 10:
    /// Page 1 succeeds, Page 2 fails
    /// Expected: Page 1 results remain visible.
    testWidgets('TEST 10: Page 2 failure keeps Page 1 results visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(paginationEnabled: true, pageSize: 2));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'pack');
      await tester.pump(const Duration(milliseconds: 150));

      // Page 1 succeeds
      api.requests[0].complete([
        const TestItem(id: 'p1', name: 'Package 1'),
        const TestItem(id: 'p2', name: 'Package 2'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Package 1'), findsOneWidget);
      expect(find.text('Package 2'), findsOneWidget);

      // Page 2 fails
      controller.loadMore();
      await tester.pump();

      final page2 = api.requests.lastWhere((r) => r.page == 2);
      page2.completeError(Exception('Network timeout'));
      await tester.pumpAndSettle();

      // Page 1 results MUST still be visible!
      expect(find.text('Package 1'), findsOneWidget);
      expect(find.text('Package 2'), findsOneWidget);
      // Pagination error footer and retry button should be visible
      expect(find.text('Retry'), findsOneWidget);
    });

    /// TEST 11:
    /// Page 2 fails -> Retry page 2
    /// Expected: Only page 2 is retried.
    testWidgets('TEST 11: Retry page 2 retries failed page 2 without restarting search',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(paginationEnabled: true, pageSize: 2));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'retry');
      await tester.pump(const Duration(milliseconds: 150));

      api.requests[0].complete([
        const TestItem(id: 'r1', name: 'Retry Item 1'),
        const TestItem(id: 'r1_2', name: 'Retry Item 1b'),
      ]);
      await tester.pumpAndSettle();

      // Page 2 fails
      controller.loadMore();
      await tester.pump();

      final failedPage2 = api.requests.lastWhere((r) => r.page == 2);
      failedPage2.completeError('SocketException');
      await tester.pumpAndSettle();

      // Tap Retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // A second request for page 2 should have been initiated
      final page2Requests = api.requests.where((r) => r.page == 2).toList();
      expect(page2Requests.length, equals(2));

      // Complete retried page 2
      page2Requests.last.complete([
        const TestItem(id: 'r2', name: 'Retry Item 2'),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Retry Item 1'), findsOneWidget);
      expect(find.text('Retry Item 2'), findsOneWidget);
      expect(controller.currentPage, equals(2));
    });

    /// TEST 12:
    /// Page 1 contains: 1, 2, 3
    /// Page 2 contains: 3, 4, 5
    /// Expected: 1, 2, 3, 4, 5 if duplicate filtering is enabled.
    testWidgets('TEST 12: Duplicate items across pages are deduplicated and preserve order',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        paginationEnabled: true,
        pageSize: 3,
        preventDuplicates: true,
        itemIdExtractor: (item) => item.id,
      ));
      await tester.pump();

      await tester.tap(find.byKey(const Key('dropdown_under_test')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'dedup');
      await tester.pump(const Duration(milliseconds: 150));

      // Page 1: 1, 2, 3
      api.requests[0].complete([
        const TestItem(id: '1', name: 'Item 1'),
        const TestItem(id: '2', name: 'Item 2'),
        const TestItem(id: '3', name: 'Item 3'),
      ]);
      await tester.pumpAndSettle();

      // Page 2: 3, 4, 5 (3 is duplicate)
      controller.loadMore();
      await tester.pump();

      final page2 = api.requests.lastWhere((r) => r.page == 2);
      page2.complete([
        const TestItem(id: '3', name: 'Item 3 Duplicate'),
        const TestItem(id: '4', name: 'Item 4'),
        const TestItem(id: '5', name: 'Item 5'),
      ]);
      await tester.pumpAndSettle();

      // Item 3 should only appear once
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('Item 3 Duplicate'), findsNothing);
      expect(find.text('Item 4'), findsOneWidget);
      expect(find.text('Item 5'), findsOneWidget);
    });
  });
}
