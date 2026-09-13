# FlutterFire Summer Camp 2026 - Dart & Flutter Generic Repository Challenge

[![Dart & Flutter CI](https://github.com/jj-sedegnan/flutterfire-dart-challenge/actions/workflows/ci.yml/badge.svg)](https://github.com/jj-sedegnan/flutterfire-dart-challenge/actions/workflows/ci.yml)
![Tests](https://img.shields.io/badge/Tests-17%20passed-success)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)

Projet complet **Dart & Flutter (Material 3)** implémentant le pattern **Repository générique**, la gestion d'erreurs avancée avec des **exceptions personnalisées**, la programmation réactive (**Streams broadcast**), la sérialisation **JSON**, une interface graphique interactive complète, et une suite de **17 tests automatisés** (unitaires et de widgets).

Développé pour la certification **NextFlutter (FlutterFire Summer Camp 2026)**.

---

## Fonctionnalités & Respect des critères

| Critère d'évaluation | Implémentation dans le projet |
| :--- | :--- |
| **Au moins une interface** | `abstract interface class Repository<T>` et contrat de base `abstract class Entity` |
| **Utilisation des génériques** | `Repository<T extends Entity>` & `InMemoryRepository<T>` avec typage fort |
| **Exceptions personnalisées** | Hiérarchie : `AppException`, `EntityNotFoundException`, `DuplicateEntityException`, `ValidationException` |
| **Au moins 5 tests unitaires** | **17 tests automatisés validés** (15 tests unitaires + 2 tests de composants/widgets) |
| **Interface Graphique & Menus** | Application Flutter Material 3 avec **Navigation Drawer**, Catalogue réactif, Bac à sable d'exceptions et Statistiques |
| **Dépôt GitHub public avec README** | Dépôt public avec CI GitHub Actions et documentation complète |

---

## Structure du Projet

```
.
├── .github/workflows/
│   └── ci.yml                            # Pipeline CI GitHub Actions (Analyse, Tests, Build)
├── analysis_options.yaml                 # Règles de linter strictes (Flutter & Dart)
├── bin/
│   └── main.dart                         # Démonstration en ligne de commande (CLI)
├── lib/
│   ├── flutterfire_dart_project.dart     # Export principal de la librairie
│   ├── main.dart                         # Application graphique Flutter (Material 3)
│   └── src/
│       ├── exceptions/
│       │   └── app_exceptions.dart       # Hiérarchie des exceptions personnalisées
│       ├── models/
│       │   ├── entity.dart               # Contrat Entity avec identifiant unique
│       │   └── product.dart              # Modèle Product avec validation métier et JSON
│       └── repositories/
│           ├── in_memory_repository.dart # Implémentation générique avec Streams réactifs
│           └── repository.dart           # Interface générique CRUD & Stream
├── pubspec.yaml                          # Dépendances Flutter & packages
├── README.md                             # Documentation officielle du projet
└── test/
    ├── repository_test.dart              # 15 tests unitaires (CRUD, Exceptions, Streams, JSON)
    └── widget_test.dart                  # 2 tests de composants et d'interface graphique
```

---

## Installation & Prérequis

- **Flutter SDK** `>= 3.0.0` (ou Dart SDK `>= 3.0.0`)
- **Git**

```bash
git clone https://github.com/jj-sedegnan/flutterfire-dart-challenge.git
cd flutterfire-dart-challenge
flutter pub get
```

---

## Utilisation

### 1. Lancer l'interface graphique (GUI)

L'application Flutter peut être lancée sur le Web (Google Chrome) ou en application de bureau native (Linux) :

```bash
# Dans Google Chrome
flutter run -d chrome

# Ou en application de bureau native Linux
flutter run -d linux
```

#### Ce que propose l'interface graphique :
- **Menu Latéral (Navigation Drawer)** :
  - **Catalogue Produits** : Consultation, recherche dynamique, filtrage par catégories (*Informatique*, *Périphériques*, *Accessoires*) et suppression d'articles.
  - **Bac à sable Exceptions** : Déclencheurs interactifs pour tester la levée et la capture de chaque exception personnalisée avec boîte d'alerte et terminal de logs.
  - **Statistiques & Stock** : Calcul en temps réel de la valeur marchande globale et du total des pièces.
  - **Architecture & Tests** : Documentation interactive des concepts POO appliqués.
- **Ajout de Produit** : Bouton d'action flottant `+` avec formulaire validé en direct (détection des prix négatifs, noms vides, doublons).

---

### 2. Lancer la démonstration en console (CLI)

```bash
dart run bin/main.dart
```

---

### 3. Exécuter la suite de tests automatisés

```bash
# Exécution de l'ensemble des 17 tests (unitaires + widgets)
flutter test

# Avec rapport détaillé par test
flutter test --reporter expanded
```

---

## Détails de Conception & POO

### 1. Interface Générique `Repository<T extends Entity>`
Le contrat garantit une abstraction totale de la couche de stockage :
- `void add(T item)` : Ajout d'une entité (lève `DuplicateEntityException` si l'ID existe déjà).
- `T getById(String id)` : Récupération par ID (lève `EntityNotFoundException` si l'élément n'existe pas).
- `List<T> getAll()` : Liste immuable des éléments stockés.
- `void update(T item)` : Mise à jour (lève `EntityNotFoundException` si non trouvé).
- `void delete(String id)` : Suppression (lève `EntityNotFoundException` si non trouvé).
- `List<T> filter(bool Function(T item) predicate)` : Filtrage par prédicat d'ordre supérieur.
- `Stream<List<T>> watchAll()` : Flux réactif notifiant les abonnés à chaque modification.

### 2. Gestion des Exceptions Personnalisées
- `AppException` : Classe de base abstraite implémentant `Exception`.
- `EntityNotFoundException` : Levée lors d'une tentative d'accès ou modification d'une entité inexistante.
- `DuplicateEntityException` : Protège contre l'écrasement involontaire lors de l'insertion.
- `ValidationException` : Contrôle de cohérence métier à l'instanciation (prix positif, nom requis, stock >= 0).

### 3. Intégration Continue (CI)
Le workflow GitHub Actions vérifie automatiquement :
- L'analyse statique stricte (`flutter analyze` sans avertissement)
- L'exécution de 100% des tests (`flutter test`)
- L'exécution sans erreur du script CLI (`dart run bin/main.dart`)
