import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Registrar());
}

class Registrar extends StatelessWidget {
  const Registrar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registrar Usuario',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Cambia el color principal a azul
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _documentoController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _apellidoController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>(); // Agrega una clave para el formulario

    Future<void> _enviarCorreo(String correo) async {
      // Aquí deberías implementar el envío de correo utilizando la API correspondiente
    }

    void _showForm() {
      showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Form(
            key: _formKey, // Asegúrate de agregar la clave del formulario aquí
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre',
                  ),
                  validator: (value) {
                    // Implementa la validación del nombre según tus requisitos
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Resto de los TextFormField con sus respectivas validaciones
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // Aquí deberías llamar a la API para registrar el usuario
                      final registrado = await registrarUsuario(
                        _nombreController.text,
                        _documentoController.text,
                        _emailController.text,
                        _apellidoController.text,
                        _passwordController.text,
                        _confirmPasswordController.text,
                      );

                      if (registrado) {
                        _enviarCorreo(_emailController.text);

                        _nombreController.text = '';
                        _documentoController.text = '';
                        _emailController.text = '';
                        _apellidoController.text = '';
                        _passwordController.text = '';
                        _confirmPasswordController.text = '';

                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Cambia el color del botón a azul
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _showForm,
              child: const Text('Registrar Usuario'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 58, 133, 183), // Cambia el color del botón a morado
                elevation: 5,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> registrarUsuario(
    String nombre,
    String documento,
    String email,
    String apellido,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse('https://tu-api.com/registrar-usuario');
    final response = await http.post(
      url,
      body: {
        'nombre': nombre,
        'documento': documento,
        'email': email,
        'apellido': apellido,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final success = responseData['success'] ?? false;
      if (success) {
        return true;
      }
    }
    // Manejo de errores
    return false;
  }
}