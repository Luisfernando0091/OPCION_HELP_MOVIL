import 'package:flutter/material.dart';
import 'package:option_help/view/models/Requerimeinto_model.dart';
import 'package:option_help/view/screens/requerimiento/requerimientodetalles.dart';
import '../../services/requerimiento_service.dart';

class RequerimientosPage extends StatefulWidget {
  const RequerimientosPage({super.key});

  @override
  State<RequerimientosPage> createState() => _RequerimientosPageState();
}

class _RequerimientosPageState extends State<RequerimientosPage> {
  final requerimientoService = RequerimientoService();

  late Future<List<RequerimeintoModel>> futureRequerimientos;

  DateTime? filtroFecha = DateTime.now(); // Por defecto HOY

  @override
  void initState() {
    super.initState();
    futureRequerimientos = requerimientoService.getRequerimientos();
  }

  Future<void> _reload() async {
    setState(() {
      futureRequerimientos = requerimientoService.getRequerimientos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RequerimeintoModel>>(
        future: futureRequerimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar requerimientos"));
          }

          final requerimientos = snapshot.data ?? [];

          // 🔽 FILTRO POR FECHA
          final listaFiltrada = filtroFecha == null
              ? requerimientos
              : requerimientos.where((r) {
                  if (r.createdAt == null) return false;
                  final fecha = DateTime.parse(r.createdAt!);
                  return fecha.year == filtroFecha!.year &&
                      fecha.month == filtroFecha!.month &&
                      fecha.day == filtroFecha!.day;
                }).toList();

          // 🟡 Si está vacío → mostrar mensaje + calendario
          if (listaFiltrada.isEmpty) {
            return Column(
              children: [
                const SizedBox(height: 80),
                const Icon(Icons.inbox, size: 80, color: Colors.grey),
                const SizedBox(height: 10),
                const Text(
                  "No hay requerimientos en esta fecha",
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
                const SizedBox(height: 20),

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
                                builder: (context) => RequerimientoDetallePage(
                                  requerimiento: item,
                                ),
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
                filtroFecha = DateTime.now();
              });
            },
          ),
      ],
    );
  }
}
