import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/database/database_helper.dart';
import 'package:pos_system/features/products/presentation/bloc/product_event.dart';
import 'util.dart';
import 'theme.dart';
import 'injection_container.dart' as di;
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/sales/presentation/bloc/sale_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/sales/presentation/pages/pos_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializar base de datos
    await DatabaseHelper.instance.database;
    debugPrint('Base de datos inicializada correctamente');
  } catch (e) {
    debugPrint('Error inicializando base de datos: $e');
  }
  
  // Inicializar dependencias
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Usar fuentes con manejo de errores
    TextTheme textTheme;
    try {
      textTheme = createTextTheme(context, "Antic", "Antic");
    } catch (e) {
      debugPrint('Error con fuentes personalizadas, usando tema por defecto: $e');
      textTheme = Theme.of(context).textTheme;
    }
    
    MaterialTheme theme = MaterialTheme(textTheme);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => di.sl<ProductBloc>()..add(GetAllProductsEvent()),
        ),
        BlocProvider<SaleBloc>(
          create: (_) => di.sl<SaleBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Punto de Venta',
        debugShowCheckedModeBanner: false,
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: const PosPage(),
      ),
    );
  }
}