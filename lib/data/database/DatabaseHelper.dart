import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data/models/categories.dart';
import 'package:todo/data/models/tasks.dart';

class DatabaseHelper {
  // Singleton pattern để đảm bảo chỉ có một instance của DatabaseHelper trong toàn bộ ứng dụng
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Lấy instance của database, nếu chưa có thì khởi tạo
  Future<Database> get database async {
    WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter đã khởi tạo trước khi truy cập database
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('todo.db'); // Khởi tạo database với tên 'todo.db'
    return _database!;
  }

  // Khởi tạo database và thiết lập đường dẫn
  Future<Database> _initDB(String filepath) async {
    final dbPath =
        await getDatabasesPath(); // Lấy đường dẫn database của hệ thống
    final path = join(dbPath, filepath); // Nối đường dẫn với tên file database

    return await openDatabase(
      path,
      version:
          1, // Định nghĩa phiên bản database, có thể dùng để migrate sau này
      onCreate: _createDB,
      onConfigure: _onConfigure, // Gọi _onConfigure trước khi khởi tạo
    );
  }

  // Cấu hình database, bật tính năng ràng buộc khóa ngoại (foreign keys)
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Tạo các bảng trong database
  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE Tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT, -- ID tự động tăng
          title TEXT NOT NULL,
          description TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Mặc định lấy thời gian hiện tại
          due_date TIMESTAMP,
          status TEXT DEFAULT 'pending', -- Trạng thái mặc định là 'pending'
          priority INTEGER DEFAULT 1, -- Mức độ ưu tiên mặc định là 1
          image_path TEXT
        )
        ''');

    await db.execute('''
        CREATE TABLE Categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          color INTEGER NOT NULL -- Lưu màu sắc dưới dạng số nguyên
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
          FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE -- Xóa task sẽ xóa luôn recurring
        )
        ''');

    await db.execute('''
        CREATE TABLE Reminders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          task_id INTEGER,
          reminder_time TIMESTAMP,
          is_active BOOLEAN DEFAULT 1, -- Mặc định nhắc nhở đang bật
          FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE
        )
        ''');

    await db.execute('''
        CREATE TABLE TaskCategories(
          task_id INTEGER,
          category_id INTEGER,
          PRIMARY KEY (task_id, category_id), -- Đảm bảo một task chỉ thuộc một category duy nhất
          FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE,
          FOREIGN KEY (category_id) REFERENCES Categories(id) ON DELETE CASCADE
        )
        ''');
  }

  // Xóa một task theo ID
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Cập nhật task theo ID
  Future<int> updateTask(Tasks task, int id) async {
    try {
      final db = await instance.database;
      return await db.update(
        'Tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('lỗi trong database updateTask ${e}');
    }
  }

  // Chèn một danh mục (category) vào database, trả về ID của category mới được thêm
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await instance.database;
    return await db.insert('Categories', category);
  }

  // Lấy danh sách các danh mục từ database
  Future<List<Categories>> getCategories() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> categories = await db.query('Categories');
    return categories.map((map) => Categories.fromMap(map)).toList();
  }

  // Lấy danh sách các task từ database
  Future<List<Tasks>> getTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> tasks = await db.query('Tasks');
    return tasks.map((map) => Tasks.fromMap(map)).toList();
  }

  // Chèn một task vào database, trả về ID của task mới được thêm
  Future<int> insertTask(Tasks tasks) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'Tasks',
        tasks.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Nếu task đã tồn tại thì ghi đè
      );
    } catch (e) {
      throw Exception('lỗi trong database insertTask: $e');
    }
  }
}

/*
    📝 Tại sao insertTask trả về ID?
    ---------------------------------------------------
    - Khi một dòng mới được thêm vào SQLite bằng phương thức `insert()`, nó sẽ tự động gán một ID mới nếu cột ID được thiết lập là `PRIMARY KEY AUTOINCREMENT`.
    - Phương thức `insert()` của `sqflite` trả về giá trị ID của dòng vừa được thêm.
    - ID này có thể được sử dụng để tham chiếu đến task trong các thao tác sau này (cập nhật, xóa, hoặc liên kết với các bảng khác).
    - Điều này giúp quản lý dữ liệu dễ dàng hơn thay vì phải truy vấn lại để tìm ID của task vừa chèn vào.
    */
