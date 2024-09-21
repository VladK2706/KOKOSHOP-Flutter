import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/carrito.dart';

class CarritosScreen extends StatefulWidget {
  @override
  _CarritosScreenState createState() => _CarritosScreenState();
}

class _CarritosScreenState extends State<CarritosScreen> {
  final _formKey = GlobalKey<FormState>();
  int _idCliente = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  Future<void> _loadCarritos() async {
    setState(() {});
  }

  void _showForm(int? idCarrito) async {
    if (idCarrito != null) {
      final carrito = (await _dbHelper.getCarrito())
          .firstWhere((element) => element.id_carrito == idCarrito);
      _idCliente = carrito.id_cli;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _idCliente != 0 ? _idCliente.toString() : '',
                    decoration: InputDecoration(labelText: 'ID Cliente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la ID del cliente';
                      } else if (int.tryParse(value) == null) {
                        return 'Debe ser un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _idCliente = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (idCarrito == null) {
                          // Creating a new cart
                          await _dbHelper.insertarCarrito(Carrito(id_cli: _idCliente));
                        } else {
                          // Updating existing cart
                          await _dbHelper.updateCarrito(Carrito(id_carrito: idCarrito, id_cli: _idCliente));
                        }
                        _loadCarritos();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(idCarrito == null ? 'Agregar Carrito' : 'Actualizar Carrito'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteCarrito(int idCarrito) async {
    await _dbHelper.deleteCarrito(idCarrito);
    _loadCarritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carritos de Usuario'),
      ),
      body: FutureBuilder<List<Carrito>>(
        future: _dbHelper.getCarrito(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final carrito = snapshot.data![index];
              return ListTile(
                title: Text('Carrito ID: ${carrito.id_carrito}, ID Cliente: ${carrito.id_cli}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCarrito(carrito.id_carrito!),
                ),
                onTap: () => _showForm(carrito.id_carrito), // Editar carrito
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null), // Crear nuevo carrito
        child: Icon(Icons.add),
      ),
    );
  }
}
