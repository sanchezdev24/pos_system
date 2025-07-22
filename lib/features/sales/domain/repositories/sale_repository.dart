import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sale.dart';

abstract class SaleRepository {
  Future<Either<Failure, String>> createSale(Sale sale);
  Future<Either<Failure, List<Sale>>> getAllSales();
  Future<Either<Failure, List<Sale>>> getSalesByDateRange(DateTime startDate, DateTime endDate);
  Future<Either<Failure, Sale?>> getSaleById(String id);
}