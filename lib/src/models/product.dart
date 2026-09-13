import '../exceptions/app_exceptions.dart';
import 'entity.dart';

/// Represents a product in the inventory.
class Product implements Entity {
  @override
  final String id;
  final String name;
  final double price;
  final int stock;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
  }) {
    if (id.trim().isEmpty) {
      throw const ValidationException(
        field: 'id',
        reason: "L'identifiant ne peut pas être vide.",
      );
    }
    if (name.trim().isEmpty) {
      throw const ValidationException(
        field: 'name',
        reason: 'Le nom du produit ne peut pas être vide.',
      );
    }
    if (price < 0) {
      throw const ValidationException(
        field: 'price',
        reason: 'Le prix ne peut pas être négatif.',
      );
    }
    if (stock < 0) {
      throw const ValidationException(
        field: 'stock',
        reason: 'La quantité en stock ne peut pas être négative.',
      );
    }
  }

  Product copyWith({
    String? name,
    double? price,
    int? stock,
    String? category,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
    );
  }

  /// Creates a [Product] from a JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? -1.0,
      stock: (json['stock'] as num?)?.toInt() ?? -1,
      category: json['category'] as String? ?? 'Général',
    );
  }

  /// Converts this [Product] into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
    };
  }

  @override
  String toString() =>
      'Product(id: $id, name: "$name", price: ${price.toStringAsFixed(2)}€, stock: $stock, category: "$category")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          stock == other.stock &&
          category == other.category;

  @override
  int get hashCode => Object.hash(id, name, price, stock, category);
}
