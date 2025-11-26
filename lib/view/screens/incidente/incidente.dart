import 'package:flutter/material.dart';
import 'package:option_help/view/models/Incidente_model.dart';
import 'package:option_help/view/screens/incidente/incidentedetalles.dart';
import '../../services/incidente_service.dart';

class IncidentesPage extends StatefulWidget {
  const IncidentesPage({super.key});

  @override
  State<IncidentesPage> createState() => _IncidentesPageState();
}

class _IncidentesPageState extends State<IncidentesPage> {
  final incidenteService = IncidenteService();

  late Future<List<IncidenteModel>> futureIncidentes;

  // ⬇⬇⬇ AHORA: por defecto la fecha es HOY
  DateTime? filtroFecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    futureIncidentes = incidenteService.getIncidentes();
  }

  Future<void> _reload() async {
    setState(() {
      futureIncidentes = incidenteService.getIncidentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<IncidenteModel>>(
        future: futureIncidentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar incidentes"));
          }

          final incidentes = snapshot.data ?? [];

          // 🔽 FILTRAR POR FECHA (por defecto HOY)
          final listaFiltrada = filtroFecha == null
              ? incidentes
              : incidentes.where((i) {
                  if (i.createdAt == null) return false;
                  final fecha = DateTime.parse(i.createdAt!);
                  return fecha.year == filtroFecha!.year &&
                      fecha.month == filtroFecha!.month &&
                      fecha.day == filtroFecha!.day;
                }).toList();

          // ⚠ SI LA LISTA ESTÁ VACÍA, MOSTRAR CALENDARIO AUTOMÁTICAMENTE
          if (listaFiltrada.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Icon(Icons.inbox, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "No hay incidentes en esta fecha",
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // ⬇⬇⬇ CALENDARIO DIRECTO
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Elegir otra fecha"),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: filtroFecha ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null) {
                        setState(() {
                          filtroFecha = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: Column(
              children: [
                const SizedBox(height: 15),

                _filtroFechaWidget(),

                Expanded(
                  child: ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final item = listaFiltrada[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.titulo),
                          subtitle: Text(
                            "Estado: ${item.estado}\n"
                            "${item.usuario?.name ?? ''} ${item.usuario?.lastName ?? ''}",
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filtroFechaWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: Text(
            filtroFecha == null
                ? "Filtrar por fecha"
                : "${filtroFecha!.day}/${filtroFecha!.month}/${filtroFecha!.year}",
          ),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: filtroFecha ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );

            if (picked != null) {
              setState(() {
                filtroFecha = picked;
              });
            }
          },
        ),

        if (filtroFecha != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                filtroFecha = DateTime.now(); // volver a hoy
              });
            },
          ),
      ],
    );
  }
}
