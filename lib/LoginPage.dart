import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contraseña.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title});

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _correo = '';
  String _contra = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('imagenes/logor.png', height: 140),
              const SizedBox(height: 20),
              const Text(
                'ENTRE-ESPECIES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.blue, // Cambio de color a azul
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ya puedes usar todos nuestros servicios',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Borde azul
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese su Correo';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _correoController.text = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Borde azul
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese su contraseña';
                        } else if (value.length <= 3) {
                          return 'Contraseña incorrecta';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _passwordController.text = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue, // Sombra azul
                          primary: Colors.blue, // Color de fondo azul
                        ),
                        child: const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
  if (_formKey.currentState!.validate()) {
    final correo = _correoController.text;
    final password = _passwordController.text;

    // Encripta la contraseña antes de enviarla al servidor
    final hashedPassword = hashPassword(password);

    // Realizar la solicitud HTTP para autenticar al usuario
    final url = Uri.parse('http://luissotelo04-001-site1.htempurl.com/api/Usuario');
    
    // Agregar el token de autenticación al encabezado
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Basic MTExNzEzODA6NjAtZGF5ZnJlZXRyaWFs',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      final user = users.firstWhere(
        (user) =>
            user['correo'] == correo &&
            user['contraseña'] == hashedPassword,
        orElse: () => null,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inicio de sesión exitoso'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacementNamed('/listacitas'); // Navegar a la lista de citas
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correo o contraseña incorrectos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
}