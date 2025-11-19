import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:option_help/view/models/Incidente_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncidenteService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<IncidenteModel>> getIncidentes() async {
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
    return data.map((i) => IncidenteModel.fromJson(i)).toList();
  }

  Future<void> updateIncidente({
    required int id,
    required String estado,
    required String solucion,
  }) async {
    final body = {"estado": estado, "solucion": solucion};

    final url = Uri.parse("$baseUrl/incidente/update/$id");

    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar incidente");
    }
  }
}
