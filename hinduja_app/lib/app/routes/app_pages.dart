// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.PROFILE; // Changed initial route to profile

  static final routes = [
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.USERS,
      page: () => UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
  ),
  ];
}