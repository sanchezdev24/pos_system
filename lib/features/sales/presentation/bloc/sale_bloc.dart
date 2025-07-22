import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_sale.dart';
import '../../domain/usecases/get_sale_by_id.dart';
import '../../domain/usecases/get_sales.dart';
import '../../domain/usecases/get_sales_by_date.dart';
import 'sale_event.dart';
import 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final CreateSale createSale;
  final GetSales getSales;
  final GetSalesByDate getSalesByDate;
  final GetSaleById getSaleById;

  SaleBloc({
    required this.createSale,
    required this.getSales,
    required this.getSalesByDate,
    required this.getSaleById,
  }) : super(SaleInitial()) {
    on<CreateSaleEvent>(_onCreateSale);
    on<GetAllSalesEvent>(_onGetAllSales);
    on<GetSalesByDateRangeEvent>(_onGetSalesByDateRange);
    on<GetSaleByIdEvent>(_onGetSaleById);
  }

  Future<void> _onCreateSale(
    CreateSaleEvent event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());

    final result = await createSale(CreateSaleParams(
      cartItems: event.cartItems,
      subtotal: event.subtotal,
      tax: event.tax,
      total: event.total,
    ));

    result.fold(
      (failure) => emit(SaleError(message: failure.message)),
      (saleId) => emit(SaleCreated(saleId: saleId)),
    );
  }

  Future<void> _onGetAllSales(
    GetAllSalesEvent event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());

    final result = await getSales(NoParams());

    result.fold(
      (failure) => emit(SaleError(message: failure.message)),
      (sales) => emit(SalesLoaded(sales: sales)),
    );
  }

  Future<void> _onGetSalesByDateRange(
    GetSalesByDateRangeEvent event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());

    final result = await getSalesByDate(GetSalesByDateParams(
      startDate: event.startDate,
      endDate: event.endDate,
    ));

    result.fold(
      (failure) => emit(SaleError(message: failure.message)),
      (sales) => emit(SalesLoaded(sales: sales)),
    );
  }

  Future<void> _onGetSaleById(
    GetSaleByIdEvent event,
    Emitter<SaleState> emit,
  ) async {
    emit(SaleLoading());

    final result = await getSaleById(GetSaleByIdParams(id: event.saleId));

    result.fold(
      (failure) => emit(SaleError(message: failure.message)),
      (sale) => emit(SaleLoaded(sale: sale)),
    );
  }
}