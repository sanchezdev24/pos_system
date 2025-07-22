import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? barcode;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.barcode,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isInStock => stock > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        stock,
        barcode,
        category,
        createdAt,
        updatedAt,
      ];
}