import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ListaCitas.dart';
class EditarMascotaScreen extends StatefulWidget {
  final Mascota mascota;
  final Function() onMascotaUpdated; // Callback para actualizar la lista de citas

  EditarMascotaScreen({required this.mascota, required this.onMascotaUpdated});

  @override
  _EditarMascotaScreenState createState() => _EditarMascotaScreenState();
}

class _EditarMascotaScreenState extends State<EditarMascotaScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController especieController = TextEditingController();
  TextEditingController razaController = TextEditingController();
  TextEditingController generoController = TextEditingController();
  TextEditingController informacionController = TextEditingController();
  int? selectedDocumentoCliente;
  List<int> documentosClientes = [];

  @override
  void initState() {
    super.initState();
    // Llena los controladores de texto con los valores de la mascota actual
    nombreController.text = widget.mascota.nombre;
    fechaNacimientoController.text = widget.mascota.fechaNacimiento;
    colorController.text = widget.mascota.color;
    especieController.text = widget.mascota.especie;
    razaController.text = widget.mascota.raza;
    generoController.text = widget.mascota.genero;
    informacionController.text = widget.mascota.informacion;
    // Obtener documentos de la API
    obtenerDocumentosClientes();
  }

  Future<void> obtenerDocumentosClientes() async {
    final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Clientes1');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Basic MTExNzEzODA6NjAtZGF5ZnJlZXRyaWFs',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        documentosClientes = data.map((item) => item['documentoCliente'] as int).toList();
        // Si la mascota tiene un documentoCliente existente, seleccionarlo
        selectedDocumentoCliente = widget.mascota.documentoCliente;
      });
    } else {
      print('Error al obtener los documentos de clientes. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Mascota'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 20.0),
            DropdownButtonFormField<int>(
              value: selectedDocumentoCliente,
              items: documentosClientes.map((documento) {
                return DropdownMenuItem<int>(
                  value: documento,
                  child: Text('$documento'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDocumentoCliente = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Documento Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Construye el cuerpo de la solicitud HTTP para actualizar la mascota
                Map<String, dynamic> requestBody = {
                  // Incluye todos los campos de la mascota que el usuario puede haber editado
                  'idMascota': widget.mascota.id,
                  'documentoCliente': selectedDocumentoCliente,
                  'nombreMascota': nombreController.text,
                  'fechaNacimiento': fechaNacimientoController.text,
                  'colorMascota': colorController.text,
                  'especie': especieController.text,
                  'raza': razaController.text,
                  'genero': generoController.text,
                  'infMascota': informacionController.text
                };

                // Envía la solicitud HTTP PUT a la API
                final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Mascotas1/${widget.mascota.id}');
                final response = await http.put(
                  url,
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Basic MTExNzEzODA6NjAtZGF5ZnJlZXRyaWFs',
                  },
                  body: jsonEncode(requestBody),
                );

                if (response.statusCode == 200 || response.statusCode == 204) {
                  // La mascota se actualizó con éxito
                  Navigator.pop(context); // Navega de regreso a la pantalla anterior
                  // Actualiza la lista de citas
                  widget.onMascotaUpdated();
                } else {
                  print(response.statusCode);
                  // Error al actualizar la mascota
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Error al actualizar la mascota. Por favor, inténtalo de nuevo más tarde.'),
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
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}