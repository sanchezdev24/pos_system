import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetAllProductsEvent extends ProductEvent {}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class AddProductEvent extends ProductEvent {
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? barcode;
  final String? category;

  const AddProductEvent({
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.barcode,
    this.category,
  });

  @override
  List<Object?> get props => [name, description, price, stock, barcode, category];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class GetProductByBarcodeEvent extends ProductEvent {
  final String barcode;

  const GetProductByBarcodeEvent({required this.barcode});

  @override
  List<Object> get props => [barcode];
}