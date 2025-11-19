import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:option_help/view/models/Requerimeinto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequerimientoService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<RequerimeintoModel>> getRequerimientos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("api_token");

    final url = Uri.parse("$baseUrl/incidentes");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      throw Exception("Error al obtener incidentes");
    }

    final List data = jsonDecode(response.body);
    return data.map((i) => RequerimeintoModel.fromJson(i)).toList();
  }
}
