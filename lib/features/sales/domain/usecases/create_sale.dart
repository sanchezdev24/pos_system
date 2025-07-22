import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sale.dart';
import '../entities/sale_item.dart';
import '../repositories/sale_repository.dart';
import '../../../cart/domain/entities/cart_item.dart';

class CreateSale implements UseCase<String, CreateSaleParams> {
  final SaleRepository repository;

  CreateSale(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateSaleParams params) async {
    final saleId = const Uuid().v4();
    
    final saleItems = params.cartItems.map((cartItem) {
      return SaleItem(
        id: const Uuid().v4(),
        saleId: saleId,
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        quantity: cartItem.quantity,
        unitPrice: cartItem.product.price,
        totalPrice: cartItem.totalPrice,
      );
    }).toList();

    final sale = Sale(
      id: saleId,
      items: saleItems,
      total: params.total,
      subtotal: params.subtotal,
      tax: params.tax,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    return await repository.createSale(sale);
  }
}

class CreateSaleParams extends Equatable {
  final List<CartItem> cartItems;
  final double subtotal;
  final double tax;
  final double total;

  const CreateSaleParams({
    required this.cartItems,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  List<Object> get props => [cartItems, subtotal, tax, total];
}