// lib/app/bindings/initial_binding.dart
import 'package:get/get.dart';
import '../data/services/auth_service.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthService as a permanent service
    Get.put<AuthService>(AuthService(), permanent: true);
    
    // Register AuthController as permanent since we need it for auth state
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // Register ProfileController since it's our initial route
    Get.put<ProfileController>(ProfileController(), permanent:true);
  }
}