import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/productos_carrito.dart';
import 'modelo/producto.dart';
import 'modelo/carrito.dart';

class CarritoDetailScreen extends StatefulWidget {
  final Carrito carrito;

  CarritoDetailScreen({required this.carrito});

  @override
  _CarritoDetailScreenState createState() => _CarritoDetailScreenState();
}

class _CarritoDetailScreenState extends State<CarritoDetailScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<productosCarrito> productosEnCarrito = [];
  List<Producto> productosDisponibles = [];
  Producto? selectedProducto;
  int cantidadProducto = 1;

  @override
  void initState() {
    super.initState();
    _fetchCarritoProductos();
    _fetchProductosDisponibles();
  }

  void _fetchCarritoProductos() async {
    List<productosCarrito> fetchedProductos = await dbHelper.getProductosCarrito();
    setState(() {
      productosEnCarrito = fetchedProductos
          .where((p) => p.id_carrito == widget.carrito.id_carrito)
          .toList();
    });
  }

  void _fetchProductosDisponibles() async {
    List<Producto> fetchedProductos = await dbHelper.getProductos();
    setState(() {
      productosDisponibles = fetchedProductos;
    });
  }

  void _addProductoToCarrito() async {
    if (selectedProducto != null) {
      productosCarrito nuevoProductoCarrito = productosCarrito(
        id_carrito: widget.carrito.id_carrito,
        id_producto: selectedProducto!.id_producto,
        cantidad_product: cantidadProducto,
      );
      await dbHelper.insertProductoCarrito(nuevoProductoCarrito);
      _fetchCarritoProductos(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrito ID: ${widget.carrito.id_carrito}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productosEnCarrito.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Producto ID: ${productosEnCarrito[index].id_producto}'),
                  subtitle: Text('Cantidad: ${productosEnCarrito[index].cantidad_product}'),
                );
              },
            ),
          ),
          DropdownButton<Producto>(
            value: selectedProducto,
            hint: Text('Seleccione un producto'),
            onChanged: (Producto? newValue) {
              setState(() {
                selectedProducto = newValue!;
              });
            },
            items: productosDisponibles.map((Producto producto) {
              return DropdownMenuItem<Producto>(
                value: producto,
                child: Text(producto.nombre),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cantidad'),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (cantidadProducto > 1) cantidadProducto--;
                  });
                },
              ),
              Text(cantidadProducto.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    cantidadProducto++;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _addProductoToCarrito,
            child: Text('Agregar al Carrito'),
          ),
        ],
      ),
    );
  }
}
