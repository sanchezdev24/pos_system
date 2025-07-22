import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/features/cart/presentation/bloc/cart_event.dart';
import 'package:pos_system/features/cart/presentation/bloc/cart_state.dart';
import 'package:pos_system/features/cart/presentation/widgets/cart_widget.dart';
import 'package:pos_system/features/products/presentation/bloc/product_event.dart';
import 'package:pos_system/features/products/presentation/bloc/product_state.dart';
import 'package:pos_system/features/sales/presentation/bloc/sale_event.dart';
import 'package:pos_system/features/sales/presentation/bloc/sale_state.dart';
import '../../../../shared/utils/formatters.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/sale_bloc.dart';
import '../widgets/product_grid_widget.dart';
import 'sales_history_page.dart';
import 'receipt_page.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    context.read<ProductBloc>().add(SearchProductsEvent(query: query));
  }

  void _searchByBarcode(String barcode) {
    if (barcode.isNotEmpty) {
      context.read<ProductBloc>().add(GetProductByBarcodeEvent(barcode: barcode));
    }
  }

  void _processSale() {
    final cartState = context.read<CartBloc>().state;
    
    if (cartState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<SaleBloc>().add(CreateSaleEvent(
      cartItems: cartState.items,
      subtotal: cartState.subtotal,
      tax: cartState.tax,
      total: cartState.total,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductsPage()),
              );
            },
            tooltip: 'Gestionar Productos',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SalesHistoryPage()),
              );
            },
            tooltip: 'Historial de Ventas',
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoaded && state.product != null) {
                // Producto encontrado por código de barras
                context.read<CartBloc>().add(AddToCartEvent(product: state.product!));
                _barcodeController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.product!.name} agregado al carrito'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ProductLoaded && state.product == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto no encontrado'),
                    backgroundColor: Colors.red,
                  ),
                );
                _barcodeController.clear();
              }
            },
          ),
          BlocListener<SaleBloc, SaleState>(
            listener: (context, state) {
              if (state is SaleCreated) {
                // Venta exitosa
                context.read<CartBloc>().add(ClearCartEvent());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReceiptPage(saleId: state.saleId),
                  ),
                );
              } else if (state is SaleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Row(
          children: [
            // Panel izquierdo - Productos
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  // Barra de búsqueda
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _searchController,
                          hint: 'Buscar productos...',
                          prefixIcon: const Icon(Icons.search),
                          onChanged: _searchProducts,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _searchProducts('');
                                  },
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _barcodeController,
                          hint: 'Escanear código de barras...',
                          prefixIcon: const Icon(Icons.qr_code_scanner),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length >= 8) {
                              _searchByBarcode(value);
                            }
                          },
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () => _searchByBarcode(_barcodeController.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista de productos
                  const Expanded(
                    child: ProductGridWidget(),
                  ),
                ],
              ),
            ),
            // Panel derecho - Carrito
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Carrito
                    const Expanded(
                      child: CartWidget(),
                    ),
                    // Botón de procesar venta
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal:',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            Formatters.formatCurrency(cartState.subtotal),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'IVA (16%):',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            Formatters.formatCurrency(cartState.tax),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total:',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            Formatters.formatCurrency(cartState.total),
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<SaleBloc, SaleState>(
                            builder: (context, saleState) {
                              return BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      text: 'PROCESAR VENTA',
                                      icon: Icons.point_of_sale,
                                      isLoading: saleState is SaleLoading,
                                      onPressed: cartState.isNotEmpty ? _processSale : null,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}