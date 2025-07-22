import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/sale.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_local_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleLocalDataSource localDataSource;

  SaleRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String>> createSale(Sale sale) async {
    try {
      final saleModel = SaleModel.fromEntity(sale);
      final id = await localDataSource.insertSale(saleModel);
      return Right(id);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Sale>>> getAllSales() async {
    try {
      final sales = await localDataSource.getAllSales();
      return Right(sales);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Sale>>> getSalesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final sales = await localDataSource.getSalesByDateRange(startDate, endDate);
      return Right(sales);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Sale?>> getSaleById(String id) async {
    try {
      final sale = await localDataSource.getSaleById(id);
      return Right(sale);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Error inesperado: $e'));
    }
  }
}