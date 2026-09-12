import 'package:flutterfire_dart_challenge/flutterfire_dart_project.dart';

void main() {
  print('=== Bienvenue dans le Gestionnaire de Produits (NextFlutter Dart Challenge) ===\n');

  // 1. Initialisation du Repository générique
  final Repository<Product> productRepo = InMemoryRepository<Product>();

  // 2. Ajout de produits initiaux
  print('--- 1. Ajout de produits au catalogue ---');
  final p1 = Product(
    id: 'prod-001',
    name: 'MacBook Pro M3',
    price: 1999.99,
    stock: 12,
    category: 'Informatique',
  );
  final p2 = Product(
    id: 'prod-002',
    name: 'Clavier Mécanique RGB',
    price: 89.50,
    stock: 35,
    category: 'Périphériques',
  );
  final p3 = Product(
    id: 'prod-003',
    name: 'Souris Sans Fil Ergonomique',
    price: 49.90,
    stock: 50,
    category: 'Périphériques',
  );

  productRepo.add(p1);
  productRepo.add(p2);
  productRepo.add(p3);
  print('✓ 3 produits ajoutés avec succès.');
  print('Nombre total de produits en stock: ${productRepo.count()}\n');

  // 3. Affichage de la liste complète
  print('--- 2. Liste de tous les produits ---');
  for (final product in productRepo.getAll()) {
    print('  • $product');
  }
  print('');

  // 4. Filtrage générique avec prédicat
  print('--- 3. Filtrage des produits de la catégorie "Périphériques" ---');
  final peripherals = productRepo.filter((p) => p.category == 'Périphériques');
  for (final p in peripherals) {
    print('  → ${p.name} (${p.price}€)');
  }
  print('');

  // 5. Mise à jour d'un produit
  print('--- 4. Mise à jour du stock pour prod-002 ---');
  final updatedP2 = p2.copyWith(stock: 45, price: 79.99);
  productRepo.update(updatedP2);
  print('✓ Nouveau prix et stock : ${productRepo.getById('prod-002')}\n');

  // 6. Gestion des exceptions personnalisées
  print('--- 5. Démonstration de la gestion des exceptions personnalisées ---');

  // Cas A : DuplicateEntityException
  try {
    print('Tentative d\'ajout d\'un produit avec un identifiant déjà existant (prod-001)...');
    productRepo.add(Product(
      id: 'prod-001',
      name: 'Doublon',
      price: 10.0,
      stock: 1,
      category: 'Test',
    ));
  } on DuplicateEntityException catch (e) {
    print('✓ Exception capturée avec succès: $e');
  }

  // Cas B : EntityNotFoundException (Recherche)
  try {
    print('Tentative de recherche d\'un identifiant inexistant (prod-999)...');
    productRepo.getById('prod-999');
  } on EntityNotFoundException catch (e) {
    print('✓ Exception capturée avec succès: $e');
  }

  // Cas C : ValidationException (Validation métier)
  try {
    print('Tentative de création d\'un produit avec prix négatif...');
    Product(
      id: 'prod-004',
      name: 'Produit Invalide',
      price: -25.0,
      stock: 5,
      category: 'Erreur',
    );
  } on ValidationException catch (e) {
    print('✓ Exception capturée avec succès: $e');
  }

  // 7. Suppression d'un produit
  print('\n--- 6. Suppression d\'un produit ---');
  productRepo.delete('prod-003');
  print('✓ Produit prod-003 supprimé. Total restant: ${productRepo.count()}');

  // Suppression impossible
  try {
    productRepo.delete('prod-003');
  } on EntityNotFoundException catch (e) {
    print('✓ Exception capturée lors de la re-suppression: $e');
  }

  print('\n=== Fin de la démonstration avec succès ! ===');
}
