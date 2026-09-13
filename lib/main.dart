import 'package:flutter/material.dart';
import 'flutterfire_dart_project.dart';

void main() {
  runApp(const NextFlutterApp());
}

class NextFlutterApp extends StatelessWidget {
  const NextFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextFlutter Catalogue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade800),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Generic Repository instance
  final Repository<Product> _repository = InMemoryRepository<Product>();
  String _selectedCategory = 'Tous';
  int _selectedDrawerIndex = 0;
  String _searchQuery = '';
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _seedInitialProducts();
  }

  void _seedInitialProducts() {
    _repository.add(Product(
      id: 'prod-001',
      name: 'MacBook Pro M3 Max',
      price: 2499.99,
      stock: 8,
      category: 'Informatique',
    ));
    _repository.add(Product(
      id: 'prod-002',
      name: 'Clavier Mécanique Sans Fil',
      price: 119.50,
      stock: 25,
      category: 'Périphériques',
    ));
    _repository.add(Product(
      id: 'prod-003',
      name: 'Souris Ergonomique MX',
      price: 89.90,
      stock: 40,
      category: 'Périphériques',
    ));
    _repository.add(Product(
      id: 'prod-004',
      name: 'Écran 34" Incurvé 4K',
      price: 649.00,
      stock: 4,
      category: 'Informatique',
    ));
    _repository.add(Product(
      id: 'prod-005',
      name: 'Casque Audio à Réduction de Bruit',
      price: 279.00,
      stock: 15,
      category: 'Accessoires',
    ));
  }

  List<Product> get _filteredProducts {
    return _repository.filter((item) {
      final matchesCategory = _selectedCategory == 'Tous' || item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.id.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    });
  }

  void _addLog(String log) {
    setState(() {
      _logs.insert(0, '[${DateTime.now().toIso8601String().substring(11, 19)}] $log');
      if (_logs.length > 30) _logs.removeLast();
    });
  }

  void _showErrorDialog(String title, AppException exception) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 36),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withAlpha(50)),
              ),
              child: Text(
                exception.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type : ${exception.runtimeType}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String category = 'Informatique';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_shopping_cart, size: 22),
              SizedBox(width: 8),
              Text('Nouveau Produit'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Identifiant (ex: prod-100)',
                    prefixIcon: Icon(Icons.tag, size: 18),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du produit',
                    prefixIcon: Icon(Icons.shopping_bag_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Prix (€)',
                    prefixIcon: Icon(Icons.euro, size: 18),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantité en stock',
                    prefixIcon: Icon(Icons.inventory_2_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    prefixIcon: Icon(Icons.category_outlined, size: 18),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Informatique', child: Text('Informatique')),
                    DropdownMenuItem(value: 'Périphériques', child: Text('Périphériques')),
                    DropdownMenuItem(value: 'Accessoires', child: Text('Accessoires')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                final id = idController.text;
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? -1.0;
                final stock = int.tryParse(stockController.text) ?? -1;

                try {
                  final newProduct = Product(
                    id: id,
                    name: name,
                    price: price,
                    stock: stock,
                    category: category,
                  );

                  _repository.add(newProduct);
                  _addLog('✓ Produit ajouté : ${newProduct.name} (${newProduct.id})');
                  Navigator.of(ctx).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produit ${newProduct.name} ajouté au catalogue.'),
                      backgroundColor: Colors.green.shade700,
                    ),
                  );
                } on AppException catch (e) {
                  _addLog('✗ Échec ajout : $e');
                  _showErrorDialog("Erreur d'ajout", e);
                }
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerDuplicateError() {
    try {
      final existing = _repository.getAll().first;
      _repository.add(Product(
        id: existing.id,
        name: 'Produit Doublon Test',
        price: 99.0,
        stock: 5,
        category: 'Test',
      ));
    } on DuplicateEntityException catch (e) {
      _addLog('⚡ Test DuplicateEntityException capturé: $e');
      _showErrorDialog('DuplicateEntityException Déclenchée', e);
    }
  }

  void _triggerNotFoundError() {
    try {
      _repository.getById('id-fantome-999');
    } on EntityNotFoundException catch (e) {
      _addLog('⚡ Test EntityNotFoundException capturé: $e');
      _showErrorDialog('EntityNotFoundException Déclenchée', e);
    }
  }

  void _triggerValidationError() {
    try {
      Product(
        id: 'prod-err',
        name: 'Produit Prix Négatif',
        price: -50.0,
        stock: 10,
        category: 'Test',
      );
    } on ValidationException catch (e) {
      _addLog('⚡ Test ValidationException capturé: $e');
      _showErrorDialog('ValidationException Déclenchée', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NextFlutter Boutique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Pattern Repository<T> & OOP', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tester DuplicateEntityException',
            icon: const Icon(Icons.copy, color: Colors.amber),
            onPressed: _triggerDuplicateError,
          ),
          IconButton(
            tooltip: 'Tester EntityNotFoundException',
            icon: const Icon(Icons.search_off, color: Colors.orange),
            onPressed: _triggerNotFoundError,
          ),
          IconButton(
            tooltip: 'Tester ValidationException',
            icon: const Icon(Icons.warning_amber, color: Colors.red),
            onPressed: _triggerValidationError,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildCurrentView(theme),
      floatingActionButton: _selectedDrawerIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddProductDialog,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter Produit'),
            )
          : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.inventory_2, color: Color(0xFF007AFF), size: 22),
                ),
                const SizedBox(height: 8),
                const Text(
                  'NextFlutter App',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total stock: ${_repository.count()} articles',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Catalogue Produits'),
            selected: _selectedDrawerIndex == 0,
            onTap: () {
              setState(() => _selectedDrawerIndex = 0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Bac à sable Exceptions'),
            selected: _selectedDrawerIndex == 1,
            onTap: () {
              setState(() => _selectedDrawerIndex = 1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Statistiques & Stock'),
            selected: _selectedDrawerIndex == 2,
            onTap: () {
              setState(() => _selectedDrawerIndex = 2);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Architecture & Tests'),
            selected: _selectedDrawerIndex == 3,
            onTap: () {
              setState(() => _selectedDrawerIndex = 3);
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Filtres rapides', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.devices, size: 20),
            title: const Text('Informatique'),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 0;
                _selectedCategory = 'Informatique';
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.mouse, size: 20),
            title: const Text('Périphériques'),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 0;
                _selectedCategory = 'Périphériques';
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.headphones, size: 20),
            title: const Text('Accessoires'),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 0;
                _selectedCategory = 'Accessoires';
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView(ThemeData theme) {
    switch (_selectedDrawerIndex) {
      case 0:
        return _buildCatalogView(theme);
      case 1:
        return _buildExceptionsSandboxView(theme);
      case 2:
        return _buildStatisticsView(theme);
      case 3:
      default:
        return _buildAboutView(theme);
    }
  }

  Widget _buildCatalogView(ThemeData theme) {
    final products = _filteredProducts;

    return Column(
      children: [
        // Search & Category Chips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(50))),
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit ou ID...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  isDense: true,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Tous', 'Informatique', 'Périphériques', 'Accessoires'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Products List
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text('Aucun produit ne correspond à ces critères', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () => setState(() {
                          _selectedCategory = 'Tous';
                          _searchQuery = '';
                        }),
                        child: const Text('Réinitialiser les filtres'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withAlpha(25),
                              foregroundColor: theme.colorScheme.primary,
                              child: Icon(_getCategoryIcon(p.category)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withAlpha(25),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          p.category,
                                          style: const TextStyle(fontSize: 10, color: Colors.blue),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'ID: ${p.id}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'monospace'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${p.price.toStringAsFixed(2)} €',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Stock: ${p.stock}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: p.stock < 5 ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                              onPressed: () {
                                _repository.delete(p.id);
                                _addLog('Suppression produit: ${p.id}');
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Informatique':
        return Icons.laptop_chromebook;
      case 'Périphériques':
        return Icons.mouse;
      case 'Accessoires':
        return Icons.headphones;
      default:
        return Icons.devices_other;
    }
  }

  Widget _buildExceptionsSandboxView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Bac à sable des Exceptions Métier',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ce panneau permet de tester en direct le déclenchement et la capture des exceptions personnalisées définies dans le projet.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                child: Icon(Icons.copy),
              ),
              title: const Text('DuplicateEntityException'),
              subtitle: const Text("Tente d'ajouter une entité avec un identifiant déjà enregistré."),
              trailing: FilledButton.tonal(
                onPressed: _triggerDuplicateError,
                child: const Text('Tester'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                child: Icon(Icons.search_off),
              ),
              title: const Text('EntityNotFoundException'),
              subtitle: const Text("Tente de lire ou supprimer l'identifiant 'id-fantome-999'."),
              trailing: FilledButton.tonal(
                onPressed: _triggerNotFoundError,
                child: const Text('Tester'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: Icon(Icons.warning_amber),
              ),
              title: const Text('ValidationException'),
              subtitle: const Text("Tente d'instancier un Product avec un prix négatif (-50€)."),
              trailing: FilledButton.tonal(
                onPressed: _triggerValidationError,
                child: const Text('Tester'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Journal des événements récents :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _logs.isEmpty
                ? const Text('Aucun événement pour le moment. Cliquez sur un bouton de test !', style: TextStyle(color: Colors.white70, fontSize: 12))
                : ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (ctx, idx) => Text(
                      _logs[idx],
                      style: const TextStyle(color: Colors.lightGreenAccent, fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsView(ThemeData theme) {
    final all = _repository.getAll();
    final totalStock = all.fold<int>(0, (sum, p) => sum + p.stock);
    final totalValue = all.fold<double>(0.0, (sum, p) => sum + (p.price * p.stock));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Indicateurs du Catalogue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Références', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${all.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  color: Colors.green.withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Pièces', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('$totalStock', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.purple.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valeur Marchande du Stock', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Prix unitaire × Quantité', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  Text('${totalValue.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text('Architecture du Projet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            'Projet développé pour le Bootcamp NextFlutter (FlutterFire Summer Camp 2026).',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Interfaces & Abstractions', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• abstract interface class Repository<T extends Entity>', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                  Text('• abstract class Entity', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2. Génériques', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• InMemoryRepository<T extends Entity> implements Repository<T>', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                  Text('• CRUD générique : add, getById, getAll, update, delete, filter', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3. Exceptions Personnalisées', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• AppException (base)', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                  Text('• EntityNotFoundException', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                  Text('• DuplicateEntityException', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                  Text('• ValidationException', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('4. Tests Unitaires', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('• 12 tests unitaires validés avec package:test', style: TextStyle(fontSize: 12)),
                  Text('• Couverture complète des méthodes et exceptions', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
