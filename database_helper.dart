import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'modelo/usuario.dart';
import 'modelo/producto.dart';
import 'modelo/carrito.dart';
import 'modelo/venta.dart';
import 'modelo/productos_venta.dart';
import 'modelo/productos_carrito.dart';

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
    // await deleteDatabase(join(await getDatabasesPath(), 'kokoshop.db'));

    String path = join(await getDatabasesPath(), 'kokoshop.db');
    return await openDatabase(
      path,
      version: 2,
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
	  id_producto INTEGER primary key AUTOINCREMENT, 
    nombre TEXT NOT NULL,
    cantidad INTEGER NOT NULL,
    precio real NOT NULL,
    tipo_producto TEXT NOT NULL
    );
    ''');

	 await db.execute('''
    CREATE TABLE carrito (
      id_carrito INTEGER PRIMARY KEY AUTOINCREMENT,
      id_cli INTEGER NOT NULL,
      FOREIGN KEY (id_cli) REFERENCES usuarios(ID)
    );
    ''');

    await db.execute('''
    CREATE TABLE productos_carrito(
    id_carrito INTEGER,
    id_producto INTEGER,
    cantidad_product INTEGER,
    PRIMARY KEY (id_carrito, id_producto),
    FOREIGN KEY (id_carrito) REFERENCES carrito(id_carrito),
    FOREIGN KEY (id_producto) REFERENCES productos(Id_producto)
    );
    ''');

	    await db.execute('''
    CREATE TABLE ventas(
	  Id_venta INTEGER primary key AUTOINCREMENT,
	  Id_usuario INTEGER NOT NULL,
    precio double,
    fechaVenta TEXT,
    tipoVenta TEXT,
    estado TEXT,
    FOREIGN KEY (Id_usuario) REFERENCES usuarios(ID)
    );
    ''');

    await db.execute('''
      CREATE TABLE productos_venta(
      Id_venta INTEGER NOT NULL,
      id_producto INTEGER NOT NULL,
      cantidad INTEGER NOT NULL,
      
      FOREIGN KEY (Id_venta) REFERENCES ventas(Id_venta)
      FOREIGN KEY (id_producto) REFERENCES productos(Id_producto)
      
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
    var productoMap = producto.toMap()..remove('id_producto');
    return await db!.insert('productos', productoMap);
  }
  /*

  Future<int> insertarCarrito(Carrito carrito) async {
    final db = await database;
    // Creamos una copia del mapa del carrito y removemos el id_carrito
    var carritoMap = carrito.toMap()..remove('id_carrito');
    return await db!.insert('carrito', carritoMap);
  }
   */

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

	//crud ventas
  Future<int> insertVentas(Venta ventas) async {
    final db = await database;
    return await db!.insert('ventas', ventas.toMap());
  }

  Future<List<Venta>> getVentas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('ventas');
    return List.generate(maps.length, (i) {
      return Venta.fromMap(maps[i]);
    });
  }

  Future<int> updateVentas(Venta ventas) async {
    final db = await database;
    return await db!.update('ventas', ventas.toMap(),
        where: 'Id_venta = ?', whereArgs: [ventas.Id_venta]);
  }

  Future<int> deleteVentas(int Id_venta) async {
    final db = await database;
    return await db!.delete('ventas', where: 'Id_venta = ?', whereArgs: [Id_venta]);
  }

	//crud carrito
// En tu DatabaseHelper
  Future<int> insertarCarrito(Carrito carrito) async {
    final db = await database;
    // Creamos una copia del mapa del carrito y removemos el id_carrito
    var carritoMap = carrito.toMap()..remove('id_carrito');
    return await db!.insert('carrito', carritoMap);
  }
/*
  Future<int> insertUsuario(Usuario usuario) async {
    final db = await database;
    return await db!.insert('usuarios', usuario.toMap());
  }

 */



  Future<List<Carrito>> getCarrito() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('carrito');
    return List.generate(maps.length, (i) {
      return Carrito(
        id_carrito: maps[i]['id_carrito'],
        id_cli: maps[i]['id_cli'],
      );
    });
  }


  Future<int> updateCarrito(Carrito carrito) async {
    final db = await database;
    return await db!.update('carrito', carrito.toMap(),
        where: 'id_carrito = ?', whereArgs: [carrito.id_carrito]);
  }

  Future<int> deleteCarrito(int id_carrito) async {
    final db = await database;
    return await db!.delete('carrito', where: 'id_carrito = ?', whereArgs: [id_carrito]);
  }

  // CRUD ProductosCarrito
  Future<int> insertProductoCarrito(ProductoCarrito productoCarrito) async {
    final db = await database;
    final productoCarritoMap = productoCarrito.toMap();
    return await db!.insert('productos_carrito', productoCarritoMap);
  }



  Future<List<ProductoCarrito>> getProductosCarrito(int id_carrito) async {
    try {
      final db = await database;
      if (db == null) {
        throw Exception('No se pudo obtener la base de datos');
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'productos_carrito',
        where: 'id_carrito = ?',
        whereArgs: [id_carrito],
      );

      return List.generate(maps.length, (i) {
        return ProductoCarrito(
          id_carrito: maps[i]['id_carrito'] as int? ?? 0,
          id_producto: maps[i]['id_producto'] as int? ?? 0,
          cantidad_product: maps[i]['cantidad_product'] as int? ?? 0,
        );
      });
    } catch (e) {
      print('Error al obtener productos del carrito: $e');
      return [];
    }
  }

  Future<int> updateProductoCarrito(ProductoCarrito productoCarrito) async {
    final db = await database;
    return await db!.update('productos_carrito', productoCarrito.toMap(),
        where: 'id_carrito = ? AND id_producto = ?',
        whereArgs: [productoCarrito.id_carrito, productoCarrito.id_producto]);
  }

  Future<int> deleteProductoCarrito(int id_carrito, int id_producto) async {
    final db = await database;
    return await db!.delete('productos_carrito',
        where: 'id_carrito = ? AND id_producto = ?',
        whereArgs: [id_carrito, id_producto]);
  }
	// CRUD ProductoVenta
  Future<int> insertProductoVenta(ProductoVenta productoventa) async {
    final db = await database;
    return await db!.insert('productos_venta', productoventa.toMap());
  }


  Future<List<ProductoVenta>> getProductoVentas(int id_venta) async {
    try {
      final db = await database;
      if (db == null) {
        throw Exception('No se pudo obtener la base de datos');
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'productos_venta',
        where: 'Id_venta = ?',
        whereArgs: [id_venta],
      );

      return List.generate(maps.length, (i) {
        return ProductoVenta(
          id_venta: maps[i]['id_venta'] as int? ?? 0,
          id_producto: maps[i]['id_producto'] as int? ?? 0,
          cantidad: maps[i]['cantidad'] as int? ?? 0,
        );
      });
    } catch (e) {
      print('Error al obtener productos del carrito: $e');
      return [];
    }
  }

  Future<int> updateProductoVenta(ProductoVenta productoventa) async {
    final db = await database;
    return await db!.update('productos_venta', productoventa.toMap(),
        where: 'Id_venta = ?', whereArgs: [productoventa.id_venta]);
  }

  Future<int> deleteProductoVenta(int idVenta) async {
    final db = await database;
    return await db!.delete(
        'productos_venta', where: 'Id_venta = ?', whereArgs: [idVenta]);
  }
}


