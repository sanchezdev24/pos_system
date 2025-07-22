import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    final product = Product(
      id: params.id,
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      barcode: params.barcode,
      category: params.category,
      createdAt: params.createdAt,
      updatedAt: DateTime.now(),
    );

    return await repository.updateProduct(product);
  }
}

class UpdateProductParams extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? barcode;
  final String? category;
  final DateTime createdAt;

  const UpdateProductParams({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.barcode,
    this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, price, stock, barcode, category, createdAt];
}