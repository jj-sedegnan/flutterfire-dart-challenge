import 'package:flutterfire_dart_challenge/flutterfire_dart_project.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryRepository Tests', () {
    late InMemoryRepository<Product> repository;
    late Product sampleProduct1;
    late Product sampleProduct2;

    setUp(() {
      repository = InMemoryRepository<Product>();
      sampleProduct1 = Product(
        id: 'p-1',
        name: 'Laptop',
        price: 1200.0,
        stock: 5,
        category: 'Electronics',
      );
      sampleProduct2 = Product(
        id: 'p-2',
        name: 'Mouse',
        price: 25.0,
        stock: 20,
        category: 'Accessories',
      );
    });

    test('1. add and getById retrieves stored item successfully', () {
      repository.add(sampleProduct1);

      final retrieved = repository.getById('p-1');
      expect(retrieved, equals(sampleProduct1));
      expect(retrieved.name, equals('Laptop'));
      expect(repository.count(), equals(1));
      expect(repository.exists('p-1'), isTrue);
    });

    test('2. getAll returns all stored items', () {
      repository.add(sampleProduct1);
      repository.add(sampleProduct2);

      final all = repository.getAll();
      expect(all.length, equals(2));
      expect(all, containsAll([sampleProduct1, sampleProduct2]));
    });

    test('3. add throws DuplicateEntityException on duplicate id', () {
      repository.add(sampleProduct1);

      final duplicate = Product(
        id: 'p-1',
        name: 'Another Laptop',
        price: 999.0,
        stock: 2,
        category: 'Electronics',
      );

      expect(
        () => repository.add(duplicate),
        throwsA(isA<DuplicateEntityException>().having(
          (e) => e.id,
          'id',
          equals('p-1'),
        )),
      );
    });

    test('4. getById throws EntityNotFoundException when id is missing', () {
      expect(
        () => repository.getById('non-existent-id'),
        throwsA(isA<EntityNotFoundException>().having(
          (e) => e.id,
          'id',
          equals('non-existent-id'),
        )),
      );
    });

    test('5. update modifies existing item successfully', () {
      repository.add(sampleProduct1);

      final updated = sampleProduct1.copyWith(price: 1099.99, stock: 8);
      repository.update(updated);

      final retrieved = repository.getById('p-1');
      expect(retrieved.price, equals(1099.99));
      expect(retrieved.stock, equals(8));
    });

    test('6. update throws EntityNotFoundException for unknown item', () {
      expect(
        () => repository.update(sampleProduct1),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('7. delete removes an existing item', () {
      repository.add(sampleProduct1);
      expect(repository.exists('p-1'), isTrue);

      repository.delete('p-1');
      expect(repository.exists('p-1'), isFalse);
      expect(repository.count(), equals(0));
    });

    test('8. delete throws EntityNotFoundException for unknown id', () {
      expect(
        () => repository.delete('unknown-id'),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('9. filter returns matching items based on predicate', () {
      repository.add(sampleProduct1);
      repository.add(sampleProduct2);

      final accessories = repository.filter((p) => p.category == 'Accessories');
      expect(accessories.length, equals(1));
      expect(accessories.first.id, equals('p-2'));

      final expensive = repository.filter((p) => p.price > 100);
      expect(expensive.length, equals(1));
      expect(expensive.first.name, equals('Laptop'));
    });

    test('10. clear removes all stored items', () {
      repository.add(sampleProduct1);
      repository.add(sampleProduct2);
      expect(repository.count(), equals(2));

      repository.clear();
      expect(repository.count(), equals(0));
      expect(repository.getAll(), isEmpty);
    });
  });

  group('Product Validation Tests', () {
    test('11. throws ValidationException when id or name is empty', () {
      expect(
        () => Product(
          id: '',
          name: 'Valid Name',
          price: 10.0,
          stock: 1,
          category: 'Category',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.field,
          'field',
          equals('id'),
        )),
      );

      expect(
        () => Product(
          id: 'valid-id',
          name: '   ',
          price: 10.0,
          stock: 1,
          category: 'Category',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.field,
          'field',
          equals('name'),
        )),
      );
    });

    test('12. throws ValidationException when price or stock is negative', () {
      expect(
        () => Product(
          id: 'p-invalid-price',
          name: 'Name',
          price: -5.0,
          stock: 1,
          category: 'Category',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.field,
          'field',
          equals('price'),
        )),
      );

      expect(
        () => Product(
          id: 'p-invalid-stock',
          name: 'Name',
          price: 15.0,
          stock: -1,
          category: 'Category',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.field,
          'field',
          equals('stock'),
        )),
      );
    });

    test('13. fromJson and toJson serialization roundtrip', () {
      final product = Product(
        id: 'json-1',
        name: 'Clavier Bluetooth',
        price: 49.99,
        stock: 10,
        category: 'Accessoires',
      );

      final json = product.toJson();
      expect(json['id'], equals('json-1'));
      expect(json['name'], equals('Clavier Bluetooth'));
      expect(json['price'], equals(49.99));
      expect(json['stock'], equals(10));
      expect(json['category'], equals('Accessoires'));

      final parsed = Product.fromJson(json);
      expect(parsed, equals(product));
    });

    test('14. fromJson triggers ValidationException on invalid values', () {
      expect(
        () => Product.fromJson({
          'id': 'err-1',
          'name': '',
          'price': 10.0,
          'stock': 5,
        }),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('Reactive Stream Tests', () {
    test('15. watchAll emits updated product list on add and delete', () async {
      final repository = InMemoryRepository<Product>();
      final emissions = <List<Product>>[];

      final sub = repository.watchAll().listen(emissions.add);

      final p1 = Product(
        id: 'stream-1',
        name: 'Stream Item',
        price: 99.0,
        stock: 3,
        category: 'Test',
      );

      repository.add(p1);
      // Allow microtask/stream event delivery
      await Future<void>.delayed(Duration.zero);

      expect(emissions.length, equals(1));
      expect(emissions.first.length, equals(1));
      expect(emissions.first.first.id, equals('stream-1'));

      repository.delete('stream-1');
      await Future<void>.delayed(Duration.zero);

      expect(emissions.length, equals(2));
      expect(emissions.last, isEmpty);

      await sub.cancel();
      repository.dispose();
    });
  });
}
