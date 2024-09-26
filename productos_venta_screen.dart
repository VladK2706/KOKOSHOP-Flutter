import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/productos_venta.dart';
import 'modelo/venta.dart';
import 'modelo/producto.dart';

class ProductosVentaScreen extends StatefulWidget {
  final Venta venta;

  ProductosVentaScreen({required this.venta});
  @override
  _ProductosVentaScreenState createState() => _ProductosVentaScreenState();
}

class _ProductosVentaScreenState extends State<ProductosVentaScreen> {
  List<ProductoVenta> productosVenta = [];
  List<Producto> productosDisponibles = [];
  int _idVenta = 0;
  Producto? productoSeleccionado;
  int cantidadSeleccionada = 1;

  @override
  void initState() {
    super.initState();
    _idVenta = widget.venta.Id_venta!;
    cargarProductosVenta();  // Llamada para obtener los productos
  }

  Future<void> cargarProductosVenta() async {
    var dbHelper = DatabaseHelper();
    List<ProductoVenta> productosenventa = await dbHelper.getProductoVentas(_idVenta);
    setState(() {
      productosVenta = productosenventa;

      print("Productos en el carrito después del setState: ${productosVenta.length}");
      print(productoSeleccionado?.nombre);
    });
  }

  Future<void> cargarProductosDisponibles() async {
    var dbHelper = DatabaseHelper();
    List<Producto> productos = await dbHelper.getProductos();
    setState(() {
      productosDisponibles = productos;
      print("Productos disponibles: ${productosDisponibles.length}");
      for (var producto in productosDisponibles) {
        print("Producto: ${producto.nombre}, ID: ${producto.id_producto}");
      }
    });
  }

  void _refreshVentas() {
    setState(() {});
  }

  void _showForm(int? idVenta) async {
    if (idVenta != null) {
      final productoventa = (await _dbHelper.getProductoVenta())
          .firstWhere((element) => element.idVenta == idVenta);
      _idVenta = productoventa.idVenta ?? 0;
      _idProducto = productoventa.idProducto;
      _cantidad = productoventa.cantidad;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo para ingresar el ID del cliente
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID Cliente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID del cliente';
                      } else if (int.tryParse(value) == null) {
                        return 'Debe ser un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _idCliente = int.parse(value!);
                    },
                  ),

                  // Campo desplegable para seleccionar el producto
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Producto'),
                    value: _idProducto,
                    items: _productos.map((producto) {
                      return DropdownMenuItem<int>(
                        value: producto['idProducto'],
                        child: Text(producto['nombreProducto']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _idProducto = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor seleccione un producto';
                      }
                      return null;
                    },
                  ),

                  // Campo para ingresar la cantidad
                  TextFormField(
                    initialValue: _cantidad.toString(),
                    decoration: InputDecoration(labelText: 'Cantidad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la cantidad';
                      } else if (int.tryParse(value) == null) {
                        return 'Debe ser un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _cantidad = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print("Datos guardados: Cliente $_idCliente, Venta $_idVenta, Producto $_idProducto, Cantidad $_cantidad");
                        if (idVenta == null) {
                          await _dbHelper.insertProductoVenta(ProductoVenta(
                            idVenta: _idVenta,
                            idProducto: _idProducto,
                            cantidad: _cantidad,
                              // Guarda el ID del cliente
                          ));
                          print("Venta insertada correctamente");
                        } else {
                          await _dbHelper.updateProductoVenta(ProductoVenta(
                            idVenta: _idVenta,
                            idProducto: _idProducto,
                            cantidad: _cantidad,
                              // Actualiza el ID del cliente
                          ));
                          print("Venta actualizada correctamente");
                        }
                        _refreshVentas();
                        Navigator.of(context).pop();
                      } else {
                        print("Formulario no válido");
                      }
                    },
                    child: Text(idVenta == null ? 'Agregar' : 'Actualizar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteProductoVenta(int idVenta) async {
    await _dbHelper.deleteProductoVenta(idVenta);
    _refreshVentas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos Venta'),
      ),
      body: FutureBuilder<List<ProductoVenta>>(
        future: _dbHelper.getProductoVenta(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final productoventa = snapshot.data![index];
              return ListTile(
                title: Text(
                  'ID Venta: ${productoventa.idVenta}, '
                      'Producto: ${productoventa.idProducto}, '
                      'Cantidad: ${productoventa.cantidad}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(productoventa.idVenta),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProductoVenta(productoventa.idVenta!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
