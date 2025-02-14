import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/categories.dart';

class DatabaseHelper {
  // Sử dụng singleton để có 1 instance duy nhất của DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter để lấy database (nếu chưa có thì khởi tạo)
  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    // Thêm các tùy chọn để xử lý lỗi và gỡ lỗi
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure, // Thêm cấu hình cho foreign keys
    );
  }

  // Thêm method để bật foreign key constraints
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      due_date TIMESTAMP,
      status TEXT DEFAULT 'pending',
      priority INTEGER DEFAULT 1,
      image_path TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE Categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      color INTEGER NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE Recurring(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER,
      repeat_type TEXT,
      repeat_interval INTEGER,
      start_date TIMESTAMP,
      end_date TIMESTAMP,
      FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE Reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
     task_id INTEGER,
      reminder_time TIMESTAMP,
      is_active BOOLEAN DEFAULT 1,
      FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE
    )
  ''');
    await db.execute('''
    CREATE TABLE TaskCategories(
      task_id INTEGER,
      category_id INTEGER,
      PRIMARY KEY (task_id, category_id),
      FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE,
      FOREIGN KEY (category_id) REFERENCES Categories(id) ON DELETE CASCADE
    )
  ''');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('Tasks', task);
  }

  Future deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future updateTask(Map<String, dynamic> task, int id) async {
    final db = await instance.database;
    return await db.update('Tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await instance.database;
    return await db.insert('Categories', category);
  }

  Future<List<Categories>> getCategories() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> categories = await db.query('Categories');
    return categories.map((map) => Categories.fromMap(map)).toList();
  }
}
