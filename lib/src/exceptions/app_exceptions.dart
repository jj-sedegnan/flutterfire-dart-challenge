/// Base exception class for all application errors.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when an entity with a specific identifier cannot be found.
class EntityNotFoundException extends AppException {
  final String id;
  const EntityNotFoundException(this.id)
      : super("L'élément avec l'identifiant '$id' est introuvable.");
}

/// Thrown when attempting to add an entity whose identifier already exists.
class DuplicateEntityException extends AppException {
  final String id;
  const DuplicateEntityException(this.id)
      : super("Un élément avec l'identifiant '$id' existe déjà.");
}

/// Thrown when entity data fails domain validation rules.
class ValidationException extends AppException {
  final String field;
  const ValidationException({required this.field, required String reason})
      : super("Erreur de validation sur le champ '$field': $reason");
}
