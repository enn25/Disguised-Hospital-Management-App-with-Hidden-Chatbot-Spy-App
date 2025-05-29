// lib/app/modules/profile/controllers/profile_controller.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hinduja_app/app/modules/profile/views/profile_view.dart';
import 'package:hinduja_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final tapCount = 0.obs;
  final maxTaps = 3;

  void updateIndex(index){
  selectedIndex = index; // Update selected index
    switch (index) {
      case 1:
        Get.to(AnnouncementPage());
        break;
      case 2:
        Get.to(AccountPage());
        break;
      case 3:
        Get.to(SettingsPage());
        break;
      // Add more cases as needed for other destinations
    }    
  }

  void handleSecretTap() {
    tapCount.value++;
    
    if (tapCount.value == maxTaps) {
      // Reset tap count
      tapCount.value = 0;
      
      // Navigate to chat auth page
      Get.toNamed(Routes.AUTH);
  }
  }

  final List<String> names = [
    "Aarav",
    "Ananya",
    "Ishaan",
    "Kiara",
    "Rohan",
    "Sanya",
    "Vihan",
    "Meera",
    "Arjun",
    "Nisha"
  ];

  List<Widget> pages = [AnnouncementPage(),SettingsPage()]; 
  int selectedIndex = 0;
  final List<String> appointmentNames = [
    "Dr. B. K. Misra",
    "Dr. Ashit Hegde",
    "Dr. Asha Kapadia",
    "Dr. Anita Bhaduri",
    "Dr. Amitav Shukla",
    "Dr. Alan Almeida",
    "Dr. B. K. Nayak",
    "Dr. C. K. Ponde"
  ];

  final Random random = Random();
  late List<String> dailyAppointments;
  
  @override
  void onInit() {
    super.onInit();
    dailyAppointments = List.generate(5, (index) => appointmentNames[random.nextInt(appointmentNames.length)]);
  } 
}