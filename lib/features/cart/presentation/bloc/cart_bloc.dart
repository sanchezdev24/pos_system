import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<CalculateCartTotalsEvent>(_onCalculateCartTotals);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    List<CartItem> updatedItems = List.from(state.items);

    if (existingItemIndex >= 0) {
      // Si el producto ya existe, actualizar la cantidad
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      // Si es un producto nuevo, agregarlo al carrito
      updatedItems.add(CartItem(
        product: event.product,
        quantity: event.quantity,
      ));
    }

    final newState = state.copyWith(items: updatedItems);
    emit(newState);
    add(CalculateCartTotalsEvent());
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items
        .where((item) => item.product.id != event.productId)
        .toList();

    final newState = state.copyWith(items: updatedItems);
    emit(newState);
    add(CalculateCartTotalsEvent());
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCartEvent(productId: event.productId));
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    final newState = state.copyWith(items: updatedItems);
    emit(newState);
    add(CalculateCartTotalsEvent());
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  void _onCalculateCartTotals(CalculateCartTotalsEvent event, Emitter<CartState> emit) {
    double subtotal = 0.0;

    for (final item in state.items) {
      subtotal += item.totalPrice;
    }

    final tax = subtotal * AppConstants.taxRate;
    final total = subtotal + tax;

    emit(state.copyWith(
      subtotal: subtotal,
      tax: tax,
      total: total,
    ));
  }
}