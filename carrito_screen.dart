import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/carrito.dart';
import 'modelo/productos_carrito.dart';
import 'modelo/producto.dart';
import 'carrito_detail_screen.dart';

class CarritosScreen extends StatefulWidget {
  @override
  _CarritosScreenState createState() => _CarritosScreenState();
}

class _CarritosScreenState extends State<CarritosScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Carrito> carritos = [];

  @override
  void initState() {
    super.initState();
    _fetchCarritos();
  }

  void _fetchCarritos() async {
    List<Carrito> fetchedCarritos = await dbHelper.getCarrito();
    setState(() {
      carritos = fetchedCarritos;
    });
  }

  void _viewCarritoProducts(Carrito carrito) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarritoDetailScreen(carrito: carrito),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carritos')),
      body: ListView.builder(
        itemCount: carritos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Carrito ID: ${carritos[index].id_carrito}'),
            onTap: () => _viewCarritoProducts(carritos[index]),
          );
        },
      ),
    );
  }
}
