import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => controller.isLoading.value
          ? CircularProgressIndicator()
          : ElevatedButton.icon(
              icon: Icon(Icons.g_translate),
              label: Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: controller.signInWithGoogle,
            ),
        ),
     ),
);
}
}