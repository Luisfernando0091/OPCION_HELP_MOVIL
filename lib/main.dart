import 'package:flutter/material.dart';
import 'package:option_help/view/screens/dasboard/home.dart';
import 'package:option_help/view/screens/incidente/incidente.dart';
import 'package:option_help/view/screens/login/login.dart';
import 'package:option_help/view/screens/login/perfil/perfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpcionHelp App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // 🔹 Pantalla inicial
      initialRoute: '/login',

      // 🔹 Rutas disponibles
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/perfil': (_) => const PerfilScreen(),

        // 🔹 Nueva pantalla
        '/incidentes': (_) => const IncidentesPage(),
      },
    );
  }
}
