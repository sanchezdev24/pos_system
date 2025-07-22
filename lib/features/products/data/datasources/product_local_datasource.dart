import 'package:pos_system/core/errors/failures.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(String id);
  Future<ProductModel?> getProductByBarcode(String barcode);
  Future<String> insertProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProductLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'products',
        orderBy: 'name ASC',
      );
      return List.generate(maps.length, (i) => ProductModel.fromJson(maps[i]));
    } catch (e) {
      throw DatabaseFailure('Error al obtener productos: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return ProductModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseFailure('Error al obtener producto: $e');
    }
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'products',
        where: 'barcode = ?',
        whereArgs: [barcode],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return ProductModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw DatabaseFailure('Error al buscar producto por código: $e');
    }
  }

  @override
  Future<String> insertProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      await db.insert(
        'products',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return product.id;
    } catch (e) {
      throw DatabaseFailure('Error al insertar producto: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'products',
        product.toJson(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw DatabaseFailure('Error al actualizar producto: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseFailure('Error al eliminar producto: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'products',
        where: 'name LIKE ? OR description LIKE ? OR barcode LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'name ASC',
      );
      return List.generate(maps.length, (i) => ProductModel.fromJson(maps[i]));
    } catch (e) {
      throw DatabaseFailure('Error al buscar productos: $e');
    }
  }
}