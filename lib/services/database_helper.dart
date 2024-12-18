import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  final String tableName = "gastos";

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gastos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      amount REAL,
      date TEXT,
      description TEXT,
      type TEXT,
      category TEXT
      )
    ''');
  }

  // Insertar una nueva transacción
  Future<int> addTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(
      tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las transacciones
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      orderBy: 'date ASC',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  // Obtener transacciones por tipo (Ingreso/Gasto)
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    final db = await database;
    final maps =
        await db.query(tableName, where: 'type = ?', whereArgs: [type]);
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  // Actualizar una transacción
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(tableName, transaction.toMap(),
        where: 'id = ?', whereArgs: [transaction.id]);
  }

  // Eliminar una transacción
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
