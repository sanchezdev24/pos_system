import 'package:equatable/equatable.dart';
import '../../domain/entities/sale.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object?> get props => [];
}

class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleCreated extends SaleState {
  final String saleId;

  const SaleCreated({required this.saleId});

  @override
  List<Object> get props => [saleId];
}

class SalesLoaded extends SaleState {
  final List<Sale> sales;

  const SalesLoaded({required this.sales});

  @override
  List<Object> get props => [sales];
}

class SaleLoaded extends SaleState {
  final Sale? sale;

  const SaleLoaded({this.sale});

  @override
  List<Object?> get props => [sale];
}

class SaleError extends SaleState {
  final String message;

  const SaleError({required this.message});

  @override
  List<Object> get props => [message];
}