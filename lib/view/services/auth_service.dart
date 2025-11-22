import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  // -------------------------
  // LOGIN
  // -------------------------
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("api_token", data["token"]);
      await prefs.setString("user", jsonEncode(data["user"]));

      // 🔹 Obtener token FCM del dispositivo
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        // Guardar token FCM en tu API
        await http.post(
          Uri.parse("$baseUrl/save-token"),
          headers: {"Accept": "application/json"},
          body: {"user_id": data["user"]["id"].toString(), "token": fcmToken},
        );
      }

      return data;
    } else {
      throw Exception(data["message"] ?? "Error al iniciar sesión");
    }
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("api_token");

    if (token != null) {
      final url = Uri.parse("$baseUrl/logout");

      await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
    }

    await prefs.remove("api_token");
    await prefs.remove("user");
  }

  // -------------------------
  // OBTENER TOKEN
  // -------------------------
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("api_token");
  }
}
