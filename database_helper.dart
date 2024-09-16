import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'modelo/usuario.dart';
// import 'modelo/proyecto.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'kokoshop.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla Usuarios
    await db.execute('''
    CREATE TABLE usuarios (
    ID INTEGER primary key AUTOINCREMENT,
    nombre TEXT NOT NULL, 
    apellido TEXT NOT NULL,
    rol TEXT NOT NULL,
    tipo_doc TEXT NOT NULL,
    num_doc INTEGER NOT NULL,
    ciudad TEXT NOT NULL,
    direccion TEXT NOT NULL,
	  correo TEXT NOT NULL,
    telefono TEXT NOT NULL,
    contrasena TEXT NOT NULL
    );
    
    ''');

    await db.execute('''
    CREATE TABLE productos(
	  Id_producto INTEGER primary key AUTOINCREMENT, 
    produc_nom TEXT NOT NULL,
    produc_precio real NOT NULL,
    tipo_producto TEXT NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE cantidad_talla(
	  Id_producto INTEGER NOT NULL,
    talla TEXT,
    cantidad INTEGER,
    FOREIGN KEY (Id_producto) REFERENCES productos(Id_producto)
    );
    ''');
  }
  // CRUD Usuario

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await database;
    return await db!.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> getUsuario() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('usuarios');
    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await database;
    return await db!.update('usuarios', usuario.toMap(),
        where: 'ID = ?', whereArgs: [usuario.ID]);
  }

  Future<int> deleteUsuario(int ID) async {
    final db = await database;
    return await db!.delete('usuarios', where: 'ID = ?', whereArgs: [ID]);
  }

	// CRUD Productos
  Future<int> insertProducto(Producto producto) async {
    final db = await database;
    return await db!.insert('productos', producto.toMap());
  }

  Future<List<Producto>> getProductos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('productos');
    return List.generate(maps.length, (i) {
      return Producto.fromMap(maps[i]);
    });
  }

  Future<int> updateProducto(Producto producto) async {
    final db = await database;
    return await db!.update('productos', producto.toMap(),
        where: 'Id_producto = ?', whereArgs: [producto.id_producto]);
  }

  Future<int> deleteProducto(int id_producto) async {
    final db = await database;
    return await db!.delete('productos', where: 'Id_producto = ?', whereArgs: [id_producto]);
  }

}
