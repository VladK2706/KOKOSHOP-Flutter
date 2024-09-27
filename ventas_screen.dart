import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/venta.dart';
import 'productos_venta_screen.dart';

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final _formKey = GlobalKey<FormState>();
  int _Id_usuario = 0;
  String _fechaVenta = '';
  String _tipoVenta = '';
  String _estado = '';
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  void _refreshVentas() {
    setState(() {});
  }

  void _showForm(int? ID) async {
    if (ID != null) {
      final venta = (await _dbHelper.getVentas())
          .firstWhere((element) => element.Id_venta == ID);
      _Id_usuario = venta.Id_usuario;
      _fechaVenta = venta.fechaVenta;
      _tipoVenta = venta.tipoVenta;
      _estado = venta.estado;
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
                    initialValue: _Id_usuario.toString(),
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
                      _Id_usuario = int.parse(value!);
                    },
                  ),


                  TextFormField(
                    initialValue: _fechaVenta,
                    decoration: InputDecoration(labelText: 'Fecha de la venta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha de la venta';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _fechaVenta = value!;
                    },
                  ),


                  TextFormField(
                    initialValue: _tipoVenta,
                    decoration: InputDecoration(labelText: 'Tipo de venta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipoo de la venta';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _tipoVenta = value!;
                    },
                  ),

                  TextFormField(
                    initialValue: _estado,
                    decoration: InputDecoration(labelText: 'Estado'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el estado de la venta';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _estado = value!;
                    },
                  ),


                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(
                            "Datos guardados:  $_fechaVenta, $_tipoVenta, etc.");
                        if (ID == null) {
                          await _dbHelper.insertVentas(Venta(
                            Id_usuario: _Id_usuario,
                            fechaVenta: _fechaVenta,
                            tipoVenta: _tipoVenta,
                            estado: _estado,

                          ));


                          print("venta actualizada correctamente");
                        } else {
                          await _dbHelper.updateVentas(Venta(
                            Id_venta: ID,
                            Id_usuario: _Id_usuario,
                            fechaVenta: _fechaVenta,
                            tipoVenta: _tipoVenta,
                            estado: _estado,

                          ));
                        }
                        _refreshVentas();
                        Navigator.of(context).pop();
                      } else {
                        print("Formulario no válido");
                      }
                    },
                    child: Text(ID == null ? 'Agregar' : 'Actualizar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Borrar Usuario
  void _deleteVenta(int ID) async {
    await _dbHelper.deleteVentas(ID);
    _refreshVentas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: FutureBuilder<List<Venta>>(
        future: _dbHelper.getVentas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final venta = snapshot.data![index];
              return ListTile(
                title: Text(venta.fechaVenta),
                subtitle: Text('Ventas ID: ${venta.Id_venta}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(venta.Id_venta),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteVenta(venta.Id_venta!),
                    ),
                  ],
                ),

                onTap: () {
                  // Navegar a ProductosCarritoScreen cuando se toca un carrito
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductosVentaScreen(venta: venta),
                    ),
                  ).then((_) => _refreshVentas()); // Recargar la lista después de volver
                },



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