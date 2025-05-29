// lib/app/modules/profile/bindings/profile_binding.dart
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}