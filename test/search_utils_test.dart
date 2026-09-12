import 'package:flutter_test/flutter_test.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
import 'package:smart_search_dropdown_pro/src/utilities/search_utils.dart';

void main() {
  group('SearchUtils Tests', () {
    test('contains search matching', () {
      expect(
        SearchUtils.matches(
          label: 'Sunshine Hospital',
          query: 'sun',
          searchMode: SearchMode.contains,
        ),
        isTrue,
      );
      expect(
        SearchUtils.matches(
          label: 'Sunshine Hospital',
          query: 'xyz',
          searchMode: SearchMode.contains,
        ),
        isFalse,
      );
    });

    test('startsWith search matching', () {
      expect(
        SearchUtils.matches(
          label: 'Sunshine Hospital',
          query: 'sun',
          searchMode: SearchMode.startsWith,
        ),
        isTrue,
      );
      expect(
        SearchUtils.matches(
          label: 'Sunshine Hospital',
          query: 'hosp',
          searchMode: SearchMode.startsWith,
        ),
        isFalse,
      );
    });

    test('fuzzy search matching', () {
      expect(
        SearchUtils.matches(
          label: 'Sunshine Hospital',
          query: 'snshp',
          searchMode: SearchMode.fuzzy,
        ),
        isTrue,
      );
    });
  });
}
