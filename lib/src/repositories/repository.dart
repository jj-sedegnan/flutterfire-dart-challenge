import '../models/entity.dart';

/// Generic interface defining the contract for a CRUD repository.
///
/// [T] must implement [Entity] so that each item has a unique identifier.
abstract interface class Repository<T extends Entity> {
  /// Adds a new item to the repository.
  /// Throws [DuplicateEntityException] if an item with the same ID already exists.
  void add(T item);

  /// Retrieves an item by its unique identifier.
  /// Throws [EntityNotFoundException] if no item matches the given ID.
  T getById(String id);

  /// Returns a list of all items currently stored.
  List<T> getAll();

  /// Updates an existing item in the repository.
  /// Throws [EntityNotFoundException] if the item does not exist.
  void update(T item);

  /// Deletes an item by its unique identifier.
  /// Throws [EntityNotFoundException] if the item does not exist.
  void delete(String id);

  /// Returns items that satisfy the provided [predicate].
  List<T> filter(bool Function(T item) predicate);

  /// Returns the total number of items stored.
  int count();

  /// Checks whether an item with [id] exists.
  bool exists(String id);
}
