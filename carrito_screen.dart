import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/carrito.dart';
import 'productos_carrito_screen.dart';

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

  Future<void> crearCarrito(int idCliente) async {
    var dbHelper = DatabaseHelper();
    var nuevoCarrito = Carrito(id_cli: idCliente);
    await dbHelper.insertarCarrito(nuevoCarrito);
    cargarCarritos(); // Recargar los carritos
  }


  Future<void> cargarCarritos() async {
    var dbHelper = DatabaseHelper();
    List<Carrito> carritosCargados = await dbHelper.getCarrito();
    setState(() {
      carritos = carritosCargados;
    });
  }

  void _mostrarFormularioCrearCarrito() {
    final TextEditingController idClienteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Carrito'),
          content: TextField(
            controller: idClienteController,
            decoration: InputDecoration(labelText: 'ID Cliente'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (idClienteController.text.isNotEmpty) {
                  int idCliente = int.parse(idClienteController.text);
                  Carrito nuevoCarrito = Carrito(id_cli: idCliente);
                  var dbHelper = DatabaseHelper();
                  await dbHelper.insertarCarrito(nuevoCarrito);
                  Navigator.of(context).pop();
                  cargarCarritos(); // Recargar la lista de carritos
                }
              },
              child: Text('Crear'),
            ),
          ],
        );
      },
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductosCarritoScreen(carrito: carrito)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioCrearCarrito,
        tooltip: 'Crear Carrito',
        child: Icon(Icons.add),
      ),
    );
  }
}
