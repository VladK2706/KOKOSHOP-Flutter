import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/Carrito.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _id_cli = 0;
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  void _refreshCarritos() {
    setState(() {});
  }

  void _showForm(int? id_carrito) async {
    if (id_carrito != null) {
      final carrito = (await _dbHelper.getCarrito())
          .firstWhere((element) => element.id_carrito == id_carrito);
      _id_cli = carrito.id_cli;
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
                    initialValue: _id_cli.toString(),
                    decoration: InputDecoration(labelText: 'ID Cliente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID del cliente';
                      } else if (int.tryParse(value) == null) {
                        return 'Debe ser un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _id_cli = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (id_carrito == null) {
                          await _dbHelper.insertCarrito(Carrito(
                            id_cli: _id_cli,
                          ));
                          print("Carrito agregado correctamente");
                        } else {
                          await _dbHelper.updateCarrito(Carrito(
                            id_carrito: id_carrito,
                            id_cli: _id_cli,
                          ));
                          print("Carrito actualizado correctamente");
                        }
                        _refreshCarritos();
                        Navigator.of(context).pop();
                      } else {
                        print("Formulario no válido");
                      }
                    },
                    child: Text(id_carrito == null ? 'Agregar' : 'Actualizar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteCarrito(int id_carrito) async {
    await _dbHelper.deleteCarrito(id_carrito);
    _refreshCarritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carritos'),
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
                title: Text('Carrito ID: ${carrito.id_carrito}'),
                subtitle: Text('ID Cliente: ${carrito.id_cli}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(carrito.id_carrito),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCarrito(carrito.id_carrito!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
