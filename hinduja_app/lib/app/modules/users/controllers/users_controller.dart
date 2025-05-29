import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hinduja_app/app/routes/app_pages.dart';
import '../../../data/services/auth_service.dart';

class UsersController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get usersStream => _firestore
    .collection('users')
    .where('email', isNotEqualTo: _authService.currentUser.value?.email)
    .snapshots();

  void signOut() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.AUTH);
}
}