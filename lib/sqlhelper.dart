import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Si no existe la base de datos, crea una nueva
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'citas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE citas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Nombre TEXT,
            fecha_hora TEXT,
            precio REAL,
            documentoCliente TEXT,
            nombreMascota TEXT
          )
        ''');
      },
    );
  }

  static Future<void> createCita(
    String nombre,
    String fechaHora,
    double precio,
    String documentoCliente,
    String nombreMascota,
  ) async {
    final db = await database;
    await db.insert(
      'citas',
      {
        'Nombre': nombre,
        'fecha_hora': fechaHora,
        'precio': precio,
        'documentoCliente': documentoCliente,
        'nombreMascota': nombreMascota,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getCitas() async {
    final db = await database;
    final List<Map<String, dynamic>> citas = await db.query('citas');
    return citas;
  }
  static Future<void> updateCita(
  int id,
  String nombre,
  String fechaHora,
  double precio,
  String documentoCliente,
  String nombreMascota,
) async {
  final db = await database;
  await db.update(
    'citas',
    {
      'Nombre': nombre,
      'fecha_hora': fechaHora,
      'precio': precio,
      'documentoCliente': documentoCliente,
      'nombreMascota': nombreMascota,
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}

static Future<void> deleteCita(int id) async {
  final db = await database;
  await db.delete(
    'citas',
    where: 'id = ?',
    whereArgs: [id],
  );
}
}
