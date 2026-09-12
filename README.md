# FlutterFire Summer Camp 2026 - Dart Generic Repository Challenge

Projet Dart moderne implémentant le pattern **Repository générique**, la gestion d'erreurs avec des **exceptions personnalisées**, et une suite complète de **tests unitaires**.

Conçu pour la validation de certification **NextFlutter (FlutterFire Summer Camp 2026)**.

---

## Fonctionnalités & Respect des critères

| Critère exigé | Implémentation dans le projet |
| :--- | :--- |
| **Au moins une interface** | `abstract interface class Repository<T>` et `abstract class Entity` |
| **Utilisation des génériques** | `Repository<T extends Entity>` & `InMemoryRepository<T>` |
| **Exceptions personnalisées** | `AppException`, `EntityNotFoundException`, `DuplicateEntityException`, `ValidationException` |
| **Au moins 5 tests unitaires** | **12 tests unitaires complets** avec le package `test` |
| **Documentation & Exécution** | Instructions complètes ci-dessous pour exécuter l'application et les tests |

---

## Structure du Projet

```
.
├── analysis_options.yaml
├── bin
│   └── main.dart                         # Point d'entrée avec démonstration interactive
├── lib
│   ├── flutterfire_dart_project.dart     # Export principal de la librairie
│   └── src
│       ├── exceptions
│       │   └── app_exceptions.dart       # Hiérarchie des exceptions personnalisées
│       ├── models
│       │   ├── entity.dart               # Contrat Entity avec identifiant unique
│       │   └── product.dart              # Modèle métier Product avec validation
│       └── repositories
│           ├── in_memory_repository.dart # Implémentation générique en mémoire
│           └── repository.dart           # Interface générique CRUD
├── pubspec.yaml
├── README.md
└── test
    └── repository_test.dart              # Suite de tests unitaires
```

---

## Prérequis

- **Dart SDK** : `>= 3.0.0` (ou Flutter SDK avec Dart intégré)

---

## Installation

Clonez le dépôt et récupérez les dépendances :

```bash
git clone https://github.com/jj-sedegnan/flutterfire-dart-challenge.git
cd flutterfire-dart-challenge
dart pub get
```

---

## Exécution

### 1. Lancer l'application de démonstration

Exécutez le point d'entrée `bin/main.dart` :

```bash
dart run bin/main.dart
```

Cette commande démarre une démonstration complète illustrant :
- L'ajout d'entités avec contrôle de doublon
- La récupération et l'affichage des éléments
- Le filtrage par prédicat
- La mise à jour et la suppression
- La capture et le traitement explicite des exceptions personnalisées (`DuplicateEntityException`, `EntityNotFoundException`, `ValidationException`).

---

### 2. Lancer les tests unitaires

Exécutez l'ensemble de la suite de tests :

```bash
dart test
```

Pour afficher le détail de chaque test réussi :

```bash
dart test --reporter expanded
```

---

## Architecture détaillée

### Interface générique `Repository<T extends Entity>`
Définit les méthodes CRUD indépendantes du moyen de stockage :
- `void add(T item)` : Ajoute un élément (lève `DuplicateEntityException` si l'ID existe déjà).
- `T getById(String id)` : Récupère un élément (lève `EntityNotFoundException` s'il n'existe pas).
- `List<T> getAll()` : Retourne la liste immuable de tous les éléments.
- `void update(T item)` : Met à jour un élément existant (lève `EntityNotFoundException` si l'élément n'existe pas).
- `void delete(String id)` : Supprime un élément par son ID (lève `EntityNotFoundException` si l'ID n'existe pas).
- `List<T> filter(bool Function(T item) predicate)` : Filtre selon une condition.
- `int count()` & `bool exists(String id)` : Méthodes utilitaires.

### Exceptions personnalisées
- `AppException` : Classe de base abstraite implémentant `Exception`.
- `EntityNotFoundException` : Levée lors d'un accès ou modification sur une ressource inexistante.
- `DuplicateEntityException` : Levée pour empêcher l'écrasement accidentel lors de l'ajout.
- `ValidationException` : Levée par les modèles métiers si les données fournies violent les règles métier (prix négatif, stock invalide, champ requis manquant).
