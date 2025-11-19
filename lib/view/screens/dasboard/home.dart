import 'package:flutter/material.dart';
import 'package:option_help/view/screens/incidente/incidente.dart';
import 'package:option_help/view/screens/login/perfil/perfil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: const Text("Mi Panel Principal")),

        // -------------------------
        //  TABBAR ABAJO
        // -------------------------
        bottomNavigationBar: Container(
          color: Colors.blue, // color del tab bar
          child: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Inicio"),
              // Tab(icon: Icon(Icons.person), text: "Perfil"),
              Tab(icon: Icon(Icons.notifications), text: "Alertas"),
              Tab(icon: Icon(Icons.ads_click_rounded), text: "Incidentes"),
              Tab(icon: Icon(Icons.person), text: "Perfil"),
            ],
          ),
        ),

        // CONTENIDO
        body: const TabBarView(
          children: [
            Center(child: Text("Página de Inicio")),
            Center(child: Text("Notificaciones")),
            IncidentesPage(),
            PerfilScreen(),
          ],
        ),
      ),
    );
  }
}
