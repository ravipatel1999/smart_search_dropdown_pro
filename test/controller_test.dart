import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

void main() {
  group('SmartDropdownController Tests', () {
    test('initial selection state', () {
      final controller = SmartDropdownController<String>(
        initialSelection: ['Sunshine Hospital'],
      );

      expect(controller.selectedItem, equals('Sunshine Hospital'));
      expect(controller.selectedItems, contains('Sunshine Hospital'));
      expect(controller.isOpen, isFalse);
    });

    test('select and deselect items', () {
      final controller = SmartDropdownController<String>();

      controller.select('Everest Hospital');
      expect(controller.selectedItems, contains('Everest Hospital'));

      controller.deselect('Everest Hospital');
      expect(controller.selectedItems, isEmpty);
    });

    test('selectAll and clearAll', () {
      final controller = SmartDropdownController<String>();
      final items = ['Hospital A', 'Hospital B', 'Hospital C'];

      controller.selectAll(items);
      expect(controller.selectedItems.length, equals(3));

      controller.clearAll();
      expect(controller.selectedItems, isEmpty);
    });

    test('open close toggle', () {
      final controller = SmartDropdownController<String>();
      expect(controller.isOpen, isFalse);

      controller.open();
      expect(controller.isOpen, isTrue);

      controller.close();
      expect(controller.isOpen, isFalse);

      controller.toggle();
      expect(controller.isOpen, isTrue);
    });

    test('async states, generation, retry and pagination controls', () async {
      final controller = SmartDropdownController<String>();

      expect(controller.isLoading, isFalse);
      expect(controller.isLoadingInitial, isFalse);
      expect(controller.isLoadingMore, isFalse);
      expect(controller.error, isNull);
      expect(controller.paginationError, isNull);
      expect(controller.currentPage, equals(1));
      expect(controller.searchGeneration, equals(0));

      bool retryCalled = false;
      bool retryPaginationCalled = false;
      bool refreshCalled = false;

      controller.attachCallbacks(
        onRetry: () => retryCalled = true,
        onRetryPagination: () => retryPaginationCalled = true,
        onRefresh: () => refreshCalled = true,
      );

      controller.updateState(
        isLoadingInitial: true,
        searchGeneration: 5,
        currentPage: 2,
      );

      expect(controller.isLoadingInitial, isTrue);
      expect(controller.isLoading, isTrue);
      expect(controller.searchGeneration, equals(5));
      expect(controller.currentPage, equals(2));

      controller.updateState(
        isLoadingInitial: false,
        isLoadingMore: true,
        paginationError: 'Page error',
      );

      expect(controller.isLoadingInitial, isFalse);
      expect(controller.isLoadingMore, isTrue);
      expect(controller.isLoading, isTrue);
      expect(controller.paginationError, equals('Page error'));

      await controller.retry();
      expect(retryCalled, isTrue);

      await controller.retryPagination();
      expect(retryPaginationCalled, isTrue);

      await controller.refresh();
      expect(refreshCalled, isTrue);
    });
  });
}

