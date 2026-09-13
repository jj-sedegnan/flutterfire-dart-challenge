import 'dart:async';
import '../exceptions/app_exceptions.dart';
import '../models/entity.dart';
import 'repository.dart';

/// In-memory generic implementation of [Repository].
///
/// Stores entities in an internal [Map] and notifies listeners via a broadcast [Stream].
class InMemoryRepository<T extends Entity> implements Repository<T> {
  final Map<String, T> _storage = {};
  final StreamController<List<T>> _streamController = StreamController<List<T>>.broadcast();

  void _notifyListeners() {
    if (!_streamController.isClosed) {
      _streamController.add(getAll());
    }
  }

  @override
  void add(T item) {
    if (_storage.containsKey(item.id)) {
      throw DuplicateEntityException(item.id);
    }
    _storage[item.id] = item;
    _notifyListeners();
  }

  @override
  T getById(String id) {
    final item = _storage[id];
    if (item == null) {
      throw EntityNotFoundException(id);
    }
    return item;
  }

  @override
  List<T> getAll() => List.unmodifiable(_storage.values);

  @override
  void update(T item) {
    if (!_storage.containsKey(item.id)) {
      throw EntityNotFoundException(item.id);
    }
    _storage[item.id] = item;
    _notifyListeners();
  }

  @override
  void delete(String id) {
    if (!_storage.containsKey(id)) {
      throw EntityNotFoundException(id);
    }
    _storage.remove(id);
    _notifyListeners();
  }

  @override
  List<T> filter(bool Function(T item) predicate) {
    return _storage.values.where(predicate).toList();
  }

  @override
  int count() => _storage.length;

  @override
  bool exists(String id) => _storage.containsKey(id);

  @override
  Stream<List<T>> watchAll() => _streamController.stream;

  /// Clears all stored entities.
  void clear() {
    _storage.clear();
    _notifyListeners();
  }

  /// Closes the underlying stream controller when disposing the repository.
  void dispose() {
    _streamController.close();
  }
}
