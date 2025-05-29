// lib/app/modules/users/views/users_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_controller.dart';
import '../../../routes/app_pages.dart';

class UsersView extends GetView<UsersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading users'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userData = 
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: 
                    NetworkImage(userData['photoUrl'] ?? ''),
                ),
                title: Text(userData['name'] ?? 'Anonymous'),
                onTap: () => Get.toNamed(
                  Routes.CHAT,
                  arguments: [snapshot.data!.docs[index].id,userData['name']],
                ),
              );
            },
          );
        },
     ),
);
}
}