

import 'package:flutter/material.dart';
import 'usuario_screen.dart';
import 'producto_screen.dart';
import 'ventas_screen.dart';
import 'carrito_screen.dart';

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
              child: Text('Usuarios'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductoScreen()),
                );
              },
              child: Text('Productos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VentasScreen()),
                );
              },
              child: Text('Ventas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarritoScreen()),
                );
              },
              child: Text('Carritos de Compras'),
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
