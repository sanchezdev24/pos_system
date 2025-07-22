import 'package:pos_system/core/errors/failures.dart';
import '../../../../core/database/database_helper.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';

abstract class SaleLocalDataSource {
  Future<String> insertSale(SaleModel sale);
  Future<List<SaleModel>> getAllSales();
  Future<List<SaleModel>> getSalesByDateRange(DateTime startDate, DateTime endDate);
  Future<SaleModel?> getSaleById(String id);
}

class SaleLocalDataSourceImpl implements SaleLocalDataSource {
  final DatabaseHelper databaseHelper;

  SaleLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertSale(SaleModel sale) async {
    try {
      final db = await databaseHelper.database;
      
      await db.transaction((txn) async {
        // Insertar la venta
        await txn.insert('sales', sale.toJson());
        
        // Insertar los items de la venta
        for (final item in sale.items) {
          final saleItemModel = SaleItemModel.fromEntity(item);
          await txn.insert('sale_items', saleItemModel.toJson());
        }
        
        // Actualizar el stock de los productos
        for (final item in sale.items) {
          await txn.rawUpdate(
            'UPDATE products SET stock = stock - ? WHERE id = ?',
            [item.quantity, item.productId],
          );
        }
      });
      
      return sale.id;
    } catch (e) {
      throw DatabaseFailure('Error al crear venta: $e');
    }
  }

  @override
  Future<List<SaleModel>> getAllSales() async {
    try {
      final db = await databaseHelper.database;
      
      final salesMaps = await db.query(
        'sales',
        orderBy: 'created_at DESC',
      );
      
      List<SaleModel> sales = [];
      
      for (final saleMap in salesMaps) {
        final itemsMaps = await db.query(
          'sale_items',
          where: 'sale_id = ?',
          whereArgs: [saleMap['id']],
        );
        
        final items = itemsMaps.map((itemMap) => SaleItemModel.fromJson(itemMap)).toList();
        sales.add(SaleModel.fromJson(saleMap, items));
      }
      
      return sales;
    } catch (e) {
      throw DatabaseFailure('Error al obtener ventas: $e');
    }
  }

  @override
  Future<List<SaleModel>> getSalesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final db = await databaseHelper.database;
      
      final salesMaps = await db.query(
        'sales',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
        orderBy: 'created_at DESC',
      );
      
      List<SaleModel> sales = [];
      
      for (final saleMap in salesMaps) {
        final itemsMaps = await db.query(
          'sale_items',
          where: 'sale_id = ?',
          whereArgs: [saleMap['id']],
        );
        
        final items = itemsMaps.map((itemMap) => SaleItemModel.fromJson(itemMap)).toList();
        sales.add(SaleModel.fromJson(saleMap, items));
      }
      
      return sales;
    } catch (e) {
      throw DatabaseFailure('Error al obtener ventas por fecha: $e');
    }
  }

  @override
  Future<SaleModel?> getSaleById(String id) async {
    try {
      final db = await databaseHelper.database;
      
      final salesMaps = await db.query(
        'sales',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      
      if (salesMaps.isEmpty) {
        return null;
      }
      
      final saleMap = salesMaps.first;
      final itemsMaps = await db.query(
        'sale_items',
        where: 'sale_id = ?',
        whereArgs: [id],
      );
      
      final items = itemsMaps.map((itemMap) => SaleItemModel.fromJson(itemMap)).toList();
      return SaleModel.fromJson(saleMap, items);
    } catch (e) {
      throw DatabaseFailure('Error al obtener venta por ID: $e');
    }
  }
}