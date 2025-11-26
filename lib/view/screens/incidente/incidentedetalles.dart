import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:option_help/view/models/Incidente_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IncidenteDetallePage extends StatefulWidget {
  final IncidenteModel incidente;

  const IncidenteDetallePage({super.key, required this.incidente});

  @override
  State<IncidenteDetallePage> createState() => _IncidenteDetallePageState();
}

class _IncidenteDetallePageState extends State<IncidenteDetallePage> {
  late TextEditingController solucionController;
  late String estadoSeleccionado;

  final estados = ["Pendiente", "En proceso", "A la espera", "Finalizado"];

  @override
  void initState() {
    super.initState();

    solucionController = TextEditingController(
      text: widget.incidente.solucion ?? "",
    );

    // Aseguramos que el estado inicial exista en la lista
    estadoSeleccionado = estados.firstWhere(
      (e) => e == widget.incidente.estado,
      orElse: () => estados[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // 👈 AQUÍ CAMBIAS EL COLOR DE LA FLECHA
        ),
        title: Text(
          "Incidente ${widget.incidente.codigo}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 8, 14, 92),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _headerCard(),
            const SizedBox(height: 24),
            _sectionTitle("Estado del Incidente"),
            _estadoDropdown(),
            const SizedBox(height: 24),
            _sectionTitle("Solución Aplicada"),
            _campoSolucion(),
            const SizedBox(height: 32),
            _botonGuardar(),
          ],
        ),
      ),
    );
  }

  // ---------------- UI Mejorada -------------------

  Widget _headerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.incidente.titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.incidente.descripcion,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.blueGrey.shade700,
      ),
    );
  }

  Widget _estadoDropdown() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Seleccionar Estado",
            border: OutlineInputBorder(),
          ),
          value: estadoSeleccionado,
          items: estados
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            setState(() {
              estadoSeleccionado = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _campoSolucion() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: solucionController,
          maxLines: null, // Permite múltiples líneas según contenido
          decoration: const InputDecoration(
            labelText: "Escribe la solución aplicada",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _botonGuardar() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 8, 14, 92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.save, size: 22, color: Colors.white),
        label: const Text(
          "Guardar Cambios",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            await _updateIncidente(
              id: widget.incidente.id,
              estado: estadoSeleccionado,
              solucion: solucionController.text,
            );

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Incidente actualizado correctamente"),
              ),
            );

            Navigator.pop(context, true); // Regresa y refresca la lista
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error al actualizar: $e")));
          }
        },
      ),
    );
  }

  // ---------------- API -------------------

  Future<void> _updateIncidente({
    required int id,
    required String estado,
    required String solucion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("api_token");

    final url = Uri.parse("http://10.0.2.2:8000/api/incidentes/$id");

    final body = {"estado": estado, "solucion": solucion};

    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar incidente");
    }
  }
}
