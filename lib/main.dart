import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:option_help/firebase_options.dart';
import 'package:option_help/view/screens/dasboard/home.dart';
import 'package:option_help/view/screens/incidente/incidente.dart';
import 'package:option_help/view/screens/login/login.dart';
import 'package:option_help/view/screens/login/perfil/perfil.dart';
import 'package:option_help/view/firebase_messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessagingService.initialize();

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

      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/perfil': (_) => const PerfilScreen(),
        '/incidentes': (_) => const IncidentesPage(),
      },
    );
  }
}
