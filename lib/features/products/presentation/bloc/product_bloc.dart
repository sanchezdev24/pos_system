import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_product_by_barcode.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final SearchProducts searchProducts;
  final GetProductByBarcode getProductByBarcode;

  ProductBloc({
    required this.getAllProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProducts,
    required this.getProductByBarcode,
  }) : super(ProductInitial()) {
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<GetProductByBarcodeEvent>(_onGetProductByBarcode);
  }

  Future<void> _onGetAllProducts(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await getAllProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await searchProducts(SearchProductsParams(query: event.query));
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (products) => emit(ProductsLoaded(products: products)),
    );
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await addProduct(AddProductParams(
      name: event.name,
      description: event.description,
      price: event.price,
      stock: event.stock,
      barcode: event.barcode,
      category: event.category,
    ));
    
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (productId) {
        emit(const ProductOperationSuccess(message: 'Producto agregado exitosamente'));
        add(GetAllProductsEvent());
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await updateProduct(UpdateProductParams(
      id: event.product.id,
      name: event.product.name,
      description: event.product.description,
      price: event.product.price,
      stock: event.product.stock,
      barcode: event.product.barcode,
      category: event.product.category,
      createdAt: event.product.createdAt,
    ));
    
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (_) {
        emit(const ProductOperationSuccess(message: 'Producto actualizado exitosamente'));
        add(GetAllProductsEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await deleteProduct(DeleteProductParams(id: event.productId));
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (_) {
        emit(const ProductOperationSuccess(message: 'Producto eliminado exitosamente'));
        add(GetAllProductsEvent());
      },
    );
  }

  Future<void> _onGetProductByBarcode(
    GetProductByBarcodeEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await getProductByBarcode(GetProductByBarcodeParams(barcode: event.barcode));
    result.fold(
      (failure) => emit(ProductError(message: failure.message)),
      (product) => emit(ProductLoaded(product: product)),
    );
  }
}