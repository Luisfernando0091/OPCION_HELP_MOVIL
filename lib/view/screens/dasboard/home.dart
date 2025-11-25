import 'package:flutter/material.dart';
import 'package:option_help/view/screens/dasboard/indicadores.dart';
import 'package:option_help/view/screens/incidente/incidente.dart';
import 'package:option_help/view/screens/login/perfil/perfil.dart';
import 'package:option_help/view/screens/requerimiento/requerimiento.dart';
// Importa el nuevo widget de Indicadores

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // Propiedad clave para que el contenido se extienda detrás del TabBar flotante
        extendBody: true,
        // Color de fondo para que el TabBar se vea transparente
        backgroundColor: Colors.grey.shade50,

        // -------------------------
        //  APPBAR
        // -------------------------
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 14, 92),
          title: Row(
            children: <Widget>[
              // Imagen de Asset
              Image.asset(
                'assets/img/emoji.png',
                width: 30.0,
                height: 30.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8.0),
              const Text("Opcion Help", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),

        // -------------------------
        //  CONTENIDO (BODY)
        // -------------------------
        body: const TabBarView(
          children: [
            // PÁGINA 1: INICIO (Contiene los Indicadores)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicadores(), // <--- ¡Aquí se llama el widget!
                  // Ejemplo de contenido adicional de la página de inicio
                ],
              ),
            ),

            // PÁGINAS RESTANTES
            RequerimientosPage(),
            IncidentesPage(),
            PerfilScreen(),
          ],
        ),

        // -------------------------
        //  TABBAR FLOTANTE
        // -------------------------
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors
                  .white, // Fondo BLANCO para la barra flotante (como en tu imagen)
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(icon: Icon(Icons.home), text: "Inicio"),
                Tab(
                  icon: Icon(Icons.border_color_rounded),
                  text: "Requerimientos",
                ),
                Tab(icon: Icon(Icons.ads_click_rounded), text: "Incidentes"),
                Tab(icon: Icon(Icons.person), text: "Perfil"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
