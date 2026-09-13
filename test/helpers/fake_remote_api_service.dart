import 'dart:async';

/// A controllable async request object that allows manual completion in tests.
class FakeRemoteRequest<T> {
  final int id;
  final String query;
  final int page;
  final int pageSize;
  final Completer<List<T>> _completer = Completer<List<T>>();

  FakeRemoteRequest({
    required this.id,
    required this.query,
    required this.page,
    required this.pageSize,
  });

  bool get isCompleted => _completer.isCompleted;

  Future<List<T>> get future => _completer.future;

  void complete(List<T> results) {
    if (!_completer.isCompleted) {
      _completer.complete(results);
    }
  }

  void completeError(Object error) {
    if (!_completer.isCompleted) {
      _completer.completeError(error);
    }
  }
}

/// A fake remote API service that records every call and allows tests to resolve
/// responses in arbitrary order (e.g. out of order, delayed, success, failure, empty).
class FakeRemoteApiService<T> {
  int _nextId = 0;
  final List<FakeRemoteRequest<T>> requests = [];

  Future<List<T>> search(String query) {
    return searchPaginated(query, 1);
  }

  Future<List<T>> searchPaginated(String query, int page, [int pageSize = 20]) {
    final req = FakeRemoteRequest<T>(
      id: ++_nextId,
      query: query,
      page: page,
      pageSize: pageSize,
    );
    requests.add(req);
    return req.future;
  }

  List<FakeRemoteRequest<T>> get pendingRequests =>
      requests.where((r) => !r.isCompleted).toList();

  FakeRemoteRequest<T> lastRequestFor(String query) {
    return requests.lastWhere(
      (r) => r.query == query,
      orElse: () => throw StateError('No request found for query: $query'),
    );
  }

  FakeRemoteRequest<T> requestFor(String query, int page) {
    return requests.lastWhere(
      (r) => r.query == query && r.page == page,
      orElse: () =>
          throw StateError('No request found for query: $query, page: $page'),
    );
  }

  void clear() {
    requests.clear();
  }
}
