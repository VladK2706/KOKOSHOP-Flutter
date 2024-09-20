import 'dart:ffi';

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/ventas.dart';

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final _formKey = GlobalKey<FormState>();
  double _precio = 0.0;
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
      final ventas = (await _dbHelper.getVentas())
          .firstWhere((element) => element.ID == ID);
      _precio = ventas.precio;
      _fechaVenta = ventas.fechaVenta;
      _tipoVenta = ventas.tipoVenta;
      _estado = ventas.estado;

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
                    initialValue:_precio.toString(),
                    decoration: InputDecoration(labelText: 'Precio'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el precio del producto';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _precio = double.parse(value!);
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
                        print("Datos guardados: $_precio, $_fechaVenta, $_tipoVenta, etc.");
                        if (ID == null) {
                          await _dbHelper.insertVentas(Ventas(
                            precio: _precio,
                            fechaVenta: _fechaVenta,
                            tipoVenta: _tipoVenta,
                            estado: _estado,

                          ));
                          print("venta actualizada correctamente");
                        } else {
                          await _dbHelper.updateVentas(Ventas(
                            ID: ID,
                            precio: _precio,
                            fechaVenta: _fechaVenta,
                            tipoVenta: _tipoVenta,
                            estado: _estado,

                          ));
                        }
                        _refreshVentas();
                        Navigator.of(context).pop();
                      }else {
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
  void _deleteUsuario(int ID) async {
    await _dbHelper.deleteUsuario(ID);
    _refreshVentas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: FutureBuilder<List<Ventas>>(
        future: _dbHelper.getVentas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ventas = snapshot.data![index];
              return ListTile(
                title: Text(ventas.fechaVenta),
                subtitle: Text('Ventas ID: ${ventas.ID}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(ventas.ID),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteUsuario(ventas.ID!),
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