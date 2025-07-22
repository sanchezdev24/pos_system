import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProduct implements UseCase<String, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, String>> call(AddProductParams params) async {
    final product = Product(
      id: const Uuid().v4(),
      name: params.name,
      description: params.description,
      price: params.price,
      stock: params.stock,
      barcode: params.barcode,
      category: params.category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await repository.addProduct(product);
  }
}

class AddProductParams extends Equatable {
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? barcode;
  final String? category;

  const AddProductParams({
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