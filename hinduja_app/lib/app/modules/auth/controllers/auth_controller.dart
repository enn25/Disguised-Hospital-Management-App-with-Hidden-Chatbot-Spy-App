import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final isLoading = false.obs;

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        Get.offAllNamed(Routes.USERS);
      }
    } finally {
      isLoading.value = false;
  }
}
}