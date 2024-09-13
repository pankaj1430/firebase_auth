import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: authController.logout,
          )
        ],
      ),
      body: Center(
        child: Text("Welcome to the home page!"),
      ),
    );
  }
}
