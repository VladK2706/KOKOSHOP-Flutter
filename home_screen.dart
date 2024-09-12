

import 'package:flutter/material.dart';
import 'usuario_screen.dart';
//import 'entidad_screen.dart';
//import 'proyecto_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Kokoshop'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuarioScreen()),
                );
              },
              child: Text('Gestionar Entidades'),
            ),
            /*
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProyectoScreen()),
                );
              },
              child: Text('Gestionar Proyectos'),
            ),

             */
          ],
        ),
      ),
    );
  }
}
