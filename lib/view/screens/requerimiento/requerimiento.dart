import 'package:flutter/material.dart';
import 'package:option_help/view/models/Requerimeinto_model.dart';
import '../../services/requerimiento_service.dart';

class Requerimiento extends StatefulWidget {
  const Requerimiento({super.key});

  @override
  State<Requerimiento> createState() => _RequerimientoState();
}

class _RequerimientoState extends State<Requerimiento> {
  final requerimientoService = RequerimientoService();
  late Future<List<RequerimeintoModel>> futureRequerimientos;

  @override
  void initState() {
    super.initState();
    futureRequerimientos = requerimientoService.getRequerimientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Requerimiento C:")),
      body: FutureBuilder<List<RequerimeintoModel>>(
        future: futureRequerimientos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final requerimientos = snapshot.data ?? [];

          if (requerimientos.isEmpty) {
            return const Center(child: Text("No hay requerimientos"));
          }

          return ListView.builder(
            itemCount: requerimientos.length,
            itemBuilder: (context, index) {
              final item = requerimientos[index];

              return Card(
                child: ListTile(
                  title: Text(item.titulo),
                  subtitle: Text("Estado: ${item.estado}"),
                  trailing: Text(item.codigo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
