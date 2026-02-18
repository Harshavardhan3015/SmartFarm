import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> login(String username, String password) async {
    final url = Uri.parse("${Constants.baseUrl}/token/");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await _storage.write(key: "access", value: data["access"]);
      await _storage.write(key: "refresh", value: data["refresh"]);

      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "access");
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
