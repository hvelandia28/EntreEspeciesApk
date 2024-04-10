import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  // Convierte la contraseña en una secuencia de bytes
  var bytes = utf8.encode(password);

  // Aplica la función hash SHA256
  var digest = sha256.convert(bytes);

  // Convierte el resultado en una cadena hexadecimal
  return digest.toString();
}