import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'modelo/usuario.dart';

class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _apellido = '';
  String _rol = 'Cliente';
  String _tipo_doc = 'Cédula de ciudadania';
  int _num_doc = 0;
  String _ciudad = '';
  String _direccion = '';
  String _correo = '';
  String _telefono = '';
  String _contrasena = '';
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
  }

  void _refreshUsuarios() {
    setState(() {});
  }

  void _showForm(int? ID) async {
    if (ID != null) {
      final usuario = (await _dbHelper.getUsuario())
          .firstWhere((element) => element.ID == ID);
      _nombre = usuario.nombre;
      _apellido = usuario.apellido;
      _rol = usuario.rol;
      _tipo_doc = usuario.tipo_doc;
      _num_doc = usuario.num_doc;
      _ciudad = usuario.ciudad;
      _direccion = usuario.direccion;
      _correo = usuario.correo;
      _telefono = usuario.telefono;
      _contrasena = usuario.contrasena;
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
                    initialValue: _nombre,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nombre = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _apellido,
                    decoration: InputDecoration(labelText: 'Apellido'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su apellido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _apellido = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _rol, // Puede ser nulo inicialmente
                    onChanged: (String? newValue) {
                      setState(() {
                        _rol = newValue!;
                      });
                    },
                    items: <String>["Admin", "Cliente", "Vendedor"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: "Rol"),
                  ),
                  DropdownButtonFormField<String>(
                    value: _tipo_doc,
                    onChanged: (String? newValue) {
                      setState(() {
                        _tipo_doc = newValue!;
                      });
                    },
                    items: <String>[
                      "Cédula de ciudadania",
                      "Cédula de Extranjeria",
                      "Permiso Especial de Permanencia",
                      "Documento de identificación extranjero"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: "Tipo de documento"),
                  ),
                  TextFormField(
                    initialValue: _num_doc.toString(),
                    decoration: InputDecoration(labelText: 'Número de documento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su número de documento';
                      } else if (int.tryParse(value) == null) {
                        return 'Debe ser un número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _num_doc = int.parse(value!);
                    },
                  ),

                  TextFormField(
                    initialValue: _ciudad,
                    decoration: InputDecoration(labelText: 'Ciudad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su ciudad';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _ciudad = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _direccion,
                    decoration: InputDecoration(labelText: 'Dirección'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su dirección de residencia';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _direccion = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _correo,
                    decoration: InputDecoration(labelText: 'Correo Electronico'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo electronico';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _correo = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _telefono,
                    decoration: InputDecoration(labelText: 'Número de Telefono'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su número de telefono';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _telefono = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: _contrasena,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una contraseña';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _contrasena = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print("Datos guardados: $_nombre, $_apellido, $_rol, etc.");
                        if (ID == null) {
                          await _dbHelper.insertUsuario(Usuario(
                            nombre: _nombre,
                            apellido: _apellido,
                            rol: _rol,
                            tipo_doc: _tipo_doc,
                            num_doc: _num_doc,
                            ciudad: _ciudad,
                            direccion: _direccion,
                            correo: _correo,
                            telefono: _telefono,
                            contrasena: _contrasena,
                          ));
                          print("Usuario actualizado correctamente");
                        } else {
                          await _dbHelper.updateUsuario(Usuario(
                            ID: ID,
                            nombre: _nombre,
                            apellido: _apellido,
                            rol: _rol,
                            tipo_doc: _tipo_doc,
                            num_doc: _num_doc,
                            ciudad: _ciudad,
                            direccion: _direccion,
                            correo: _correo,
                            telefono: _telefono,
                            contrasena: _contrasena,
                          ));
                        }
                        _refreshUsuarios();
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
    _refreshUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _dbHelper.getUsuario(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final usuario = snapshot.data![index];
              return ListTile(

                title: Text('ID: ${usuario.ID} ' + usuario.nombre + usuario.apellido),
                subtitle: Text('Rol: ${usuario.rol}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(usuario.ID),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteUsuario(usuario.ID!),
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
