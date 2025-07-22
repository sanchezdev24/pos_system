import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pos_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await _onCreate(db, version);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de productos
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        barcode TEXT,
        category TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabla de ventas
    await db.execute('''
      CREATE TABLE sales(
        id TEXT PRIMARY KEY,
        total REAL NOT NULL,
        subtotal REAL NOT NULL,
        tax REAL NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla de items de venta
    await db.execute('''
      CREATE TABLE sale_items(
        id TEXT PRIMARY KEY,
        sale_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES sales (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // Insertar productos de ejemplo
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final products = [
      {
        'id': 'prod-001',
        'name': 'Coca Cola 600ml',
        'description': 'Refresco de cola',
        'price': 25.0,
        'stock': 50,
        'barcode': '7501055304081',
        'category': 'Bebidas',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod-002',
        'name': 'Pan Bimbo Blanco',
        'description': 'Pan de caja blanco',
        'price': 35.0,
        'stock': 20,
        'barcode': '7501000100001',
        'category': 'Panadería',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod-003',
        'name': 'Leche Lala 1L',
        'description': 'Leche entera',
        'price': 28.0,
        'stock': 30,
        'barcode': '7501055301081',
        'category': 'Lácteos',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod-004',
        'name': 'Galletas Oreo',
        'description': 'Galletas de chocolate',
        'price': 22.0,
        'stock': 40,
        'barcode': '7622210522009',
        'category': 'Snacks',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'prod-005',
        'name': 'Arroz Verde Valle 1kg',
        'description': 'Arroz blanco',
        'price': 45.0,
        'stock': 15,
        'barcode': '7501234567890',
        'category': 'Despensa',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var product in products) {
      await db.insert('products', product);
    }
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}