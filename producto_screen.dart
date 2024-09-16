import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/producto.dart';

class ProductoScreen extends StatefulWidget {
  @override
  _ProductoScreenState createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _produc_nom = '';
  double _produc_precio = 0.0;
  String _tipo_producto = '';
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  void _refreshProductos() {
    setState(() {});
  }

  void _showForm(int? id_producto) async {
    if (id_producto != null) {
      final producto = (await _dbHelper.getProductos())
          .firstWhere((element) => element.id_producto == id_producto);
      _produc_nom = producto.produc_nom;
      _produc_precio = producto.produc_precio;
      _tipo_producto = producto.tipo_producto;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _produc_nom,
                  decoration: InputDecoration(labelText: 'Nombre del Producto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del producto';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _produc_nom = value!;
                  },
                ),
                TextFormField(
                  initialValue: _produc_precio.toString(),
                  decoration: InputDecoration(labelText: 'Precio'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _produc_precio = double.parse(value!);
                  },
                ),
                TextFormField(
                  initialValue: _tipo_producto,
                  decoration: InputDecoration(labelText: 'Tipo de Producto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tipo de producto';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tipo_producto = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (id_producto == null) {
                        await _dbHelper.insertProducto(Producto(
                          produc_nom: _produc_nom,
                          produc_precio: _produc_precio,
                          tipo_producto: _tipo_producto,
                        ));
                      } else {
                        await _dbHelper.updateProducto(Producto(
                          id_producto: id_producto,
                          produc_nom: _produc_nom,
                          produc_precio: _produc_precio,
                          tipo_producto: _tipo_producto,
                        ));
                      }
                      _refreshProductos();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(id_producto == null ? 'Agregar' : 'Actualizar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteProducto(int id_producto) async {
    await _dbHelper.deleteProducto(id_producto);
    _refreshProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _dbHelper.getProductos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final producto = snapshot.data![index];
              return ListTile(
                title: Text(producto.produc_nom),
                subtitle: Text('Precio: \$${producto.produc_precio.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(producto.id_producto),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProducto(producto.id_producto!),
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