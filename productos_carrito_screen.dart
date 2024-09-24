
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
    cargarProductosCarrito(widget.carrito.id_carrito);
    cargarProductosDisponibles();
    print("Carrito: ${widget.carrito}");
    print("Producto Seleccionado: $productoSeleccionado");
  }

  Future<void> cargarProductosCarrito(int? id_carrito) async {
    var dbHelper = DatabaseHelper();
    List<ProductosCarrito> productos = await dbHelper.getProductosCarrito(id_carrito!);

    // Verifica si los productos se obtienen correctamente
    print("Productos en el carrito: ${productos.length}");

    setState(() {
      productosCarrito = productos
          .where((producto) => producto.id_carrito == widget.carrito.id_carrito)
          .toList();

      // Verifica si la lista se actualiza
      print("Productos en el carrito después del setState: ${productosCarrito.length}");
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

    print("ID del carrito: ${widget.carrito.id_carrito}");

    if (productoSeleccionado == null) {
      print("Error: No se ha seleccionado ningún producto");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecciona un producto')),
      );
      return;
    }

    if (widget.carrito.id_carrito == null) {
      print("Error: El ID del carrito es nulo");
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
    var productoCarrito = ProductosCarrito(
      id_carrito: widget.carrito.id_carrito!,
      id_producto: productoSeleccionado!.id_producto!,
      cantidad_product: cantidadSeleccionada,
    );

    try {
      await dbHelper.insertProductoCarrito(productoCarrito);
      print("Producto agregado al carrito con éxito");

      // Refresca la lista de productos en el carrito
      await cargarProductosCarrito(widget.carrito.id_carrito);

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
                  subtitle: Text('Cantidad: ${productoCarrito.cantidad_product}'),
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


