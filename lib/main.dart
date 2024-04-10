import 'package:flutter/material.dart';
import 'package:menu/ListaCitas.dart';
import 'package:menu/LoginPage.dart'; // Importa la página de inicio de sesión

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => RegisterPage(title: 'Flutter Demo Home Page'),
        '/listacitas': (context) => ListaCitasApp(),
      },
      initialRoute: '/login', // Establecer la página de inicio de sesión como la inicial
      debugShowCheckedModeBanner: false,
    );
    
  }
}