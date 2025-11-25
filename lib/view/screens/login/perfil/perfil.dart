import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:option_help/view/models/User_Model.dart';
import 'package:option_help/view/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UserModel? user;
  final auth = AuthService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");

    if (userJson != null) {
      setState(() {
        user = UserModel.fromJson(jsonDecode(userJson));
      });
    }
  }

  Future<void> logout() async {
    await auth.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user!.name, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Apellido:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user!.lastName, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Correo:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user!.email, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Cerrar Sesión"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
