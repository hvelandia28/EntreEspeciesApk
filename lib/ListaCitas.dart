import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu.dart';
import 'EditarCitaScreen.dart'; // Supongo que esto es tu importación correcta
import 'RegistrarCita.dart';

void main() => runApp(ListaCitasApp());

class Mascota {
  final int id;
  final int documentoCliente;
  final String nombre;
  final String fechaNacimiento;
  final String color;
  final String especie;
  final String raza;
  final String genero;
  final String informacion;

  Mascota({
    required this.id,
    required this.documentoCliente,
    required this.nombre,
    required this.fechaNacimiento,
    required this.color,
    required this.especie,
    required this.raza,
    required this.genero,
    required this.informacion,
  });

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      id: json['idMascota'],
      documentoCliente: json['documentoCliente'],
      nombre: json['nombreMascota'],
      fechaNacimiento: json['fechaNacimiento'],
      color: json['colorMascota'],
      especie: json['especie'],
      raza: json['raza'],
      genero: json['genero'],
      informacion: json['infMascota'],
    );
  }
}

class ListaCitasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Mascotas'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
        drawer: CustomDrawerMenu(),
        body: ListaCitasScreen(),
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CitasApp()), // Reemplaza CitasApp() con el widget de la pantalla de registro de mascotas
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListaCitasScreen extends StatefulWidget {
  @override
  _ListaCitasScreenState createState() => _ListaCitasScreenState();
}

class _ListaCitasScreenState extends State<ListaCitasScreen> {
  List<Mascota> mascotas = [];

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener las mascotas desde la API al iniciar la pantalla
    getMascotasFromAPI();
  }

  Future<void> getMascotasFromAPI() async {
    final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Mascotas1');
    // Agregar el token de autenticación al encabezado
  final response = await http.get(
    url,
    headers: <String, String>{
      'Authorization': 'Basic MTExNzEzODA6NjAtZGF5ZnJlZXRyaWFs',
    },
  );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      setState(() {
        mascotas = responseData.map((data) => Mascota.fromJson(data)).toList();
      });
    } else {
      // Manejo de errores, por ejemplo, mostrar un mensaje de error al usuario
      print('Error al obtener las mascotas. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('imagenes/logipa.png'), // Establece la imagen como fondo
          fit: BoxFit.cover,
        ),
      ),
      child: ListView.builder(
        itemCount: mascotas.length,
        itemBuilder: (context, index) {
          final mascota = mascotas[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4, // Elevación para dar sombra
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.grey.withOpacity(0.5)), // Color del borde con opacidad
            ),
            child: ListTile(
              title: Text(mascota.nombre),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text('Fecha de Nacimiento: ${mascota.fechaNacimiento}'),
                  Text('Color: ${mascota.color}'),
                  Text('Especie: ${mascota.especie}'),
                  Text('Raza: ${mascota.raza}'),
                  Text('Género: ${mascota.genero}'),
                  Text('Información: ${mascota.informacion}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navegar a la pantalla de edición de la mascota
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarMascotaScreen(
                        mascota: mascota,
                        onMascotaUpdated: () {
                          // Lógica para actualizar la lista de citas
                          getMascotasFromAPI();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}