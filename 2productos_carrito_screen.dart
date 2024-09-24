import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/productos_carrito.dart';
import 'modelo/producto.dart';
import 'modelo/carrito.dart';

class ProductosCarritoScreen extends StatefulWidget {
  final Carrito carrito;

  ProductosCarritoScreen({required this.carrito});

  @override
  _ProductosCarritoScreenState createState() => _ProductosCarritoScreenState();
}

class _ProductosCarritoScreenState extends State<ProductosCarritoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _idCarrito = 0;
  int _cantidadProducto = 0;
  int? _idProducto;
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadProductos();
  }

  void _refreshProductosCarrito() {
    setState(() {});
  }

  void _loadProductos() async {
    final productos = await _dbHelper.getProductos();
    setState(() {
      _productos = productos;
    });
  }

  void _showForm(int? idCarrito, int? idProducto) async {
    if (idProducto != null) {
      final productoCarrito = (await _dbHelper.getProductosCarrito(_idCarrito))
          .firstWhere((element) => element.id_producto == idProducto);
      _idProducto = productoCarrito.id_producto;
      _cantidadProducto = productoCarrito.cantidad_product;
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
                  DropdownButtonFormField<int>(
                    value: _idProducto,
                    hint: Text('Seleccione Producto'),
                    items: _productos.map((producto) {
                      return DropdownMenuItem<int>(
                        value: producto.id_producto,
                        child: Text(producto.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _idProducto = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione un producto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _cantidadProducto.toString(),
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
                      _cantidadProducto = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (idProducto == null) {
                          await _dbHelper.insertProductoCarrito(ProductosCarrito(
                            id_carrito: idCarrito!,
                            id_producto: _idProducto!,
                            cantidad_product: _cantidadProducto,
                          ));
                        } else {
                          await _dbHelper.updateProductoCarrito(ProductosCarrito(
                            id_carrito: idCarrito!,
                            id_producto: _idProducto!,
                            cantidad_product: _cantidadProducto,
                          ));
                        }
                        _refreshProductosCarrito();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(idProducto == null ? 'Agregar' : 'Actualizar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Eliminar Producto del Carrito
  void _deleteProductoCarrito(int idCarrito, int idProducto) async {
    await _dbHelper.deleteProductoCarrito(idCarrito, idProducto);
    _refreshProductosCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Productos'),
      ),
      body: FutureBuilder<List<ProductosCarrito>>(
        future: _dbHelper.getProductosCarrito(_idCarrito),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final productoCarrito = snapshot.data![index];
              return ListTile(
                title: Text('Producto: ${productoCarrito.id_producto}'),
                subtitle: Text('Cantidad: ${productoCarrito.cantidad_product}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          _showForm(productoCarrito.id_carrito, productoCarrito.id_producto),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProductoCarrito(
                          productoCarrito.id_carrito, productoCarrito.id_producto),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null, null),
        child: Icon(Icons.add),
      ),
    );
  }
}
