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
  List<Map<String, dynamic>> productosEnCarrito = [];
  List<Producto> productosDisponibles = [];
  int _idCarrito = 0;
  Producto? productoSeleccionado;
  int cantidadSeleccionada = 1;

  @override
  void initState() {
    super.initState();
    _idCarrito = widget.carrito.id_carrito!;
    cargarProductosCarrito();
    cargarProductosDisponibles();
  }

  Future<void> cargarProductosCarrito() async {
    var dbHelper = DatabaseHelper();
    List<ProductoCarrito> productosCarrito = await dbHelper.getProductosCarrito(_idCarrito);
    List<Map<String, dynamic>> productosConNombres = [];

    for (var productoCarrito in productosCarrito) {
      Producto? producto = await dbHelper.getProductoById(productoCarrito.id_producto);
      if (producto != null) {
        productosConNombres.add({
          'producto': producto,
          'cantidad': productoCarrito.cantidad_product,
        });
      }
    }

    setState(() {
      productosEnCarrito = productosConNombres;
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
    if (productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecciona un producto')),
      );
      return;
    }

    var dbHelper = DatabaseHelper();
    var productoCarrito = ProductoCarrito(
      id_carrito: widget.carrito.id_carrito!,
      id_producto: productoSeleccionado!.id_producto!,
      cantidad_product: cantidadSeleccionada,
    );

    try {
      await dbHelper.insertProductoCarrito(productoCarrito);
      await cargarProductosCarrito();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado al carrito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar producto al carrito')),
      );
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
              itemCount: productosEnCarrito.length,
              itemBuilder: (context, index) {
                final productoInfo = productosEnCarrito[index];
                final Producto producto = productoInfo['producto'];
                final int cantidad = productoInfo['cantidad'];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Cantidad: $cantidad'),
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

