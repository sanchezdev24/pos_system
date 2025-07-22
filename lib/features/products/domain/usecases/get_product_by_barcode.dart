import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByBarcode implements UseCase<Product?, GetProductByBarcodeParams> {
  final ProductRepository repository;

  GetProductByBarcode(this.repository);

  @override
  Future<Either<Failure, Product?>> call(GetProductByBarcodeParams params) async {
    return await repository.getProductByBarcode(params.barcode);
  }
}

class GetProductByBarcodeParams extends Equatable {
  final String barcode;

  const GetProductByBarcodeParams({required this.barcode});

  @override
  List<Object> get props => [barcode];
}