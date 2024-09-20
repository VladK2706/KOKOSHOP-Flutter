import 'package:flutter/material.dart';
import 'database_helper.dart'; // Tu archivo con las operaciones de la base de datos
import 'modelo/carrito.dart';
import 'productos_carrito_screen.dart';// Tu modelo Carrito

class CarritosScreen extends StatefulWidget {
  @override
  _CarritosScreenState createState() => _CarritosScreenState();
}

class _CarritosScreenState extends State<CarritosScreen> {
  List<Carrito> carritos = [];

  @override
  void initState() {
    super.initState();
    cargarCarritos();
  }

  Future<void> cargarCarritos() async {
    var dbHelper = DatabaseHelper();
    List<Carrito> carritosCargados = await dbHelper.getCarrito();
    setState(() {
      carritos = carritosCargados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carritos de Usuario'),
      ),
      body: ListView.builder(
        itemCount: carritos.length,
        itemBuilder: (context, index) {
          Carrito carrito = carritos[index];
          return ListTile(
            title: Text('Carrito ${carrito.id_carrito}'),
            subtitle: Text('ID Cliente: ${carrito.id_cli}'),
            onTap: () {
              // Navegar a la pantalla que muestra los productos del carrito
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductosCarritoScreen(carrito: carrito),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
