import 'package:flutter/material.dart';
import 'package:option_help/view/services/incidente_service.dart';

// ---------------------------------------------------------
// CARD INDIVIDUAL
// ---------------------------------------------------------
class IndicadorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int count;

  const IndicadorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 30.0, color: color),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              "$count Generados",
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// WIDGET DE INDICADORES — FINAL
// ---------------------------------------------------------
class Indicadores extends StatefulWidget {
  const Indicadores({super.key});

  @override
  State<Indicadores> createState() => _IndicadoresState();
}

class _IndicadoresState extends State<Indicadores> {
  int totalIncidentes = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarIncidentes();
  }

  Future<void> cargarIncidentes() async {
    try {
      final service = IncidenteService();
      final incidentes = await service.getIncidentes();

      setState(() {
        totalIncidentes = incidentes.length; // 🔥 CANTIDAD REAL
        loading = false;
      });
    } catch (e) {
      print("Error cargando incidentes: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 💥 INDICADOR DE INCIDENTES
          IndicadorCard(
            title: "Incidentes General",
            icon: Icons.error_outline,
            color: Colors.red.shade700,
            count: totalIncidentes,
          ),

          const SizedBox(height: 15),

          // 💥 INDICADOR DE REQUERIMIENTOS (POR AHORA 0)
          IndicadorCard(
            title: "Requerimientos General",
            icon: Icons.playlist_add_check,
            color: Colors.green.shade700,
            count: 0,
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------
// WIDGET DE Requerimiento — FINAL
// --------------------------------------------------------