// drawer_menu.dart
import 'package:flutter/material.dart';
import 'ListaCitas.dart';
import 'RegistrarCita.dart';

class CustomDrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Crear Mascota'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CitasApp()),
                ); // Cierra el drawer
            },
          ),
          ListTile(
            title: Text('Ver Mascotas'),
            onTap: () {
              // Lógica para la opción 2
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaCitasApp()),
                ); // Cierra el drawer
            },
          ),
          
          // Puedes agregar más opciones aquí
        ],
      ),
    );
  }
}