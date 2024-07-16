// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../models/spending_model.dart';
import '../models/employee_model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'app_mandop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      user_tele TEXT,
      name_project TEXT,
      name_university TEXT,
      total_price REAL,
      is_done_project INTEGER,
      is_done_price INTEGER,
      dateStart TEXT,
      dateEnd TEXT,
      employeesName TEXT,
      employeesId TEXT,
      employeesRate TEXT
    )
    ''');
    // employeesRate TEXT, نسبة الراتب

    await db.execute('''
    CREATE TABLE spending (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL,
      date TEXT,
      note TEXT,
      color TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE employees (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      position TEXT,
      salary REAL,
      hireDate TEXT,
      phone TEXT
    )
    ''');
  }

  // User operations
  static Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  // Spending operations
  static Future<int> insertSpending(SpendingModel spending) async {
    final db = await database;
    return await db.insert('spending', spending.toMap());
  }

  static Future<int> updateSpending(SpendingModel spending) async {
    final db = await database;
    return await db.update('spending', spending.toMap(),
        where: 'id = ?', whereArgs: [spending.id]);
  }

  static Future<int> deleteSpending(int id) async {
    final db = await database;
    return await db.delete('spending', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<SpendingModel>> getSpendings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('spending');
    return List.generate(maps.length, (i) {
      return SpendingModel.fromMap(maps[i]);
    });
  }

  // Employee operations
  static Future<int> insertEmployee(EmployeeModel employee) async {
    final db = await database;
    return await db.insert('employees', employee.toMap());
  }

  static Future<int> updateEmployee(EmployeeModel employee) async {
    final db = await database;
    return await db.update('employees', employee.toMap(),
        where: 'id = ?', whereArgs: [employee.id]);
  }

  static Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<EmployeeModel>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      return EmployeeModel.fromMap(maps[i]);
    });
  }
}
