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
    cargarProductosVenta();
    cargarProductosDisponibles();// Llamada para obtener los productos
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

  Future<void> agregarProductoAlCarrito() async {
    print("Intentando agregar producto al carrito...");
    print("Producto seleccionado: ${productoSeleccionado?.nombre}, ID: ${productoSeleccionado?.id_producto}");

    print("ID de la venta: ${widget.venta.Id_venta}");

    if (productoSeleccionado == null) {
      print("Error: No se ha seleccionado ningún producto");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecciona un producto')),
      );
      return;
    }

    if (widget.venta.Id_venta == null) {
      print("Error: El ID de la venta es nulo");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ID del carrito no válido')),
      );
      return;
    }

    if (productoSeleccionado!.id_producto == null) {
      print("Error: El ID del producto es nulo");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ID del producto no válido')),
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
      print("Producto agregado al carrito con éxito");

      // Refresca la lista de productos en el carrito
      await cargarProductosVenta();

      // Fuerza una actualización de la UI
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado al carrito')),
      );
    } catch (e) {
      print("Error al agregar producto al carrito: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar producto al carrito')),
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
              itemCount: productosVenta.length,
              itemBuilder: (context, index) {
                final ProductoVenta productoVenta = productosVenta[index];
                return ListTile(
                  title: Text('Producto ID: ${productoVenta.id_producto}'),
                  subtitle: Text('Cantidad: ${productoVenta.cantidad}'),
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
                      print("Producto seleccionado: ${productoSeleccionado?.nombre}, ID: ${productoSeleccionado?.id_producto}");
                    });
                  },
                  items: productosDisponibles.map((Producto producto) {
                    return DropdownMenuItem<Producto>(
                      value: producto,
                      child: Text("${producto.nombre} (ID: ${producto.id_producto})"),
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

