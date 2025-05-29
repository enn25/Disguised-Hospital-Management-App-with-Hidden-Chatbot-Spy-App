// lib/app/modules/users/bindings/users_binding.dart
import 'package:get/get.dart';
import '../controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(),
);
}
}