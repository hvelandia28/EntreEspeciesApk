import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
class SQLHelper {
  static get bcrypt => null;

  static Future<void> createTables(sql.Database database) async {
 

    await database.execute("""CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        documento TEXT,
        email TEXT,
        apellido TEXT,
        password TEXT,
        confirmPassword TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    String data = await getDatabasesPath();
    print(data);
    return sql.openDatabase(
      path.join(await getDatabasesPath(), 'kindacode2.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }




static Future<bool> loginUsuario(String emaill, String password) async {
  final db = await SQLHelper.db();
  var email = emaill;
  var contra = password; 
  print(email);
  print(contra);
  final user = await db.query(
    'usuarios',
    where: 'email = ? AND password = ?',
    whereArgs: [email, contra], 
  );

  
  // Verificar si se encontró al menos un usuario con las credenciales proporcionadas
  return user.isNotEmpty;
}




static Future<List<Map<String, dynamic>>> getItems() async {
  final db = await SQLHelper.db();
  return db.query('usuarios', orderBy: 'id');
}

  static Future<int> createUsuario(String nombre, String documento, String email, String apellido, String password, String confirmPassword) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'documento': documento,
      'email': email,
      'apellido': apellido,
      'password': password,
      'confirmPassword': confirmPassword,
    };

    final id = await db.insert('usuarios', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFLite Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter SQFLite Example'),
      ),
      body: const Center(
        child: Text('Your Content Goes Here'),
      ),
    );
  }
}
