import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:option_help/view/models/Requerimeinto_model.dart';

class RequerimientoService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  // ============================
  // GET REQUERIMIENTOS (LISTA)
  // ============================
  Future<List<RequerimeintoModel>> getRequerimientos() async {
    final url = Uri.parse("$baseUrl/requerimientos");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 200) {
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      throw Exception("Error al obtener requerimientos");
    }

    final List data = jsonDecode(response.body);
    return data.map((i) => RequerimeintoModel.fromJson(i)).toList();
  }

  // ============================
  // CREAR REQUERIMIENTO (POST)
  // ============================
  Future<void> createRequerimiento({
    required String titulo,
    required String descripcion,
    required int userId,
  }) async {
    final url = Uri.parse("$baseUrl/requerimientos");

    final body = {
      "titulo": titulo,
      "descripcion": descripcion,
      "user_id": userId.toString(),
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 201) {
      print("ERROR BODY: ${response.body}");
      throw Exception("Error al crear requerimiento");
    }
  }

  // ============================
  // VER DETALLE (GET /ID)
  // ============================
  Future<RequerimeintoModel> getRequerimientoById(int id) async {
    final url = Uri.parse("$baseUrl/requerimientos/$id");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 200) {
      print("ERROR: ${response.body}");
      throw Exception("Requerimiento no encontrado");
    }

    final data = jsonDecode(response.body);
    return RequerimeintoModel.fromJson(data);
  }

  // ============================
  // UPDATE SOLUCIÓN (PUT)
  // ============================
  Future<void> updateRequerimiento({
    required int id,
    required String estado,
    required String solucion,
  }) async {
    final url = Uri.parse("$baseUrl/requerimientos/$id/solucion");

    final body = {"estado": estado, "solucion": solucion};

    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      print("ERROR BODY: ${response.body}");
      throw Exception("Error al actualizar requerimiento");
    }
  }
}
