import 'package:flutter/material.dart';
import 'package:option_help/view/models/Incidente_model.dart';
import 'package:option_help/view/screens/incidente/incidentedetalles.dart';
import '../../services/incidente_service.dart';
import '../../models/Incidente_model.dart';
import '../../models/User_model.dart';

class IncidentesPage extends StatefulWidget {
  const IncidentesPage({super.key});

  @override
  State<IncidentesPage> createState() => _IncidentesPageState();
}

class _IncidentesPageState extends State<IncidentesPage> {
  final incidenteService = IncidenteService();

  late Future<List<IncidenteModel>> futureIncidentes;

  @override
  void initState() {
    super.initState();
    futureIncidentes = incidenteService.getIncidentes();
  }

  /// 🔄 Recargar lista manualmente (pull-to-refresh)
  Future<void> _reload() async {
    setState(() {
      futureIncidentes = incidenteService.getIncidentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Incidentes")),
      body: FutureBuilder<List<IncidenteModel>>(
        future: futureIncidentes,
        builder: (context, snapshot) {
          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Ocurrió un error al cargar los incidentes",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          }

          final incidentes = snapshot.data ?? [];

          // 📭 Vacío
          if (incidentes.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "No hay incidentes registrados",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          // 📋 Lista de incidentes
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: incidentes.length,
              itemBuilder: (context, index) {
                final item = incidentes[index];
                return Card(
                  child: ListTile(
                    title: Text(item.titulo),
                    subtitle: Text(
                      "Estado: ${item.estado}\n"
                      "${item.usuario?.name ?? 'Sin usuario'} "
                      "${item.usuario?.lastName ?? ''}",
                    ),

                    trailing: Text(item.codigo),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IncidenteDetallePage(incidente: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
