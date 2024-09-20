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
  List<ProductosCarrito> productosCarrito = [];
  List<Producto> productosDisponibles = [];
  Producto? productoSeleccionado;
  int cantidadSeleccionada = 1;

  @override
  void initState() {
    super.initState();
    cargarProductosCarrito();
    cargarProductosDisponibles();
  }

  Future<void> cargarProductosCarrito() async {
    var dbHelper = DatabaseHelper();
    List<ProductosCarrito> productos = await dbHelper.getProductosCarrito();
    setState(() {
      productosCarrito = productos
          .where((producto) => producto.id_carrito == widget.carrito.id_carrito)
          .toList();
    });
  }

  Future<void> cargarProductosDisponibles() async {
    var dbHelper = DatabaseHelper();
    List<Producto> productos = await dbHelper.getProductos();
    setState(() {
      productosDisponibles = productos;
    });
  }

  Future<void> agregarProductoAlCarrito() async {
    if (productoSeleccionado != null) {
      var dbHelper = DatabaseHelper();
      var productoCarrito = ProductosCarrito(
        id_carrito: widget.carrito.id_carrito!,
        id_producto: productoSeleccionado!.id_producto!,
        cantidad: cantidadSeleccionada,
      );
      await dbHelper.insertProductoCarrito(productoCarrito);
      cargarProductosCarrito(); // Refrescar la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos en el Carrito ${widget.carrito.id_carrito}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productosCarrito.length,
              itemBuilder: (context, index) {
                ProductosCarrito productoCarrito = productosCarrito[index];
                return ListTile(
                  title: Text('Producto ID: ${productoCarrito.id_producto}'),
                  subtitle: Text('Cantidad: ${productoCarrito.cantidad}'),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<Producto>(
                  hint: Text('Selecciona un producto'),
                  value: productoSeleccionado,
                  onChanged: (Producto? nuevoProducto) {
                    setState(() {
                      productoSeleccionado = nuevoProducto;
                    });
                  },
                  items: productosDisponibles.map((Producto producto) {
                    return DropdownMenuItem<Producto>(
                      value: producto,
                      child: Text(producto.nombre),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cantidad:'),
                    SizedBox(width: 10),
                    DropdownButton<int>(
                      value: cantidadSeleccionada,
                      onChanged: (int? nuevaCantidad) {
                        setState(() {
                          cantidadSeleccionada = nuevaCantidad ?? 1;
                        });
                      },
                      items: List.generate(10, (index) => index + 1)
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: agregarProductoAlCarrito,
                  child: Text('Agregar Producto al Carrito'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
