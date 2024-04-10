import 'package:flutter/material.dart';
import 'menu.dart';
import 'ListaCitas.dart'; // Importa la página de lista de citas
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(CitasApp());

class CitasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registrar Mascota'),
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
        body: CitasScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CitasScreen extends StatefulWidget {
  @override
  _CitasScreenState createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController especieController = TextEditingController();
  TextEditingController razaController = TextEditingController();
  TextEditingController generoController = TextEditingController();
  TextEditingController informacionController = TextEditingController();
  String? selectedDocumentoCliente;
  List<String> documentosClientes = [];

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener los documentos de clientes desde la API al iniciar la pantalla
    getDocumentosClientesFromAPI();
  }

  Future<void> getDocumentosClientesFromAPI() async {
    final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Clientes1');
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
        documentosClientes = responseData
            .map((data) => data['documentoCliente'].toString())
            .toList();
      });
    } else {
      print('Error al obtener los documentos de clientes. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registrar Mascota:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la Mascota'),
            ),
            TextField(
              controller: fechaNacimientoController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            TextField(
              controller: colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: especieController,
              decoration: InputDecoration(labelText: 'Especie'),
            ),
            TextField(
              controller: razaController,
              decoration: InputDecoration(labelText: 'Raza'),
            ),
            TextField(
              controller: generoController,
              decoration: InputDecoration(labelText: 'Género'),
            ),
            TextField(
              controller: informacionController,
              decoration: InputDecoration(labelText: 'Información Adicional'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDocumentoCliente,
              decoration: InputDecoration(labelText: 'Documento del Cliente'),
              onChanged: (newValue) {
                setState(() {
                  selectedDocumentoCliente = newValue;
                });
              },
              items: documentosClientes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: () async {
                  // Construir el cuerpo de la solicitud HTTP
                  Map<String, dynamic> requestBody = {
                    'documentoCliente': selectedDocumentoCliente,
                    'nombreMascota': nombreController.text,
                    'fechaNacimiento': fechaNacimientoController.text,
                    'colorMascota': colorController.text,
                    'especie': especieController.text,
                    'raza': razaController.text,
                    'genero': generoController.text,
                    'infMascota': informacionController.text,
                  };

                  // Enviar la solicitud HTTP POST a la API
                  final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Mascotas1');
                  final response = await http.post(
                    url,
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'Basic MTExNzEzODA6NjAtZGF5ZnJlZXRyaWFs',
                    },
                    body: jsonEncode(requestBody),
                  );

                  if (response.statusCode == 201) {
                    // La mascota se registró con éxito
                    // Limpia los campos después de registrar la mascota
                    nombreController.clear();
                    fechaNacimientoController.clear();
                    colorController.clear();
                    especieController.clear();
                    razaController.clear();
                    generoController.clear();
                    informacionController.clear();

                    // Navega a la página de lista de citas después de registrar una mascota
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListaCitasApp()),
                    );
                  } else {
                    // Error al registrar la mascota
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Error al registrar la mascota. Por favor, inténtalo de nuevo más tarde.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Registrar Mascota'),
              ),
          ],
        ),
      ),
    );
  }
}