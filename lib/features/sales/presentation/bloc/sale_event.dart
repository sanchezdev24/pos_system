import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

class CreateSaleEvent extends SaleEvent {
  final List<CartItem> cartItems;
  final double subtotal;
  final double tax;
  final double total;

  const CreateSaleEvent({
    required this.cartItems,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  List<Object> get props => [cartItems, subtotal, tax, total];
}

class GetAllSalesEvent extends SaleEvent {}

class GetSalesByDateRangeEvent extends SaleEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetSalesByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

class GetSaleByIdEvent extends SaleEvent {
  final String saleId;

  const GetSaleByIdEvent({required this.saleId});

  @override
  List<Object> get props => [saleId];
}