// // lib/app/modules/chat/controllers/chat_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../data/services/auth_service.dart';

// class ChatController extends GetxController {
//   final AuthService authService = Get.find<AuthService>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final messageText = ''.obs;
//   late final String receiverId;
//   final messages = <QueryDocumentSnapshot>[].obs;
//   final TextEditingController textController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     receiverId = Get.arguments as String;
//     _listenToMessages();
//   }

//   void _listenToMessages() {
//     // Create a composite array of both users to query messages
//     final List<String> chatUsers = [
//       authService.currentUser.value!.uid,
//       receiverId,
//     ];

//     _firestore
//         .collection('messages')
//         .where('chatId', isEqualTo: getChatId())
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       messages.assignAll(snapshot.docs);
//     }, onError: (error) {
//       print('Error listening to messages: $error');
//     });
//   }

//   // Create a consistent chat ID for both users
//   String getChatId() {
//     // Sort UIDs to ensure consistent chat ID regardless of sender/receiver
//     final List<String> sortedIds = [
//       authService.currentUser.value!.uid,
//       receiverId,
//     ]..sort();
//     return '${sortedIds[0]}_${sortedIds[1]}';
//   }

//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     try {
//       // Create message document
//       await _firestore.collection('messages').add({
//         'text': text,
//         'senderId': authService.currentUser.value!.uid,
//         'receiverId': receiverId,
//         'chatId': getChatId(), // Add consistent chat ID
//         'timestamp': FieldValue.serverTimestamp(),
//         'senderName': authService.currentUser.value!.displayName,
//         'senderPhoto': authService.currentUser.value!.photoURL,
//       });

//       // Clear input
//       textController.clear();
//       messageText.value = '';
//     } catch (e) {
//       print('Error sending message: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to send message',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   @override
//   void onClose() {
//     textController.dispose();
//     super.onClose();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hinduja_app/app/data/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class ChatController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  
  final messageText = ''.obs;
  late final String receiverId;
  late final String receiverName;
  final messages = <QueryDocumentSnapshot>[].obs;
  final TextEditingController textController = TextEditingController();
  
  // Media handling states
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    receiverId = Get.arguments[0] as String;
    receiverName = Get.arguments[1] as String;
    _listenToMessages();
  }

  void _listenToMessages() {
    // Create a composite array of both users to query messages
    final List<String> chatUsers = [
      authService.currentUser.value!.uid,
      receiverId,
    ];

    _firestore
        .collection('messages')
        .where('chatId', isEqualTo: getChatId())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      messages.assignAll(snapshot.docs);
    }, onError: (error) {
      print('Error listening to messages: $error');
    });
  }

  String getChatId() {
    final List<String> sortedIds = [
      authService.currentUser.value!.uid,
      receiverId,
    ]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _firestore.collection('messages').add({
        'text': text,
        'senderId': authService.currentUser.value!.uid,
        'receiverId': receiverId,
        'chatId': getChatId(),
        'timestamp': FieldValue.serverTimestamp(),
        'senderName': authService.currentUser.value!.displayName,
        'senderPhoto': authService.currentUser.value!.photoURL,
        'type': 'text', // Add message type for distinguishing between text and media
      });

      textController.clear();
      messageText.value = '';
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Media handling methods
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        await uploadAndSendMedia(File(image.path), 'image');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (video != null) {
        await uploadAndSendMedia(File(video.path), 'video');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e');
    }
  }

  Future<void> uploadAndSendMedia(File file, String mediaType) async {
    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Generate unique filename
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      String filePath = 'chats/${getChatId()}/$mediaType/$fileName';

      // Create upload task
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Create message document with media
      await _firestore.collection('messages').add({
        'senderId': authService.currentUser.value!.uid,
        'receiverId': receiverId,
        'chatId': getChatId(),
        'type': mediaType,
        'url': downloadUrl,
        'fileName': fileName,
        'timestamp': FieldValue.serverTimestamp(),
        'senderName': authService.currentUser.value!.displayName,
        'senderPhoto': authService.currentUser.value!.photoURL,
      });

      isUploading.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar('Error', 'Failed to upload media: $e');
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}