import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sale.dart';
import '../repositories/sale_repository.dart';

class GetSalesByDate implements UseCase<List<Sale>, GetSalesByDateParams> {
  final SaleRepository repository;

  GetSalesByDate(this.repository);

  @override
  Future<Either<Failure, List<Sale>>> call(GetSalesByDateParams params) async {
    return await repository.getSalesByDateRange(params.startDate, params.endDate);
  }
}

class GetSalesByDateParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetSalesByDateParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}