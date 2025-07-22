import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSaleById implements UseCase<Sale?, GetSaleByIdParams> {
  final SaleRepository repository;

  GetSaleById(this.repository);

  @override
  Future<Either<Failure, Sale?>> call(GetSaleByIdParams params) async {
    return await repository.getSaleById(params.id);
  }
}

class GetSaleByIdParams extends Equatable {
  final String id;

  const GetSaleByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}