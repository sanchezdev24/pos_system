// injection_container.dart
import 'package:get_it/get_it.dart';
import 'core/database/database_helper.dart';

// Product Feature
import 'features/products/data/datasources/product_local_datasource.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/add_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_all_products.dart';
import 'features/products/domain/usecases/get_product_by_barcode.dart';
import 'features/products/domain/usecases/search_products.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/presentation/bloc/product_bloc.dart';

// Sale Feature
import 'features/sales/data/datasources/sale_local_datasource.dart';
import 'features/sales/data/repositories/sale_repository_impl.dart';
import 'features/sales/domain/repositories/sale_repository.dart';
import 'features/sales/domain/usecases/create_sale.dart';
import 'features/sales/domain/usecases/get_sale_by_id.dart';
import 'features/sales/domain/usecases/get_sales.dart';
import 'features/sales/domain/usecases/get_sales_by_date.dart';
import 'features/sales/presentation/bloc/sale_bloc.dart';

// Cart Feature
import 'features/cart/presentation/bloc/cart_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  //! Features - Product
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getAllProducts: sl(),
      addProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      searchProducts: sl(),
      getProductByBarcode: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetProductByBarcode(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(databaseHelper: sl()),
  );

  //! Features - Sale
  // Bloc
  sl.registerFactory(
    () => SaleBloc(
      createSale: sl(),
      getSales: sl(),
      getSalesByDate: sl(),
      getSaleById: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateSale(sl()));
  sl.registerLazySingleton(() => GetSales(sl()));
  sl.registerLazySingleton(() => GetSalesByDate(sl()));
  sl.registerLazySingleton(() => GetSaleById(sl()));

  // Repository
  sl.registerLazySingleton<SaleRepository>(
    () => SaleRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SaleLocalDataSource>(
    () => SaleLocalDataSourceImpl(databaseHelper: sl()),
  );

  //! Features - Cart
  // Bloc
  sl.registerFactory(() => CartBloc());
}