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
  List<Map<String, dynamic>> productosEnVenta = [];
  List<Producto> productosDisponibles = [];
  int _idVenta = 0;
  Producto? productoSeleccionado;
  int cantidadSeleccionada = 1;

  @override
  void initState() {
    super.initState();
    _idVenta = widget.venta.Id_venta!;
    cargarProductosVenta();
    cargarProductosDisponibles();
  }

  Future<void> cargarProductosVenta() async {
    var dbHelper = DatabaseHelper();
    List<ProductoVenta> productosVenta = await dbHelper.getProductoVentas(_idVenta);
    List<Map<String, dynamic>> productosConNombres = [];

    for (var productoVenta in productosVenta) {
      Producto? producto = await dbHelper.getProductoById(productoVenta.id_producto);
      if (producto != null) {
        productosConNombres.add({
          'producto': producto,
          'cantidad': productoVenta.cantidad,
        });
      }
    }

    setState(() {
      productosEnVenta = productosConNombres;
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
    var productoVenta = ProductoVenta(
      id_venta: widget.venta.Id_venta!,
      id_producto: productoSeleccionado!.id_producto!,
      cantidad: cantidadSeleccionada,
    );

    try {
      await dbHelper.insertProductoVenta(productoVenta);
      await cargarProductosVenta();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado a la venta')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar producto a la venta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos en la venta ${widget.venta.Id_venta}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productosEnVenta.length,
              itemBuilder: (context, index) {
                final productoInfo = productosEnVenta[index];
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
                  child: Text('Agregar Producto a la Venta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}