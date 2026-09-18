import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

void main() {
  group('SmartDropdownController Tests', () {
    test('initial selection state', () {
      final controller = SmartDropdownController<String>(
        initialSelection: ['MacBook Pro'],
      );

      expect(controller.selectedItem, equals('MacBook Pro'));
      expect(controller.selectedItems, contains('MacBook Pro'));
      expect(controller.isOpen, isFalse);
    });

    test('select and deselect items', () {
      final controller = SmartDropdownController<String>();

      controller.select('Wireless Headphones');
      expect(controller.selectedItems, contains('Wireless Headphones'));

      controller.deselect('Wireless Headphones');
      expect(controller.selectedItems, isEmpty);
    });

    test('selectAll and clearAll', () {
      final controller = SmartDropdownController<String>();
      final items = ['Product A', 'Product B', 'Product C'];

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
  });
}
